# EGG Workflow - Glottalized Consonants

1. Make two-channel EGG recordings

2. Use prepare_audio_for_annotation.py to extract and filter the audio channel (=channel 1) so that it's easier to label words.

3. Annotate and label target words [RTB]

4. Run forced-alignment or otherwise do segmental labelling for target segments and flanking segments

 * Before doing this, you need to extract + recombine or something the way you did with EGG_audio_signal_processing.praat. Alternatively, you should do this at stage (5), but it could bring in issues in stages (5) and/or (6). Be careful here.

5. Hand-correct segment-level labeling

 * Code stops for whether they are implosive vs. ejective? [Undergraduates]

6. Using TextGrids finalized in (5), run EGG_audio_signal_processing.praat on the original audio files recorded in (1) (or whatever their recombined structure looks like)

7. Use mark_EGG_extrema.praat to place EGG extrema on TextGrids, and mark_stop_releases.praat to add stop releases to stop intervals.

 * mark_EGG_extrema.praat allows you to look for extrema in the *derivative* of the signal instead, much like mark_stop_releases.praat does.

8. Hand-correct EGG extrema and releases [Undergraduates]

9. Run glottal_timing_EGG_trace.praat to extract information about timing of Lx signal maxima relative to segment-level landmarks, as well as time-normalized EGG traces.

10. Proceed to statistical analysis (Relativized Standard Deviation and SSANOVA/loess) in R.

 * For visualizing EGG trajectories: SSANOVA with an overlaid density plot showing the (time-normalized) position of releases for each segment. That way you can see how the distribution of release points in oral signal aligns with EGG trajectories indicating changes in contact strength (and/or vertical movement).
   
   * As scripts are currently written, this will probably involve coordinating output from two different .txt files using token codes as a way of merging timing data vs. EGG trace data. Note that both outputs of glottal_timing_EGG_trace.praat involve time-normalization of the same segments.

--------------------------
**To Do: figure out a way to call scripts directly thru R?**
