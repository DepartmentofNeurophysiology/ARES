function options = load_default_options (images_stack_info)
% This function sets all the options needed for the toolbox to run, in the 
% case no option structure was provided.


%% General options
% Temporarily deactivate warnings from matlab. If warnings are active,
% there might be quite a spam in the command window during the regression,
% if rank deficient matrices are found (common).
options.deactivate_warnings = 1;

% Use roughly half the RAM, but slightly slower.
% 1 = Yes, 0 = No.
options.FLAG_less_RAM = 1;

% Save a copy of the input as a single .tif film? 
% (will be saved in the main program folder) 
% This doesn't work on MAC, will automatically set to 0.
% 1 = Yes, 0 = No.
options.FLAG_Save_Input_as_tif_stack = 0;

% Save a copy of the input as multiple .tif images?
% 1 = Yes, 0 = No. 
% This is required for the less RAM usage options, 
% will automatically set to 1.
options.FLAG_Save_Input_as_tif_images = 0;

% Ask user the name for the tif stack, in case this is saved.
options.FLAG_user_custom_FileName = 1;


%% Options for Pre-Processing (automatic frame removal / interpolation / normalization).
% Perform interpolation? 1 = Yes, 0 = No.
options.FLAG_Interpolate_Remove = 0;
% Normalize frames by average pixel value (luminance)?
options.FLAG_Normalize_Frames = 0;
% Remove frames before and after stimulation? 
% 'Auto' = automatic removal.
% 'User' = user manually inputs starting and ending frames.
% 'None' = use every frame.
options.FLAG_remove_external_frames = 'User';
% Remove non stimulation frames present between each trial iteration? 
% 'Auto' = automatic removal.
% 'User' = user manually inputs starting and ending frames.
% 'None' = use every frame.
options.FLAG_Remove_Intertrial = 'Auto'; % ATTENTION: 'User' option is not implemented yet.
% Keep some down frames as a marker for the new trial. (this is actually the max # of frames to keep, if there are less, that number will be taken)
options.InterTrialFrames_to_keep = 10;
% Maximum consecutive dark frames to be interpolated in the interpolation run (derivative based).
options.tag_darkness_max_length = 3; 
% Threshold adjuster for the identification of the dark (no illumination) frames.
options.tag_derivative_threshold_modifier = 0.3;
% Value used as std multiplier to separate up from down frames. Not really important if UI is active. (Default = 2.3) NOTE: Change this value in case the slider in the guided  version does not appear.
options.std_multiplier_up_down = 1;
% Interpolation cycles: defines how many interpolation cycles will be used (~how many consecutive dark frames to interpolate are expected in the signal)
options.number_of_interpolation_cycles = 4;


%% Options for ROI selection.

% Options for Autocorrelation Film (used to compute the autocorrelation
% projection).

% The number of lags used to compute the autocorrelation of a pixel time series.
if nargin > 0
    options.opts_autocorr_matrix_on_stack.number_of_lags = images_stack_info.number_of_frames - 1;
end

% The coefficient multiplying the image projection standard deviation, when
% computing the threshold for the ROI selection. 
% Values must be between -1 and +1
% Higher value means less pixels included in the ROI.
options.ROI_StdThreshold = 0.4;


%% Options for film visualization / writing / saving.
% Ask user for the output file name? 1 = Yes, 0 = will generate one automatically.
options.FLAG_user_ask_file_name = 1;

% Save analysis output as .mat file? 1 = Yes, 0 = No.
options.FLAG_save_output = 1;
% Save output film as a tif image stack? (gray scale) 1 = Yes, 0 = No.
options.FLAG_write_stack = 1;
% Save output film as .avi file? 1 = Yes, 0 = No.
options.FLAG_save_avi = 1;
% Normalize each frame for its average value before writing the stack?  1 = Yes, 0 = No.
% For saving the .tif file
options.FLAG_normalize_tif_output = 1; 
% For saving the .avi file
options.FLAG_normalize_avi_output = 1;
% For saving the .mat file
options.FLAG_normalize_mat_output = 0; 
% Use the stack projection as background for the .avi movie?  1 = Yes, 0 = No.
options.avi_background_static_image = 1;
% Add ElectroPhysiology to the .avi film?
options.FLAG_show_EPhys = 0;
% Where to show E-Phys? Under the film, or overlayed?
options.FLAG_plot_position = 'overlay'; % 'bottom' or 'overlay' or 'overlay minimal'


%% Options for Autoregression residuals analysis.
% Include every frame? (tag_array will be an array of 1s)
options.opts_ARES_film.FLAG_blank_tag_array = 1;
% Shape of the window: 'rectangular', 'gaussian', 'hanning', 'hamming', 'blackman'
options.opts_ARES_film.window_type = 'rectangular';
% (Used only in case window_type = 'gaussian'): gaussian standard deviation
options.opts_ARES_film.window_g_std = 6;
% Window advance step. Use 1 for maximal time resolution.
options.opts_ARES_film.window_advance_step = 1;
% Window length
options.opts_ARES_film.window_length = 25;
% Autoregression process order
options.opts_ARES_film.process_order = 3;
% Regression mode ('linear' or 'exponential')
options.opts_ARES_film.reg_mode = 'linear';
% How many pixel time series to group together in a single matrix? 
% (might affect computation speed)
options.opts_ARES_film.matrix_dimension = 50;
% Consider absolute value of residuals? 1 = Yes, 0 = No.
options.opts_ARES_film.absolute_value = 0;
% Demean time series before AutoRegression? 1 = Yes, 0 = No.
options.opts_ARES_film.FLAG_demean = 0;
% Consider average or maximum for each residuals time series? 'avg', 'max'
options.opts_ARES_film.residuals_mode = 'avg';
% If > 0, each pixel time series will be the average of its neighbourhoods (taking the Nth order neighbours).
options.opts_ARES_film.opts_neighbourhood_ts.neighbourhood_order = 1; 
% Exclude pixels outside the ROI from the neighbourhood?
options.opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI = 0;


% Compute the background average?
options.FLAG_compute_ARES_background = 1;
% Number of random pixels sampled from the background used to compute the average.
options.number_of_background_pixels = 500;






%% Options for ElectroPhysiology loading 
% (relevant only in case the user wants to load it to add its visualization in the .avi film)

% Is the user using the test dataset provided with the toolbox?
options.options_prepare_EPhys.FLAG_test_data = 1;
% % % The following are relevant only in case the test dataset is being used. % % %


% Is the user working with the InVivo dataset, or the inVitro one?
options.options_prepare_EPhys.FLAG_InVivo = 0;
% How many repetitions to display? (relevant in case of InVitro)
options.options_prepare_EPhys.number_of_repetitions_selected = 1;
% The repetition of the CC Step to be displayed (relevant in case of InVitro).
options.options_prepare_EPhys.selected_repetition = 1;
% Invert 10th with 1st CC step, in E-Phys Data (in the InVitro data, often the last repetition is inverted...)
options.options_prepare_EPhys.FLAG_invert_1st_10th_CC_steps = 1;
% Number of current step injections in a protocol repetition (relevant in case of InVitro).
options.options_prepare_EPhys.number_of_sweeps_per_repetition = 10;
% Time unit
options.options_prepare_EPhys.time_unit = 's';








%% Please do not change these lines, they are control lines.
% Automatically change options in case mac is detected.
if ismac == 1, options.FLAG_Save_Input_as_tif_stack = 0; end 
% Automatically change options in case the less RAM option is selected.
if options.FLAG_less_RAM == 1, options.FLAG_Save_Input_as_tif_images = 1; end



end
