#############
# Written by Ryan T. Bennett June 2019
# https://people.ucsc.edu/~rbennett/
# Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0.html)
#############

form EGG extrema marking
	comment Where are TextGrids and associated .wav files?
		text inDir C:\Users\510fu\Desktop\Kaq_EGG_recordings\Signal_processed\
	comment What tier are the target segments on?
		integer seg_tier 2
	comment What character do glottalized stops end with?
		text glotCode '
	comment Is the EGG signal channel 2? (Uncheck for mono EGG recordings)
		boolean eggChanTwo 1
	comment Mark EGG minima along with maxima?
		boolean markMinima 0
	comment Use dEGG derivative signal to mark extrema?
		boolean dEGGtest 0
	comment Restrict extrema to middle 80% of the consonant interval?
		boolean trimEdges 1
endform

# Set the tier where EGG extrema will be marked.
extremaTier = seg_tier+1


# Select a folder for saving the output .TextGrid files.
# If it doesn't yet exist, create it.
folder$ = "'inDir$'\EGG_extrema\"
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
	
	# Open corresponding .wav file.
	Read from file... 'inDir$'\'gridname$'.wav
	
	# Extract EGG channel
	if eggChanTwo = 1
		Extract one channel: 2
		eggSignal = selected ("Sound")
	else
		Extract one channel: 1
		eggSignal = selected ("Sound")
	endif
	
	# Use derivative signal if you want.
	if dEGGtest = 1
		select eggSignal
		Formula: "self [col+1] - self [col]"
	endif


	# Get the number of intervals on the relevant tier
	select TextGrid 'gridname$'
	numint = Get number of intervals... 'seg_tier'

	# Add a point tier keeping track of intensity extrema
	Insert point tier: extremaTier, "EGG extrema"
	
	# Iterate through intervals, and find the labels you care about.
	for i from 1 to 'numint'

		select TextGrid 'gridname$'

		# Get label of the interval you're working with.
		interval$ = Get label of interval... 'seg_tier' 'i'

		# Place conditions on labels.
		# Here: we ignore all empty labels.
		# if (interval$ <> "" and interval$ <> " " and interval$ <> "\t"  and interval$ <> "\n")
		# Here, we focus on glottalized stops.
		if (right$(interval$,1) = glotCode$ or interval$ = "GS")
			# Get timecodes for beginning and end of the interval.
			start = Get starting point... 'seg_tier' 'i'
			end = Get end point... 'seg_tier' 'i'
			
			if trimEdges = 1
				duration = end - start
				start = start + duration*0.1
				end = end - duration*0.1
			endif
			
			# Find amplitude min/max, add points.
			select eggSignal
			intMax = Get time of maximum: start, end, "Sinc70"
			select TextGrid 'gridname$'
			Insert point: extremaTier, intMax, "max"
			
			if markMinima = 1
				select eggSignal
				intMin = Get time of minimum: start, end, "Sinc70"
				select TextGrid 'gridname$'
				Insert point: extremaTier, intMin, "min"
			else
				# Do nothing
			endif
		endif
	endfor

	# Save the file
	Save as text file: "'folder$'\'gridname$'.TextGrid"

	# Clean up
	select TextGrid 'gridname$'
	plus Sound 'gridname$'
	plus eggSignal
	Remove

endfor

# Clean up
select Strings fileList
Remove