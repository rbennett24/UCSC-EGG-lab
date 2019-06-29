#############
# Written by Ryan T. Bennett June 2019
# https://people.ucsc.edu/~rbennett/
# Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0.html)
#############

################
# TO DO -- more sophisticated form of signal smoothing?
# (e.g. https://github.com/kirbyj/praatdet/blob/master/smooth.praat)
################

form EGG signal processing
	comment Where are TextGrids and associated .wav files?
		text inDir C:\Users\510fu\Desktop\Kaq_EGG_recordings\
	comment Which tier includes target word annotations?
		integer wdTier 1
	comment Is the EGG signal channel 2?
		boolean eggChanTwo 1
	comment Should the EGG signal be inverted (signal * -1)?
		boolean invert 1
	comment Low threshold for band-pass filtering EGG signal (Hz):
		integer loThresh 10
	comment High threshold for band-pass filtering EGG signal (Hz):
		integer hiThresh 1100
	comment Smoothing size for band-pass filtering (Hz):
		integer smoothSize 100
endform

# Set EGG vs. audio channels
if eggChanTwo = 1
	eggChan = 2
	audioChan = 1
else
	eggChan = 1
	audioChan = 2
endif

# Select a folder for saving the output .wav files.
# If it doesn't yet exist, create it.
folder$ = "'inDir$'\Signal_processed\"
if fileReadable(folder$)
	#Do nothing
else
	createDirectory(folder$)
endif


# Get the list of all .TextGrids files in the input directory, and count.
Create Strings as file list... fileList 'inDir$'\*.TextGrid
select Strings fileList
numfile = Get number of strings

# Iterate through each of the TextGrids
for k from 1 to numfile

	# Select an individual TextGrid to work with
	select Strings fileList
	tgname$ = Get string... 'k'
	Read from file... 'inDir$'\'tgname$'
	gridname$ = selected$ ("TextGrid", k)
	select TextGrid 'gridname$'
	
	# Open corresponding .wav file as a LongSound object (for speed)
	Open long sound file... 'inDir$'\'gridname$'.wav
	soundname$ = selected$ ("LongSound")
	
	# Get sampling frequency.
	# You need this to concatenate sounds later.
	select LongSound 'soundname$'
	sampFreq=Get sampling frequency

	# Create some silence corresponding to the buffer size.
	buffVal = 0.050
	Create Sound as pure tone... sil 2 0 buffVal sampFreq 1e-008 0.1 0.01 0.01
	sil_ID=selected("Sound")

	# Create a dummy sound
	Create Sound as pure tone... sil 2 0 0.001 sampFreq 1e-008 0.1 0.01 0.01
	dummy_ID=selected("Sound")
 
	# Create a dummy TextGrid
	To TextGrid: "x", ""
	dummy_TG_ID=selected("TextGrid")
	
	# Add matching tiers to the dummy TextGrid
	select TextGrid 'gridname$'
	tierCount = Get number of tiers
	for tnum from 1 to 'tierCount'
		if tnum > 1
			select TextGrid 'gridname$'
			intervalcheck = Is interval tier: tnum
			select dummy_TG_ID
			if intervalcheck = 1
				Insert interval tier: tnum, "x"
			else
				Insert point tier: tnum, "x"
			endif
		endif
		
		select TextGrid 'gridname$'
		currtiername$ = Get tier name: tnum
		select dummy_TG_ID
		Set tier name: tnum, currtiername$
	endfor


	# Get the number of intervals on the relevant tier
	select TextGrid 'gridname$'
	numint = Get number of intervals... 'wdTier'
	
	# Iterate through intervals, and find the labels you care about.
	for i from 1 to 'numint'

		select TextGrid 'gridname$'

		# Get label of the interval you're working with.
		interval$ = Get label of interval... 'wdTier' 'i'

		# Place conditions on labels.
		# Here: we ignore all empty labels.
		if (interval$ <> "" and interval$ <> " " and interval$ <> "\t"  and interval$ <> "\n")
			
			intervalstart = Get starting point... wdTier i
			intervalend = Get end point... wdTier i

			# Extract and process interval audio
			select LongSound 'soundname$'
			Extract part: intervalstart, intervalend, "no"
			intSound_ID=selected("Sound")

			# Process interval TextGrid
			select TextGrid 'gridname$'
			Extract part: intervalstart, intervalend, "no"
			input_TG_ID=selected("TextGrid")
			
			# Add silence at the start of the extracted interval.
			select sil_ID
			plus intSound_ID
			Concatenate
			intPadded_temp_ID=selected("Sound")
			
			# Add silence at the end of the extracted interval.
			select sil_ID
			Copy: "moreSil"
			sil_ID_new=selected("Sound")
			
			select intPadded_temp_ID
			plus sil_ID_new
			Concatenate
			intPadded_ID=selected("Sound")

			select intSound_ID
			plus intPadded_temp_ID
			plus sil_ID_new
			Remove

			# Create corresponding TextGrid by extending TextGrid start and end times
			select input_TG_ID
			Extend time: buffVal, "Start"
			Extend time: buffVal, "End"
			
			# Add audio and textgrid for extracted interval to the output files
			select dummy_ID
			plus intPadded_ID
			Concatenate
			merged_ID=selected("Sound")
			
			select dummy_ID
			plus intPadded_ID
			Remove
			select merged_ID
			dummy_ID=selected("Sound")
			
			select dummy_TG_ID
			plus input_TG_ID
			Concatenate
			merged_TG_ID=selected("TextGrid")
			
			select dummy_TG_ID
			plus input_TG_ID
			Remove
			select merged_TG_ID
			dummy_TG_ID=selected("TextGrid")
			
		endif
	endfor
	
	## Manipulate the audio and EGG channels separately.
	#
	# Split .wav file into two channels (EGG and audio)
	select dummy_ID
	Extract one channel: audioChan
	audioSignal = selected ("Sound")
	Scale peak: 0.99

	select dummy_ID
	Extract one channel: eggChan
	eggSignal = selected ("Sound")
	if invert = 1
		select eggSignal
		Formula: "self*-1"	
	endif
	# Filter EGG signal
	select eggSignal
	Filter (pass Hann band): loThresh, hiThresh, smoothSize
	filterEGGSignal = selected ("Sound")
	Scale peak: 0.99

	# Recombine files
	if eggChan = 2
		select audioSignal
		plus filterEGGSignal
		Combine to stereo
	else
		select audioSignal
		Copy: "audioCopy"
		audioCopy = selected$ ("Sound")
		select audioSignal
		Remove
		select audioCopy
		plus filterEGGSignal
		Combine to stereo
	endif
	
	# Save the file
	outputFile = selected ("Sound")
	Save as WAV file: "'folder$''gridname$'.wav"
	select dummy_TG_ID
	Save as text file: "'folder$''gridname$'.TextGrid"

	# Clean up	
	select dummy_ID
	plus audioSignal
	plus eggSignal
	plus filterEGGSignal
	plus outputFile
	plus dummy_TG_ID
	Remove
	
endfor

# Clean up
select Strings fileList
plus TextGrid 'gridname$'
plus LongSound 'soundname$'
plus sil_ID
Remove