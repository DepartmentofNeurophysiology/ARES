function [FileName_main, OutputFilesFolder] = write_tif_images (images_stack, options)
% Write the selected stack as multiple tif images in the same folder.
% The images will be names with an incrasing index and will be in the .tif
% format.
% INPUT:
% - "images_stack": a 3D matrix int or double
%   containing the raw imaging data.
%   its format is (Height, Width, Number_of_Frames).
% - "options": a struct containing the options for running the function.
%   it can be generated via the User Interface, or provided as input.
% OUTPUT:
% - "FileName_main": the name of the tif images, without their numeration.
%   (1000 images with FileName_main = "images", will be named 
%   "images_0001", "images_0002", ..., "images_1000".
% - "OutputFilesFolder": the name of the folder where the tif files are
%   saved.


%% Initialize folder and file names.
% Get number of images.
[~ ,~, number_of_frames] = size(images_stack);

% Get current folder
current_folder = pwd;

% Create folder.
disp('Please select the folder where you want to save your tif images.');
OutputFilesFolder = uigetdir('', 'Please select the tif image folder');
% Make sure the new folder is in the current matlab path.
addpath(genpath(OutputFilesFolder));

% Get main file name.
extention_tif = '.tif';
if isfield(options, 'output_FileName') == 1
    FileName_main = options.output_FileName;
elseif options.FLAG_user_ask_file_name == 1
    diag_win_prompt = {'Input the name of the output file, without extention.'};
    diag_win_name = 'Output name.';
    default_FileName = {'images_stack'};
    output_FileName_tmp = inputdlg(diag_win_prompt, diag_win_name, [1 40], default_FileName);
    FileName_main = output_FileName_tmp{1,1};
elseif options.FLAG_user_ask_file_name ~= 1
    FileName_main = 'images_stack';
end

% Move to destination folder.
cd (OutputFilesFolder);


%% Write images.
% Find necessary number of zeros.
number_of_frames_str = num2str(number_of_frames);
number_of_zeros = length(number_of_frames_str);
tmp_str = strcat('%0', num2str(number_of_zeros), 'd');
disp('Saving images stack as multiple tif files.');

error_counter = 0;
i_image_start = 1;
while error_counter < 10 % Sometimes windows prevents matlab from writing the files, let's not talk about mac...
    try
        for i_image = i_image_start:number_of_frames
            % Set current image from images_stack.
            current_image = images_stack(:,:, i_image);
            % Set current image file name, with numbered order.
            image_name_index = sprintf(tmp_str, i_image);
            current_FileName = strcat(FileName_main,'_',image_name_index,extention_tif);
            % Save image
            imwrite(current_image, current_FileName, 'Compression', 'none');
        end
        break
    catch
        warning('MATLAB failed at writing the tif images. Trying again automatically.')
        error_counter = error_counter + 1;
        i_image_start = i_image;
    end
end
if error_counter >= 10
   error('MATLAB could not save the tif images. This is a known problem associated with MATLAB. Please try again, or contact support.') 
end

cd(current_folder);
% Make sure the new folder and files are in the current matlab path.
addpath(genpath(OutputFilesFolder));
fprintf('\nTif images saved successfully in the folder:\n"%s".\n\n', OutputFilesFolder)

end