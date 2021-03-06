#############
# Written by Ryan T. Bennett June 2019
# https://people.ucsc.edu/~rbennett/
# Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0.html)
#############

form Stop release marking
	comment Where are TextGrids and associated .wav files?
		text inDir C:\Users\510fu\Desktop\Kaq_EGG_recordings\Signal_processed\EGG_extrema\
	comment What tier are the target segments on?
		integer seg_tier 2
	comment What character do glottalized stops end with?
		text glotCode '
	comment Is the audio signal channel 1?
		boolean audioChanOne 1
	comment Look for implosive releases (= minima) for [ɓ], rather than egressive release?
		boolean implosiveB 1
endform

##################################################

# Select a folder for saving the output .TextGrid files.
# If it doesn't yet exist, create it.
folder$ = "'inDir$'\Releases\"
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
	gridname$ = selected$ ("TextGrid")
	select TextGrid 'gridname$'
	
	# Set the tier where releases will be marked (last tier)
	tierCount = Get number of tiers
	relTier = tierCount+1
	
	# Open corresponding .wav file.
	Read from file... 'inDir$'\'gridname$'.wav
	
	# Extract audio channel
	if audioChanOne = 1
		Extract one channel: 1
		audioSignal = selected ("Sound")
	else
		Extract one channel: 2
		audioSignal = selected ("Sound")
	endif
	
	# Convert audio signal to derivative of that signal -- it's going to be better, if not perfect, for finding releases.
	select audioSignal
	Formula: "self [col+1] - self [col]"

	# Get the number of intervals on the relevant tier
	select TextGrid 'gridname$'
	numint = Get number of intervals... 'seg_tier'

	# Add a point tier keeping track of releases
	Insert point tier: relTier, "Releases"
	
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
			
			# Find amplitude min/max, add points.
			select audioSignal
			if implosiveB = 0
				intMax = Get time of maximum: start, end, "Sinc70"
				select TextGrid 'gridname$'
				Insert point: relTier, intMax, "R"
			elif (left$(interval$,1) = "b" or left$(interval$,1) = "B")
				intMin = Get time of minimum: start, end, "Sinc70"
				select TextGrid 'gridname$'
				Insert point: relTier, intMin, "R"
			endif
			
		endif
	endfor

	# Save the file
	Save as text file: "'folder$'\'gridname$'.TextGrid"

	# Clean up
	select TextGrid 'gridname$'
	plus Sound 'gridname$'
	plus audioSignal
	Remove

endfor

# Clean up
select Strings fileList
Remove