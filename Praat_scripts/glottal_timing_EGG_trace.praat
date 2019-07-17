#############
# Written by Ryan T. Bennett June 2019
# https://people.ucsc.edu/~rbennett/
# Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0.html)
#############


#####################
# To do:
# - Change timing information so that plain stops are included too, e.g. for registering maximum Lx signal? Or will that come out anyway from SSANOVA?
#####################

form Glottal timing
	comment Where are the .wav files and corresponding TextGrids?
		text inDir C:\Users\510fu\Desktop\Kaq_EGG_recordings\Signal_processed\EGG_extrema\
	comment Is the EGG signal channel 2?
		boolean eggChanTwo 1
	comment Which tier includes target word annotations?
		integer wdTier 1
	comment Which tier includes target segment annotations?
		integer segTier 2
	comment Which tier includes EGG maxima?
		integer eggTier 3
	comment Which tier includes release marking?
		integer relTier 4
	comment What character do glottalized stops end with?
		text glotCode '
	comment How many samples should be taken for time-normalized EGG traces?
		integer sampCount 800
	comment Datestamp output files? (Existing .txt files with same name will be deleted!)
		boolean datestamp 0
endform

# Select a folder for saving the output .txt files.
# If it doesn't yet exist, create it.
folder$ = "'inDir$'\txt_measures\"
if fileReadable(folder$)
	#Do nothing
else
	createDirectory(folder$)
endif

# Datestamp files
if datestamp = 1
	# Get a code for the date if desired.
	date$ = date$ ()
	mon$ = mid$ (date$, 5, 3)
	day$ = mid$ (date$, 9, 2)
	eggTraceOut$ = "'folder$'\EGG_traces_'mon$''day$'.txt"
	glotTimeOut$ = "'folder$'\glottal_timing_'mon$''day$'.txt"
else
	eggTraceOut$ = "'folder$'\EGG_traces.txt"
	glotTimeOut$ = "'folder$'\glottal_timing.txt"
endif

#  Delete any pre-existing versions of the text output.
deleteFile (eggTraceOut$)
deleteFile (glotTimeOut$)

# Append a header of column names to the output files
eggHeader$ = "seg'tab$'word'tab$'segContext'tab$'tokencode'tab$'speaker'tab$'segDur'tab$'StepSize'tab$'SampStart'tab$'StepEnd'tab$'step'tab$'stepPerc'tab$'Amp"
glotTimeHeader$ = "seg'tab$'word'tab$'segContext'tab$'tokencode'tab$'speaker'tab$'LxMax'tab$'LxMaxTime'tab$'LxMaxTimeNorm'tab$'MinusSegStart'tab$'MinusSegEnd'tab$'MinusRel'tab$'MinusClosureMid'tab$'RelTimeNorm'tab$'ClosMidTimeNorm"

appendFileLine: "'eggTraceOut$'", "'eggHeader$'"
appendFileLine: "'glotTimeOut$'", "'glotTimeHeader$'"


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

	# Get the identification code for the speaker.
	# This assumes that all filenames contain a numeric speaker code
	# which is the ONLY NUMERAL in the file name.
	# Thankfully Praat allows you to use regular expressions
	# (http://www.fon.hum.uva.nl/praat/manual/Regular_expressions.html)
	spkcode$ = replace_regex$("'gridname$'","\D","",0)
	
	# Open corresponding .wav file.
	Read from file... 'inDir$'\'gridname$'.wav
	currwav$ = selected$ ("Sound")
	# Extract EGG channel
	if eggChanTwo = 1
		Extract one channel: 2
		eggSignal = selected ("Sound")
	else
		Extract one channel: 1
		eggSignal = selected ("Sound")
	endif
	select Sound 'currwav$'
	Remove

	# Get the number of intervals on the segment tier
	select TextGrid 'gridname$'
	numint = Get number of intervals... 'segTier'
	
	# Iterate through intervals, and find the labels you care about.
	for i from 1 to 'numint'

		select TextGrid 'gridname$'

		# Get label of the interval you're working with.
		interval$ = Get label of interval... 'segTier' 'i'
		
		# Place conditions on labels.
		# Here: we focus on labels which end in the code used to signal glottalized segments, and on glottal stops
		if (right$(interval$,1) = glotCode$ or interval$ = "GS")
			
			select TextGrid 'gridname$'
			
			# Get timecodes for beginning and end of the interval.
			start = Get starting point... 'segTier' 'i'
			end = Get end point... 'segTier' 'i'
			
			# Get the word label
			int_mdpt = start + (end-start)/2
			intWd = Get interval at time... wdTier int_mdpt
			wdlab$ = Get label of interval... wdTier intWd
			
			# Create a unique token code for the interval.
			tokenCode$="'spkcode$'-'intWd'-'i'"

			# Code the context that the target segment is occurring in.
			startNext = Get starting point... 'segTier' 'i'+1
			endNext = Get end point... 'segTier' 'i'+1
			int_mdpt_Next = startNext + (endNext-startNext)/2
			intsegNext = Get interval at time... segTier int_mdpt_Next
			seglabNext$ = Get label of interval... segTier intsegNext
			
			# If the next interval is empty, context is VC#
			if (seglabNext$ = "" or seglabNext$ = "\t" or seglabNext$ = "\n" or seglabNext$ = "SIL" or seglabNext$ = "sil" or seglabNext$ = "sp" or seglabNext$ = "SP")
				segContext$ = "VC#"
			else
				segContext$ = "VCV"
			endif

			# Extract interval as new TextGrid, preserving times so you can work with the original audio.
			select TextGrid 'gridname$'
			Extract part: start, end, "yes"
			segTG = selected("TextGrid")
			
			# Get time of release marking during interval.
			# This presumes there is one unique release point on this tier per interval.
			select segTG
			# Verify that a release was present in the TextGrid coding
			relTest = Get high index from time: relTier, 0
			if relTest = 0
				# Do nothing
			else
				relTime = Get time of point: relTier, 1
			endif
			
			# Get time of Lx maximum during interval.
			# This assumes that there is a unique "max" point per segment.
			select segTG
			Get points: eggTier, "is equal to", "max"
			maxPts = selected ("PointProcess")
			maxTime = Get time from index: 1
			maxTimeNorm = (maxTime-start)/(end-start)
			
			# Get the maximum value of the EGG Lx
			select eggSignal
			maxVal = Get value at time: 1, maxTime, "Sinc70"
			
			# Clean up
			select maxPts
			plus segTG
			Remove

			# Compute lags
			# Lx max relative to segment onset = offset of preceding vowel
			startLag = maxTime - start
			
			# Lx max relative to segment offset = onset of preceding vowel, but only in VCV
			if segContext$ = "VCV"		
				endLag$ = string$(maxTime - end)
			else
				endLag$ = "NA"
			endif
			
			# Lx max relative to stop release if one was coded,
			# as well as the midpoint between segment onset and release
			# Verify that a release was present in the TextGrid coding
			if relTest = 0
				relLag$ = "NA"
				closureMidLag$ = "NA"
			else
				relLag$ = string$(maxTime - relTime)
				closureMidLag$ = string$(maxTime - (relTime-start)/2)
				
				# Get time-normalized measures of release and closure midpoint for VCV
				if segContext$ = "VCV"
					relTimeNorm$ = string$((relTime-start)/(end-start))
					closMidTimeNorm$ = string$( ( ((relTime-start)/2) - start)/(end-start) )
				else
					relTimeNorm$ = "NA"
					closMidTimeNorm$ = "NA"
				endif
			endif
			
			# Save results
			glotTimeResults$ = "'interval$''tab$''wdlab$''tab$''segContext$''tab$''tokenCode$''tab$''spkcode$''tab$''maxVal''tab$''maxTime''tab$''maxTimeNorm''tab$''startLag''tab$''endLag$''tab$''relLag$''tab$''closureMidLag$''tab$''relTimeNorm$''tab$''closMidTimeNorm$'"
			appendFileLine: "'glotTimeOut$'", "'glotTimeResults$'"
			
		endif

		######
		# Start producing file to keep track of time-normalized EGG traces
		# NOTE --- this is going to be really time + CPU intensive! In part because you do this for all (stop) segments.
		# You're also repeating some operations already done above, which is ugly.
		# This seems necessary to the extent that segments you want to look at timing for a subset of the things you want to look at trajectories for.
		# You could probably nest the timing stuff for glottalization inside the general stop stuff here if you really wanted, but this might be more flexible?
		######

		if (left$(interval$,1) = "p" or left$(interval$,1) = "t" or left$(interval$,1) = "k" or left$(interval$,1) = "q" or left$(interval$,2) = "ch" or left$(interval$,1) = "b" or left$(interval$,2) = "gs" or left$(interval$,1) = "P" or left$(interval$,1) = "T" or left$(interval$,1) = "K" or left$(interval$,1) = "Q" or left$(interval$,2) = "CH" or left$(interval$,1) = "B" or left$(interval$,2) = "GS" )
		
			select TextGrid 'gridname$'
			
			# Get timecodes for beginning and end of the interval.
			start = Get starting point... 'segTier' 'i'
			end = Get end point... 'segTier' 'i'
			durationms = (end-start)*1000
			
			# Get step size
			stepSize = (end-start)/sampCount
			stepSizems = stepSize*1000
			
			# Get the word label
			int_mdpt = start + (end-start)/2
			intWd = Get interval at time... wdTier int_mdpt
			wdlab$ = Get label of interval... wdTier intWd
			
			# Create a unique token code for the interval.
			tokenCode$="'spkcode$'-'intWd'-'i'"

			# Code the context that the target segment is occurring in.
			startNext = Get starting point... 'segTier' 'i'+1
			endNext = Get end point... 'segTier' 'i'+1
			int_mdpt_Next = startNext + (endNext-startNext)/2
			intsegNext = Get interval at time... segTier int_mdpt_Next
			seglabNext$ = Get label of interval... segTier intsegNext
			
			# If the next interval is empty, context is VC#
			if (seglabNext$ = "" or seglabNext$ = "\t" or seglabNext$ = "\n" or seglabNext$ = "SIL" or seglabNext$ = "sil" or seglabNext$ = "sp" or seglabNext$ = "SP")
				segContext$ = "VC#"
			else
				segContext$ = "VCV"
			endif
			

			# Get amplitude values for EGG trace
			select eggSignal
			for currStep from 1 to sampCount
				currSampStart = start+((currStep-1) * stepSize)
				currSampEnd = currSampStart + stepSize
				#print "'currSampStart''tab$''currSampEnd''newline$'
				ampVal = Get mean: 1, currSampStart, currSampEnd
				
				currStepPerc = currStep/sampCount
				
				# Save values
				eggTraceResults$ = "'interval$''tab$''wdlab$''tab$''segContext$''tab$''tokenCode$''tab$''spkcode$''tab$''durationms:3''tab$''stepSizems:3''tab$''currSampStart:7''tab$''currSampEnd:7''tab$''currStep''tab$''currStepPerc:5''tab$''ampVal:5'"
				appendFileLine: "'eggTraceOut$'", "'eggTraceResults$'"
				
			endfor	
		endif

	endfor
	
# Clean up
select TextGrid 'gridname$'
plus eggSignal
Remove
	
endfor

# Clean up
select Strings fileList
Remove