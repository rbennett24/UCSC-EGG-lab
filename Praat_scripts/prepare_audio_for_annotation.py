################
# Written by Ryan T. Bennett June 2019
# https://people.ucsc.edu/~rbennett/
# Licensed under the GNU General Public License v3.0 (https://www.gnu.org/licenses/gpl-3.0.html)
################


################
# Notes
################
# Make sure that sox is installed and that the sox folder has been permanently added to PATH.
# If not in path, use: <setx PATH "C:\Program Files (x86)\sox-14-4-2"1> in the windows command line.
#
# You may have to restart your editor/IDE/whatever so that sox can be found.
#
# This script first extracts one channel of the audio, then high-pass filters it, then effectively low-pass filters it by downsampling.
# If you try to band-pass filter it directly, some programs (e.g. Praat) get confused about the sampling rate.


################
# Modules
################

import os, subprocess # For file/folder management and sending commands to the command line


################
# Options
################

username = "510fu"
inputDir = "C:/Users/%s/Desktop/Kaq_EGG_recordings/" % username
outputDir = inputDir + "/audio_for_chunking/"

audioChan = 1 # Which channel in the input file is the audio channel you want to process? (1 = left)

loThresh = 50 # Low threshold for bandpass filtering
hiThresh = 12500 # High threshold for bandpass filtering (=resampling rate)
shoulder = 15 # Shoulder for bandpass filtering (i.e. size of skirt where sound is attenuated rather than nullified)

# Set options so that os.Popen won't open a new console every time you send a command to the command line.
# https://stackoverflow.com/questions/17833498/pysox-under-windows
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW


################
# Process
################

# Create output folder if needed
if os.path.exists(outputDir):
    pass # Do nothing
else:
    os.mkdir(outputDir)

# Get all .wav files to process
wavInput = [w for w in os.listdir(inputDir) if w.endswith('.wav')]

# Send command to sox to process audio
for w in wavInput:
    inputLoc = os.path.join(inputDir, w)
    outputLoc = os.path.join(outputDir, w)

    soxcmd = "sox %s -r %d %s remix %d sinc -t %d %d" % (inputLoc,hiThresh,outputLoc,audioChan,shoulder,loThresh)
    subprocess.run(soxcmd,startupinfo=startupinfo)
