function [outputFileName, inputFileName, images_stack, images_stack_info] = load_tif_images (img)
% Load all the .tif images in the selected folder into the workspace, in
% the variable "images_stack", and load its info file into
% "images_stack_info".


%% Getting file name
% Getting current folder
current_folder = pwd; file_sep = filesep;

% Get stack name = folder containing the image series
file_name_parts = strsplit(img.info.Filename, filesep);
folder_name = file_name_parts{end - 1};
if img.info.Filename(1) == filesep
    folder_name = [file_sep, folder_name];
end
if img.info.Filename(end) == filesep
    folder_name = [folder_name, file_sep];
end
inputFileName = file_name_parts{end};

extention_tif = '.tif';
outputFileName_tmp = strcat(folder_name, '_stack');
outputFileName = strcat(outputFileName_tmp, extention_tif);


%% Loading in workspace as a single variable
% Initialize loading (load 1st image).
img_tmp = img;
current_image = imread (img_tmp.files(1).name);
images_stack(:,:,1) = current_image;

% Initialize waitbar.
prog_bar = waitbar(0, 'Loading Frames...', 'Name', 'Loading Frames...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(prog_bar, 'canceling', 0); 

% Write rest of the stack.
for i_image = 2:img_tmp.files_number
    current_image = imread (img_tmp.files(i_image).name);
    images_stack(:,:, i_image) = current_image;
    
    % Update waitbar
    waitbar(i_image/img_tmp.files_number, prog_bar, sprintf('Loading Frame: %d / %d', i_image, img_tmp.files_number));
    if getappdata(prog_bar, 'canceling')
        delete(prog_bar);
        return
    end
    
end
fprintf('Tif stack loaded in the workspace.\n\n')
delete(prog_bar);
images_stack_info = img.info;
images_stack_info.number_of_frames = img.files_number;


end