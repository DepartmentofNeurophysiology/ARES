# ARES 
A description what it is and a link to the preprint should be added here

The data can be found here: https://doi.org/10.34973/c5vq-gs81

##	To start the ARES toolbox do the following:
1.	Download the entire folder "Calcium Imaging ARES Toolbox" (make sure that the start_ARES script, as well as the main and functions sub-folders are present)
2.	Open MATLAB and select the main folder "Calcium Imaging ARES Toolbox" as current folder.
(as of MATLAB 2016a, you can use the Browse for Folder button, in the top left, just above the Current Folder window)
3.	To run the analysis, write "start_ARES" in the command window, or right click on the start_ARES.m file in MATLAB's Current Folder space, and select Run.
It is recommended to have at least 8Gb of RAM, possibly 16Gb or more for long or wide field recordings.
The toolbox was tested on windows 7, windows 10, and mac systems.

###	Required file formats.
1.	A single .tif file containing all the recorded frames.
2.	Multiple .tif files (one file per frame) in the same folder.
3.	(Not recommended) A .avi or .mov file.


##	Analysis.
Using the guided procedure, the user will be presented with the following steps:
1.	The options User Interface (ARES_UI), where all the options for the analysis can be selected (see the section "Options" for more details).
Here it is also possible to save a particular set of options using the Export Config File button, and quickly re-set the options in another use of the toolbox by using the Import Config File button. Once done with the options selection, press Start Analysis.
2.	A pop-up window will appear, asking for the format of the data to analyze.
As the user selects the data type, the program will ask to specify the .tif  / .avi / .mov file or, in case the data consists of multiple .tif files, the directory where they are located.
3.	(This section will be shown only in case the option "Activate Frames Selection tools" is active)
    
    a)	First the program will try to cut "junk frames" that sometimes are before and after the actual recording (for example if the fluorescence was not activated): if no such frames exist, the first frame should be 1, and the last frame should correspond to the total number of frames.
    
| ![](https://github.com/DepartmentofNeurophysiology/ARES/blob/master/figures/ReadMe%20-%20ARES%20-%201.png) | 
|:--:| 
| *Cutting out 'junk frames'* |
    
    b)	Now the program will try tag and remove dark frames intervals (frames with no fluorescence) which are sometimes used to separate a trial from the following one. These frames are not dangerous for the analysis per-se, but they are useless to analyze and will make the analysis slower. The time average projection is computed, and a tag assigned to each frame depending on their position respect the the Threshold (black dotted line). If you do want to keep some frames to separate each trial, in the options, set "Keep # intertrials frames" to the requested number (10 by default). If you want to skip this part, set the threshold bar to the minimum.
   

| ![](https://github.com/DepartmentofNeurophysiology/ARES/blob/master/figures/ReadMe%20-%20ARES%20-%202.png) | 
|:--:| 
| *Tagging and removing dark frames* |
    
    c)	Finally, the program asks the user to identify possible luminance artifacts based on a threshold on the derivative of the signal. Once the thresholds are selected, the program displays an option to either Ignore, Delete, or Interpolate the frames identified in this way. These "artifacts" also include short groups of 1-2 isolated dark frames. The ARES signal is very sensible to novelty in the signal, and a sudden change in luminance (such as turning on and off the fluorescence) will create huge artifacts.  This is why we suggest to perform interpolation if these dark / artifact frames are present.If you want to skip this phase, simply click ok, a pop up window will appear, where you can press Ignore.
    
| ![](https://github.com/DepartmentofNeurophysiology/ARES/blob/master/figures/ReadMe%20-%20ARES%20-%203.png) | 
|:--:| 
| *Identifying artifacts* |

4.	The program might need to save the pre-processed stack as multiple tif images at this point. In this case, it will ask the user for the folder where to save them, and the name to assign to the files (does not matter for the analysis, the default one can be used).
5.	As a last step, the user should select an ROI.

    a)	Some options are given: first of all the user can load a custom ROI file, which must be a logical matrix (a matrix of zeros and ones). Otherwise a projection image should be chosen between the options given: average projection, maximum projection, autocorrelation projections.
    
    b)	As a second step a pop-up window will appear asking to choose the ROI selection method, which can be automatical or hand drawn by the user. In the Automatical method, the user should input a threshold coefficient that goes from 1 to -1 (lower values will include more pixels). The automatically selected ROI will be shown, and the user will be able to decide if to adjust the threshold, or to procede.

| ![](https://github.com/DepartmentofNeurophysiology/ARES/blob/master/figures/ReadMe%20-%20ARES%20-%204.png) | 
|:--:| 
| *In the User Hand Drawn selection, the user is to free hand draw the ROI. 
To include more than 1 non connected parts to the ROI selection, press Continue. 
Once done, press Finish.* |




6.	The program will then ask for the output file name 
(default is ARES_p<process order>_w<window size>)
Once this is assigned, the ARES analysis will start. 
The estimated time needed for the analysis will be shown in MATLAB's Command Window after the 2nd frame of the film have been computed.
After the analysis is completed, the output will be automatically saved according to the user preference selected in the options.


As a general note, you can keep track of what the program is doing by checking MATLAB's Command Window.



##	Options.

### ARES options
* Process Order = the order of the autoregressive process used to regress the pixel time series.
* Window Size = the length (in frames) of the sliding window used to compute the AutoRegression.
* Shorter time windows will be more sensitive to variations in the signal (including noise).
* Window Step = the number of frames by which the window will advance, after computing a single output frame. Increase this to improve computation time at the expense of time resolution. For optimal time resolution keep window step at 1.
* Window Type = the tipe of the window used. Rectangular will leave the time series unaltered.
* Gauss window Std = this option is used only in case the selected window  type is gaussian. It controls the standard deviation of the gaussian curve used in the window.
* Regression = controls the regression type, either linear or exponential.
* Neighbourhood Order = if different than 0, each pixel time series will be replaced with its neighbourhood average: the neighbourhood order being decided by the value assigned to this value (order 1 = 8 bordering pixels, order 2 = 24 bordering pixels, etc...)
* Ignore neighbours outside ROI = if this option is selected, pixels outside the ROI will be left out from the neighbourhood averages (note that in this case the pixel time series on the ROI border will be undersampled respect to the rest).
* Demean pixel time series = if select, each pixel time series window will be demeaned before computing the AutoRegression.
* Absolute value = if selected, the output will be the absolute value of the residuals [this will severely change the output of ARES, this signal was not fully tested]
* Compute Background = If this option is selected, after the normal analysis for the selected ROI, the average time series of the background will be computed (by selecting a number of random pixels from outside the ROI).
* Number of Background pixels = the number of random pixels selected to compute the average background time series.
* Not selectable from the UI.
* residuals_mode = can be either 'avg' or 'max'. Decides if to consider either the maximum or the average of the residuals time series. Default is 'avg', by selecting the max, the negative component will be almost entirely left out, and the result will be more affected by noise.
* matrix_dimension = how many pixel time series are grouped together in a single matrix (it is just a trick to allow a faster computational speed)

### Pre-Processing
* Activate Frames Selection tools = if selected, it will perform the frames selection / removal / interpolation pre-processing. Otherwise it will skip this part entirely. It is recommended to use it in case your recordings have large useless parts, as it will save quite some time in the ARES computation, and in case you have luminance artifacts, such as the fluorescence activating light being quickly switched on and off during the recordigs, as this might induce quite the artifacts in the ARES analysis.
* Include every frame = if selected, it will skip the frame selection part entirely.
* Remove External Frames = choses if and how to select and remove frames before and after the actual stimulation. The User option will still automatically present the starting and ending frames to be selected according to the program, the user should check if these are correct, or change them as he/she prefers. This is useful also to cut the raw film and analyze only a part of it.
* Remove Intertrial Frames = if set to auto, it will automatically remove any frame that is below the threshold set by the user, if they are with more than a set number of consecutive frames, as specified by the option Keep # intertrial frames.
* Keep # intertrial frames = the number of frames to keep as intertrial frames. Intertrial dark (with no illumination) frames are often used as a separation between different trials, this option allows to keep some of them for the same purpose.
* Derivative Threshold Multiplier = initial threshold adjuster for the identification of sudden illumination changes. It should not really matter if the user selection is active.
* Max # of consecutive dark frames = maximum number of consecutive dark frames to be interpolated in an interpolation run (derivative based)
* number of interpolation cycles = defines how many interpolation cycles will be used (~ how many consecutive dark frames to interpolate are expected in the signal)
* Normalize by frames average = normalizes each frame by the average pixel value before performing the ARES analysis.

### Output
* Save .mat = if selected, it will automatically save a .mat version of the ARES output.
* Normalize .mat = if selected, the program will normalize each frame by its average, before saving the .mat output.
* Save .tif stack = if selected, it will automatically save the ARES film output in a single .tif file.
* Normalize .tif = if selected, the program will normalize each frame by its average, before saving the .tif output.
* Save .avi = if selected, it will automatically save the ARES film output in a .avi file.
* Normalize .tif = if selected, the program will normalize each frame by its average, before saving the .avi output.
* Include static background = if selected, it will use the raw images projection as background for the .avi movie, and overlap the ARES on top of it.
* Not selectable from the UI.
* options.FLAG_show_EPhys = 1;
* options.FLAG_plot_position

### General Options (not selectable from the UI)
* deactivate_warnings = temporarily deactivate warnings from MATLAB during the execution of the ARES computation (due to possible rank deficient matrices) and the loading of the RAW .tif images (there is a known warning from MATLAB thinking the .tif images files are damaged, as of 2016b).
* FLAG_less_RAM = use roughly 40% less RAM during ARES computation (at the expense of a negligible speed decrease). It requires the program to save the RAW film as separate images first.
* FLAG_Save_Input_as_tif_stack = forces the program to save the RAW film also as a single .tif stack file. It doesn't work on lame (read -> any) Machintosh systems, so it will automatically be set to 0 (inactive) in that case.
* FLAG_Save_Input_as_tif_images = forces the program to save the RAW film also as a single .tif stack file. It is required for the FLAG_less_RAM option, so it will be automatically set to 1 (active) in that case.
* FLAG_user_custom_FileName = asks the user for the name of the .tif stack, in case this needs to be saved.


#	Contacts 

Niccolo' Calcini, PhD – n.calcini@neurophysiology.nl

Fleur Zeldenrust, PhD - f.zeldenrust@neurophysiology.nl

Prof. Tansu Celikel - celikel@neurophysiology.nl
