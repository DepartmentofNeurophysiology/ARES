function outputFolder = movie_to_frames_tif (movie_info)
% This function will decompose a movie file (.avi or .mov) into its
% frames in .tif format. 
% The files will be put in a new folder which is automatically added to 
% the current path, and renamed into an ordered fashion.
% It is not advised to use the .avi or .mov formats, but the raw images.


%% Create a subfolder 
current_folder = pwd;   % Make it a subfolder of the folder of this m-file.
outputFolder = sprintf('%s/Movie_Frames_from_%s', current_folder, movie_info.Name_NoExtension);
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end


%% Split the movie in .tif images with ordered filename
movie_info_obj = movie_info.movie_info_obj;
fprintf('\n...\nConverting avi into tif images, please wait...\n...\n')

for i_frame = 1:(movie_info.NumberOfFrames)
    try
        current_frame_rgb = readFrame(movie_info_obj);
        current_frame = rgb2gray(current_frame_rgb);
        outputBaseFileName = sprintf('Frame %4.4d.tif', i_frame);
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        imwrite(current_frame, outputFullFileName, 'tif', 'Compression', 'none');
    catch
        if i_frame < (movie_info.NumberOfFrames - 1)
            warning('Converted until frame #%d out of %d identified frames in the movie.', i_frame, movie_info.NumberOfFrames);
        end
    end
end

% Adding the subfolder to current path
addpath(outputFolder); 
fprintf('\n...\n#%d frames identified and converted.\nFiles are in folder:\n%s.\n', i_frame, outputFolder)


end