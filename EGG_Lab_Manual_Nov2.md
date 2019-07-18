# EGG Lab Manual

## Setting up a recording session

#### Based primarily on the Glottal Enterprises manual + Marc Garellek's AMP Tutorial


1. Turn the EGG on, and check that the batteries are charged
  * You can check each of the batteries by flipping the power switch to the left and the right
  * Both lights are green: 2-hour charge required
  * Either light is red: 6-hour charge required
  * The EGG MUST be turned off while charging
    * This prevents interference with the EGG signal

2. Connect the EGG to your laptop
  * Check that your computer recognizes the EGG
    * Mac: System Preferences -> Sound -> Input
    * Windows 10: Control Panel -> Hardware and Sound -> Sound -> Recording Tab / Devices
      * Properties: make sure it's set to record at 100%
  
3. Connect the microphone
  * XLR port on the back panel
  * However, Marc Garellek recommends recording the audio separately (AMP 2018)
    * We should see we like audio recorded through the machine,
    since this does not require the additional step of syncing, which adds the possibility of
    extra complications (especially for experiments, but maybe not as bad for fieldwork?)
  * Based on Ryan's Summer 2019 fieldwork in Guatemala, recording EGG signal and audio simultaneously from the machine introduces artifacts in the recordings
  * Conclusion: record audio separately and synchronize later; may need to check with Glottal Enterprises to see if they have an idea why this is happening and if it can be fixed

4. Position the electrodes
  * Plug the electrodes into the electrodes jack on the front panel
  * (Optional) Cover the electrodes with a tiny layer of electrode gel (supposed to help if the signal is weak; unclear if this does much)
    * The gel should not touch the insulating strip between the electrodes
  * Attach the electrodes to the velcro strap
    * The insulating strip should be horizontal (parallel with the strap)
    * The electrode with red wires should be on the left
  * Place the electrodes just below the Adam's apple; the electrodes should be facing one another to the extent possible
  * Have the subject hold /a/ and talk for a bit, and adjust the height of the electrodes until the "Electrode Placement/Laryngeal Movement" indicator on the front panel is centered on the green LEDs and relatively stable
    * **This is extremely important - the signal is noisy if the electrodes are too low or too high**
    * Determining the position not as straightforward as it seems, e.g. the electrodes tend to jump around during running speech
  * Secure the collar; it should be tight enough that the electrodes are always in contact with the skin
 
5. Open the recording software (Praat, Audacity)
  * Make sure to select the EGG as the input in the recording software (Praat, Audacity)
  * Stereo recording
  
6. Experiment with the output levels (optional)
  * Switches on front panel
  * Marc Garellek recommends EGG Output on Low, Audio Output on High
  * For women, EGG Output should be set to High in order to get amplitude in the same neighborhood as with men

You are now ready to record!

## Wrapping up a recording session
1. Turn the EGG off

2. Clean off the electrodes with water

3. Wipe off the electrodes with alcohol wipe pads between subjects

## Quirks of our Machine

* Signal is inverted (reversed polarity)
* 10 Hz lowpass filter
  * Cannot be changed
  * Prevents us from seeing extended glottal contact (e.g. glottal stop) in the EGG signal
* Output louder on front panel than back panel
* Introduces artifacts when recording audio and EGG simultaneously through machine
  * Related to use of back panel? **INVESTIGATE THIS**

## Analysis

### What measures are available?

#### Closed Quotient (CQ) and Open Quotient (OQ)

Two of the most common measures used in EGG research are the closed quotient (CQ) and open quotient (OQ).
These measures describe the proportion of a glottal period during which the vocal folds are closed
and open, respectively. It follows that CQ + OQ = 1.

Conceptually, the CQ and OQ are straightforward; however, there has been a lot of debate over how
to calculate these two measures (Henrich et al. 2004; Herbst, Fitch, and Švec 2010; Herbest et al. 2014, 2017). The EGG + Threshold
method demarcates the closed and open portion of the period by determining when the EGG waveform
crosses a set percentage of the maximum amplitude (Henrich et al. 2004; Herbst et al. 2017). The threshold method is problematic
as the analyst must make a choice of what threshold to use to determine that closure has taken place,
and this decision is somewhat arbitrary.

An alternative is to identify the closing and opening moments from the positive and negative peaks
in the derivative of the EGG signal (DEGG). This method is advantageous because there is usually one
clear positive and negative peak for each period in the DEGG signal, so the researcher does not need
to make a decision about the threshold to use. Moreover, DEGG-based measurements of OQ and CQ are more
closely correlated with measurements of glottal airflow (Henrich et al. 2004) and CQ based on videokymographic
endoscopy (Herbst et al. 2017). However, use of peaks in the DEGG signal may be misleading, as
contacting and de-contacting should not be thought of as single moments in time (Herbst et al. 2014).

A downside to the DEGG signal is that there may be multiple opening peaks (Herbst, Fitch, and Švec 2010). In this case,
a hybrid method should be used: closure is determined from the positive peak in the DEGG signal, while
opening is based on a threshold. The typical threshold for the hybrid method is 3/7 (Kuang and Keating 2012; Herbst et al. 2017).

CQ is extremely useful in the investigation of phonation types, since it provides an index of the degree
of glottal constriction. Tense / creaky / laryngealized registers tend to have higher CQs, while breathy
phonation has a relatively smaller CQ. Modal voice is less consistent, and may involve either high or low
OQ (DiCanio 2008). OQ is better correlated with H1-H2, a measure of glottal tension, than with H1-A3, a
measure of breathiness; as such, DiCanio (2008) suggests that EGG is potentially limited for languages
with multiple phonation types, whose differences could go beyond what EGG shows. However, Keating et al. (2011) found that CQ reliably distinguishes phonation in several languages.

CQ may also be useful for investigating strengthening and hyperarticulation. Li and Zhang (2014) found that the CQ
of vowels following a segment in domain-initial position was negatively correlated with boundary strength;
however, the data are somewhat equivocal and this was not consistent across all of the segments tested,
so more research is needed before I would recommend using CQ for this purpose.

Examples of EGG (top) and DEGG signals (bottom) from DiCanio 2008:

![example signals](https://github.com/nvh4/UCSC-EGG-lab/blob/master/dicanio_2008_example.png)


#### Speed Quotient (SQ)

Speed Quotient (SQ) is the ratio of closing duration and opening duration (Kuang and Keating 2012 and references therein).
This measure is a way of describing the symmetry of the glottal pulse, which may relate to phonation: creaky
voice should have a lower SQ, indicating a skewed pulse due to shorter closing duration, while breathy voice should
have an SQ closer to 1, reflecting similar closing and opening durations. However, SQ is reported to not
vary with phonation as reliably as CQ (Kuang and Keating 2012), and impressionistically, this measure is not used
nearly as much as the others discussed here.


#### Derivative-EGG Closure Peak Amplitude (DECPA) / Peak Increase in Contact (PIC)

DECPA / PIC is a measure of the amplitude at the positive (contacting) DEGG peak and is thought
to reflect the speed of the transition to the closure phase (Michaud 2004; Keating et al. 2011). Keating et al. (2011) found that PIC can differentiate phonation contrasts in at least some languages and that it tends
to be higher for breathy phonation. Beyond phonation, Michaud (2004) also found that DECPA correlates
with pragmatic emphasis, even in cases where F0 and intensity did not reliably indicate focus.

There are some potential limitation to the use of DECPA / PIC. Since DECPA is simply the amplitude
of the peak, the absolute value is meaningless and depends on the input level for the recording session.
This places limitations on comparisons across speakers and recording sessions. Although I don't believe
this has been discussed with respect to DECPA, the position of the larynx relative to the electrodes may
also shift during a recording session, which may affect the strength of the signal and raises further
questions about the reliability of DECPA.

#### Vertical Larynx Position

Vertical Larynx Position (VLP) is a measure of the relative height of the larynx estimated by comparing
the relative voltage from the upper and lower electrodes (Rothenberg 1992). VLP can be calibrated by
sliding the electrodes up and down the participant's neck and measuring the voltage output at
different heights (Elliot, Sundberg, and Gramming 1997; Pabst annd Sundberg 1993; Rothenberg 1992). Alternatively, VLP can be taken
from the direct output voltage without conversion into a physical measure (Iwarsson and Sundberg 1998).
In this case, comparisons should be made within subjects.

VLP can be useful for describing consonants; for instance, Elliot, Sundberg and Gramming (1997) found that a prolonged /b/
induces lowering more than other consonants. VLP could also be applied to hyper-articulation; we may
expect a greater level of larynx lowering in order to maintain voicing for a longer period of time. VLP
may also be useful in the description of sounds with a glottalic airstream mechanism. However, I have not
seen these applications of VLP discussed in the literature, and they may depend on how reliable and sensitive
the measure is.

VLP has several limitations. Since the measure relies on the relative contact of each electrode,
VLP can be influenced by factors other than laryngeal height, including tilt of the head and protrusion
of the chin (Iwarsson 2001). Despite these potential confounds, Laukkanen et al. (1999) found that VLP shows agreement
with videofluorographic measures of larynx height.

A more practical issue involves recording the output of the vertical larynx positioning meter
in tandem with the audio and EGG signals. We do not currently have a set up supporting
3-channel recording, and cannot use the measure at this time. Older Rothenberg EGGs had
a high-pass filter which could filter out frequencies below 0, 20, 30, or 40 Hz. Our machine
has a built-in high-pass filter that we cannot change. However, the low-frequency component of the signal
may correspond to larynx raising. Marc has offered to let us use UCSD's older EGG, which lets you
set the high pass filter, if we ever wanted to explore this option.


### Which measures should you use?

#### Interval-oriented analyses

If you are interested in interval-oriented analyses (e.g. phonation) then CQ and OQ are the most
widely used measures. Taking these measures from either the DEGG peaks or the hybrid method is more
common than using the threshold method on the EGG signal.

SQ may also be helpful, particularly if you are interested in quantifying the asymmetry of the glottal
pulse, but it is less consistent in distinguishing phonation types and so its use for linguistic analysis
is less clear.

DECPA / PIC is another measure to consider, but caution must be exercised given that there are no meaningful units.

#### Landmark-oriented analyses

The EGG signal can also be used to look at the opening and closing peaks in the DEGG in tandem with
audio to consider the relative timing of laryngeal gestures and consonant closure, although the literature
reviewed thus far has relatively little to say about this.

DiCanio (2012) has looked at the relative timing of voicing and oral closure, which is particularly useful in fieldwork situations
when audio recordings may be noisy. For intervocalic stops, DiCanio tallied how often
devoicing preceded, followed, or was contemporaneous with closure. This can be accomplished by looking
for the moment where periodicity begins and ends in the EGG signal; presumably, the end of periodicity
corresponds to glottal spreading. A similar method could be useful for comparing different stop
productions and for investigating hyper-articulation.

According to Marc Garellek, identifying moments of glottal closure to assess oral-laryngeal timing
(e.g. with glottalized consonants in Mayan) may be more difficult, since the transition from modal voicing
to glottal constriction is continuous, and it is hard to pin down a moment corresponding to the initiation
of glottal constriction. Ryan has the idea of using thresholding - setting a convention for identifying the "onset"
of glottal constriction by taking a certain percentage (e.g. 20) of the participant's CQ range from the
constriction period. Marc is skeptical due to individual differences in baseline CQ value and
because differences in modal and creaky voice are small to begin with. Marc also suggested plotting
CQ values over time for each word (like an f0 plot) to see if there are any turning points that
could correspond to changes in constrictions, but he does not think we would see peaks / troughs so clearly.

For stimulus design, it is recommended to have targets in intervocalic position (e.g. [VXV], X = target
consonant).


## Data Processing

#### Sample Workflow

This [sample workflow](https://github.com/nvh4/UCSC-EGG-lab/blob/master/EGG_workflow_glottalized_C.md) provides step-by-step instructions for processing and analyzing data using scripts developed by Ryan.

#### praatdet

[Praatdet](https://github.com/kirbyj/praatdet) is a set of Praat scripts created by James Kirby
at The University of Edinburgh. The scripts can process both stereo audio/EGG and mono EGG files. The scripts offer the choice of
calculating the Open Quotient either by relying solely on the dEGG signal or by using the
hybrid method which identifies the contact moment from local maxima in the dEGG signal and finds
the opening moment by applying the threshold method to the EGG signal. At this time, using the pure
threshold method for both contact and opening moments is not possible, but this is not a huge downside
since the dEGG method is preferred (Herbst et al. 2017). The script also allows the user to visually inspect
the detected peaks, which makes it easy to see how the script has treated multiple opening peaks or
whether the script has spuriously identified peaks; this functionality is not available in alternatives
like EggWorks. One last benefit is that the output is R-friendly. I recommend we use
praatdet as the basis of our data processing / analysis pipeline.

**To add: more information about how to use these scripts, and any adjustments we make to them**

#### NCSU Scripts

NCSU has an [informative page](https://phon.wordpress.ncsu.edu/lab-manual/electroglottograph/) on the basics of electroglottography
that includes Praat scripts for calculating dEGG and combining dEGG and EGG into a single recording.

While the information is useful, I have had some issues using the scripts to process creaky vowels.
A preliminary investigation suggested that there is an issue with the way in which the scripts
accomplish scaling. Should there turn out to be a problem with the praatdet scripts, it may be worth
trying to sort out this issue, but for now I recommend against using the NCSU scripts.

#### EggWorks

[EggWorks](http://www.appsobabble.com/functions/EGGWorks.aspx) is a free online program developed by UCLA.
The website is easy to use and offers a range of different measures (Speed Quotient, Closed Quotient), as
well as different ways of deriving them (e.g. thresholding, hybrid). The output is also easy to read
and R-friendly. That being said, there are some downsides. the program doesn't let you under the hood -
what you see is what you get, and there aren't any options for adapting their program to your needs. It
is also unclear how often the software is updated. For this reason, I would avoid EggWorks in favor of
using Praat scripts that we can adjust as needed.

## To-do
  * Analysis
    * As we continue to develop scripts, we can probably trim some of the discussion of other resources and incorporate more of our stuff (and how to plug Kirby's scripts into our workflow)
    * Time normalization in R
  * Figure out best way of recording audio
    * How to sync when recording separately
    * Preferred output gain
  * Does artifact issue relate to the use of front panel vs. back panel?
    * Artifact so far seen only in recordings from Guatemala, when back panel was used
  * Contact Glottal Enterprises people
    * Fix polarity reversal?
    * Get rid of built-in high pass filter?


## References
DiCanio, Christian T. 2008. “The Phonetics of Register in Takhian Thong Chong.” *Journal of the International Phonetic Association* 39 (2). Cambridge University Press: 162–88.

DiCanio, Christian T. 2012. “The Phonetics of Fortis and Lenis Consonants in Itunyoso Trique.” *International Journal of American Linguistics* 78 (2). University of Chicago Press Chicago, IL: 239–72.

Elliot, Ninni, Johan Sundberg, and Patricia Gramming. 1997. “Physiological Aspects of a Vocal Exercise.” *Journal of Voice* 11 (2). Elsevier: 171–77.

Henrich, Nathalie, Christophe d’Alessandro, Boris Doval, and Michèle Castellengo. 2004. “On the Use of the Derivative of Electroglottographic Signals for Characterization of Nonpathological Phonation.” *The Journal of the Acoustical Society of America* 115 (3). ASA: 1321–32.

Herbst, Christian T, W Tecumseh S Fitch, and Jan G Švec. 2010. “Electroglottographic Wavegrams: A Technique for Visualizing Vocal Fold Dynamics Noninvasively.” *The Journal of the Acoustical Society of America* 128 (5). ASA: 3070–8.

Herbst, Christian T, Jörg Lohscheller, Jan G Švec, Nathalie Henrich, Gerald Weissengruber, and W Tecumseh Fitch. 2014. “Glottal Opening and Closing Events Investigated by Electroglottography and Super-High-Speed Video Recordings.” *Journal of Experimental Biology* 217 (6). The Company of Biologists Ltd: 955–63.

Herbst, Christian T, Harm K Schutte, Daniel L Bowling, and Jan G Svec. 2017. “Comparing Chalk with Cheese-the Egg Contact Quotient Is Only a Limited Surrogate of the Closed Quotient.” *Journal of Voice* 31 (4). Elsevier: 401–9.

Iwarsson, Jenny. 2001. “Effects of Inhalatory Abdominal Wall Movement on Vertical Laryngeal Position During Phonation.” *Journal of Voice* 15 (3). Elsevier: 384–94.

Iwarsson, Jenny, and Johan Sundberg. 1998. “Effects of Lung Volume on Vertical Larynx Position During Phonation.” *Journal of Voice* 12 (2). Elsevier: 159–65.

Keating, Patricia, Christina Esposito, Marc Garellek, Sameer Ud Dowla Khan, and Jianjing Kuang. 2011. “Phonation Contrasts Across Languages.” In *Proceedings of the International Conference of Phonetic Sciences (ICPHS)* 17. Citeseer.

Kuang, Jianjing, and Patricia Keating. 2012. “Glottal Articulations of Phonation Contrasts and Their Acoustic and Perceptual Consequences.” *UCLA Working Papers in Phonetics* 111: 123–61.

Laukkanen, Anne-Maria, Raija Takalo, Erkki Vilkman, Jaana Nummenranta, and Tero Lipponen. 1999. "Simultaneous Videoflurographic and Dual-Channel Electroglottographic Registration of the Vertical Laryngeal Position in Various Phonatory Tasks." In *Journal of Voice* 13 (1). Elsevier: 60-71.

Li, Yinghao, and Jinghua Zhang. 2014. “An Electropalatographic and Electroglottographic Study on Domain-Initial Strengthening in Korean.” In *Chinese Spoken Language Processing (ISCSLP)*, 406–10. IEEE.

Michaud, Alexis. 2004. “A Measurement from Electroglottography: DECPA, and Its Application in Prosody.” In *Speech Prosody 2004, International Conference*.

Pabst, Friedemann, and Johan Sundberg. 1993. “Tracking Multi-Channel Electroglottograph Measurement of Larynx Height in Singers.” *Scandinavian Journal of Logopedics and Phoniatrics* 18 (4). Taylor & Francis: 143–52.

Rothenberg, Martin. 1992. “A Multichannel Electroglottograph.” *Journal of Voice* 6 (1). Elsevier: 36–43.
