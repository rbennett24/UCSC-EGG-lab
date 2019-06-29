#############
# Written by Ryan T. Bennett June 2019
# https://people.ucsc.edu/~rbennett/
# Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0.html)
#############


#####################
# Note: it is almost *certainly* faster to process data using sox or Python or some other more efficient command line interface
# than to use this script.
#####################

form WAV file processing
	comment Where are the .wav files?
		text inDir C:\Users\510fu\Desktop\Kaq_EGG_recordings\
	comment Which channel will be processed? (Use 1 for mono recordings)
		integer targChan 1
	comment Should the extracted audio be band-pass filtered?
		boolean bandFilter 1
	comment Low threshold for band-pass filtering EGG signal (Hz):
		integer loThresh 40
	comment High threshold for band-pass filtering EGG signal (Hz):
		integer hiThresh 16000
	comment Smoothing size for band-pass filtering (Hz):
		integer smoothSize 25
endform

# Select a folder for saving the output .wav files.
# If it doesn't yet exist, create it.
folder$ = "'inDir$'\wav_for_annotation\"
if fileReadable(folder$)
	#Do nothing
else
	createDirectory(folder$)
endif


# Get the list of all .wav files in the input directory, and count.
Create Strings as file list... fileList 'inDir$'\*.wav
select Strings fileList
numfile = Get number of strings

# Iterate through each of the .wav files
for k from 1 to numfile

	# Select an individual .wav file to work with
	select Strings fileList
	wavname$ = Get string... 'k'
	Read from file... 'inDir$'\'wavname$'
	currwav$ = selected$ ("Sound")
	select Sound 'currwav$'
	
	# Extract channel
	select Sound 'currwav$'
	Extract one channel: targChan
	channel = selected ("Sound")
	
	select Sound 'currwav$'
	Remove
	
	# Filter audio
	select channel
	if bandFilter = 1
		Filter (pass Hann band): loThresh, hiThresh, smoothSize
		filterSignal = selected ("Sound")
		
		select channel
		Remove
	else
		filterSignal = selected ("Sound")
	endif
	
	# Scale amplitude
	select filterSignal
	Scale peak: 0.99
	
	# Save output
	#Save as WAV file: "'folder$''wavname$'"
	Remove
	
	select Strings fileList
	Remove
	
endfor