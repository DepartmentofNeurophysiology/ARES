function [ARES_film, ARES_film_info, options] = calcium_imaging_guided_analysis (options)
% Main function for the ARES computation.
% It runs automatically after the options have been selected from the 
% User Interface, otherwise an option structure is required (it is possible
% to make one from the User Interface and then save it as a variable).
% According to the options, first the files will be loaded, then the 
% frames selection and removal/interpolation tool will be run, then the ROI
% selection, and the ARES analysis. 
% Output:
% - ARES_film: the analysed data film.
% - ARES_film_info: a structure containing important informations about the
% data analysis.
% - options: the options structure used for the analysis.
% See ReadMe file for more informations.



%%  Preliminary phase: add folders to path, preliminary checks, etc.
main_program_directory = pwd;
addpath(genpath(main_program_directory));

% Load default options, in case the options input was not provided.
if exist('options', 'var') == 0
    warning(sprintf('The options variable was not provided!\nUsing default options.\n\n'));
    options = load_default_options ();
end

% Ignore warning about the tiff images being weird on windows.
if options.deactivate_warnings == 1
    warning ('off', 'MATLAB:imagesci:tiffmexutils:libtiffWarning')
end


%%  Introductory instructions, load data

% Ask user for the data format.
window_title = 'Data format.';
string_tmp = 'Please select your data format.';
FileTypeToConvert_tmp = questdlg(string_tmp, window_title, '.tif', '.mat', '.avi/.mov', '.tif');
assert(~isempty(FileTypeToConvert_tmp), 'Operation stopped by user.');
if strcmpi(FileTypeToConvert_tmp, '.tif') == 1
    FileTypeToConvert = questdlg(string_tmp, window_title, 'Multiple .tif files', 'Single .tif file', 'Multiple .tif files');
else
    FileTypeToConvert = FileTypeToConvert_tmp;
end
assert(~isempty(FileTypeToConvert), 'Operation stopped by user.');

fprintf('\nImportant: it is advised to use .tif files, use avi/mov only if .tif is not available.\n');
fprintf('(Note that loading big files might require several Gb of RAM!)\n');
FLAG_multi_tif = 0;
FLAG_single_tif = 0;
tic

% Load data
switch FileTypeToConvert
    case 'Single .tif file' % Ask for image stack file in .tif format...
        fprintf('\nPlease select the image stack file: \n');
        [file_name_tmp, File_Path] = uigetfile('*.tif', 'Select image stack file.');
        addpath(genpath(File_Path));
        if file_name_tmp == 0
            error ('User did not select any file');
        end
        [~, ~, extention] = fileparts(file_name_tmp);
        assert(strcmp (extention, '.tif'), 'The selected file is not a valid .tif file.');
        % Load images stack matrix and get infos.
        [images_stack, images_info] = load_tiff_stack (file_name_tmp);
        images_stack_info = images_info(1);
        images_stack_info.FileName_short = strtok(file_name_tmp, '.');
        images_stack_info.FileName_extention = '.tif';
        images_stack_info.number_of_frames = numel(images_info);
        clear images_info;
        FLAG_single_tif = 1;
    case 'Multiple .tif files'
        img_directory = uigetdir('', 'Please select the tif image folder');
        addpath(genpath(img_directory));
        fprintf('\n...\nLoading Files...\n...\n')
        img = get_img_series_info (img_directory, main_program_directory);
        [file_name_tmp, ~, images_stack, images_stack_info] = load_tif_images (img);
        images_stack_info.FileName_short = strtok(file_name_tmp, '.');
        images_stack_info.FileName_extention = '.tif';
        FLAG_multi_tif = 1;
        clear img;
    case '.avi/.mov'
        extention = {'*.avi', '*.avi'; '*.mov', '*.mov'};
        [movie_file_name, movie_File_Path] = uigetfile(extention, 'Select movie file.');
        addpath(movie_File_Path);
        img_directory = movie_File_Path;
        movie_info = get_movie_info (movie_file_name);
        outputFolder = movie_to_frames_tif (movie_info);
        img = get_img_series_info (outputFolder, main_program_directory);
        [file_name_tmp, ~, images_stack, images_stack_info] = load_tif_images (img);
        images_stack_info.FileName_short = strtok(file_name_tmp, '.');
        images_stack_info.FileName_extention = '.tif';
        FLAG_multi_tif = 1;
        clear img;
    case '.mat'
        fprintf('\nPlease select the image stack file: \n');
        [file_name_tmp, File_Path] = uigetfile('*.mat', 'Select .mat file containing the film.');
        addpath(genpath(File_Path));
        if file_name_tmp == 0
            error ('User did not select any file');
        end
        [~, ~, extention] = fileparts(file_name_tmp);
        assert(strcmp (extention, '.mat'), 'The selected file is not a valid .tif file.');
        % Load images stack matrix and get infos.
        data_tmp_struct = load(strcat(File_Path, file_name_tmp));
        % Convert into standard name.
        tmp_var_1 = struct2cell(data_tmp_struct);
        tmp_var_2 = tmp_var_1{1, 1};
        images_stack = tmp_var_2;
        [images_stack_info.Height, images_stack_info.Width, images_stack_info.number_of_frames] = size(images_stack);
        images_stack_info.Format = '.mat';
        images_stack_info.FileName_short = strtok(file_name_tmp, '.');
        images_stack_info.FileName_extention = '.tif';
    otherwise
        error('Unknown data format');
end
computation_time = toc;
fprintf('Images Stack Loaded.\nTime elapsed: %f seconds.\n\n', computation_time);


%% Save input as different format?
% Save input as single tif stack?
if FLAG_single_tif ~= 1 && options.FLAG_Save_Input_as_tif_stack == 1
    img = get_img_series_info (img_directory, main_program_directory);
    [~, ~] = write_tif_images_to_stack (img, options);
    FLAG_single_tif = 1;
end


%% Tag and remove unwanted frames.
if options.FLAG_Interpolate_Remove == 1
    [tag_array, tag_fig_handle, images_stack, images_stack_info] = remove_interpolate_frames_guided (images_stack, images_stack_info, options);
    images_stack = uint16 (images_stack);
else
    images_stack_info.first_frame = 1;
    images_stack_info.FLAG_Remove_Intertrial = 'None';
    images_stack_info.FLAG_RemoveOrInterpolate = 'Ignore';
    tag_array = ones (1, images_stack_info.number_of_frames);
end


%% Normalize frames by frames average.
if options.FLAG_Normalize_Frames == 1
    [images_stack, images_stack_info] = normalize_frames(images_stack, images_stack_info);
else
    images_stack_info.normalized = 'No';
end

% Save input as multiple tif images?
if ((FLAG_single_tif == 1 && options.FLAG_Save_Input_as_tif_images == 1) || strcmpi(images_stack_info.Format, '.mat')) || (options.FLAG_Interpolate_Remove == 1) || (options.FLAG_Normalize_Frames == 1)
    fprintf('To continue, it is required to save a copy of the selected tif stack as multiple images.\n');
    [~, img_directory] = write_tif_images (images_stack, options);
    FLAG_multi_tif = 1;
    images_stack_info.first_frame = 1;
end


%% Ask user to give the output file name
default_FileName = sprintf('ARES_p%d_w%d', options.opts_ARES_film.process_order, options.opts_ARES_film.window_length);
if options.FLAG_save_output == 1 || options.FLAG_write_stack == 1 || options.FLAG_save_avi == 1
    if options.FLAG_user_ask_file_name == 1
        diag_win_prompt = {'Input the name of the output file, without extension.'};
        diag_win_name = 'Output name.';
        default_FileName_cell = {default_FileName};
        output_FileName_tmp = inputdlg(diag_win_prompt, diag_win_name, [1 40], default_FileName_cell);
        options.output_FileName = output_FileName_tmp{1, 1};
    end
else
    options.output_FileName = default_FileName;
end


%% Computing ROI.
% Close previous open figure, if any.
if exist('tag_fig_handle', 'var'); if ishandle(tag_fig_handle); close(tag_fig_handle); clear tag_fig_handle; end; end;
% Set option for Autoregression Projection (the number of lags used to compute the autocorrelation of a pixel time series)
options.opts_autocorr_matrix_on_stack.number_of_lags = images_stack_info.number_of_frames - 1;
% Computing stack projection.
[stack_proj_norm, stack_proj_info, images_stack_info] = guided_stack_proj_cmp (images_stack, images_stack_info, tag_array, options);
% In case stack_proj_norm is scalar, ask the user to input a ROI file.
if ~(isscalar (stack_proj_norm))
    % Ask user to select the ROI selection method.
    string_tmp = 'Select the ROI selection method.';
    window_title = 'ROI selection method.';
    ROI_SelectionMethod = questdlg(string_tmp, window_title, 'Automatic', 'User hand drawn', 'User custom ROI file', 'Automatic');
else
    % User custom ROI mask file.
    fprintf('\nPlease select ROI .mat file. The ROI must be a binary matrix with the same dimensions as the frames to analyse.\n');
    ROI_SelectionMethod = 'User custom ROI file';
end

switch ROI_SelectionMethod
    case 'User custom ROI file'
        [file_name_custom_ROI, File_Path_custom_ROI] = uigetfile('*.mat', 'Select the .mat file containing the ROI:');
        addpath(genpath(File_Path_custom_ROI));
        smooth_ROI_tmp = load(file_name_custom_ROI);
        if isstruct(smooth_ROI_tmp)
            smooth_ROI_tmp = struct2cell(smooth_ROI_tmp);
            smooth_ROI = smooth_ROI_tmp{1, 1};
        else 
            smooth_ROI = smooth_ROI_tmp;
        end
        clear smooth_ROI_tmp;
    case 'User hand drawn'
        smooth_ROI = user_hand_drawn_ROI (stack_proj_norm);
    case 'Automatic'
        smooth_ROI = guided_automatic_ROI (stack_proj_norm, stack_proj_info, images_stack_info, options);
    case 'Cancel'
        error 'Operation aborted by user.';
    otherwise
        error 'Something went wrong with user choosing the selection method for the ROI.'
end


%% AutoRegression residuals film

% Include option to silence warnings.
if options.deactivate_warnings == 1
    warning('off','all')
end

% AR residuals film
if options.FLAG_less_RAM == 0 % Case where all the images are in the workspace, in the variable "images_stack"
    [ARES_film, ARES_film_info] = compute_ARES_film_matrixwise (images_stack, images_stack_info, smooth_ROI, tag_array, options.opts_ARES_film);
    % Compute the background signal
    if options.FLAG_compute_ARES_background == 1 
        [selected_background_ROI] = select_random_background_sample (images_stack_info, smooth_ROI, options);
        [ARES_background] = compute_ARES_background_matrixwise (images_stack, images_stack_info, selected_background_ROI, tag_array, options.opts_ARES_film);
        ARES_film_info.ARES_background = ARES_background;
        ARES_film_info.ARES_background.number_of_background_pixels = options.number_of_background_pixels;
    end
else % Load the images in the workspace online during the analysis.
    clear images_stack;
    if FLAG_multi_tif == 0
        [~, img_directory] = write_tif_images (images_stack, options);
    end
    img = get_img_series_info (img_directory, main_program_directory);
    [ARES_film, ARES_film_info] = compute_ARES_film_matrixwise_RAM (img, images_stack_info, smooth_ROI, tag_array, options.opts_ARES_film);
    % Compute the background signal
    if options.FLAG_compute_ARES_background == 1
        [selected_background_ROI] = select_random_background_sample (images_stack_info, smooth_ROI, options);
        [ARES_background] = compute_ARES_background_matrixwise_RAM (img, images_stack_info, selected_background_ROI, tag_array, options.opts_ARES_film);
        ARES_film_info.ARES_background = ARES_background;
        ARES_film_info.ARES_background.number_of_background_pixels = options.number_of_background_pixels;
    end
end

% Reactivate warning after film computation.
if options.deactivate_warnings == 1
    warning('on','all')
end


%% Save output
clear images_stack % Free RAM.

if options.FLAG_save_output == 1
    try
        save_output_mat (ARES_film, ARES_film_info, options);
    catch
        warning ('Could not save output as .mat file.')
    end
end

if options.FLAG_write_stack == 1
    save_output_tif_stack (ARES_film, ARES_film_info, options);
end

if options.FLAG_save_avi == 1
    save_output_avi (ARES_film, ARES_film_info, options);
end

msg_title = 'ARES - Analysis complete.';
msgbox(msg_title, msg_title);
