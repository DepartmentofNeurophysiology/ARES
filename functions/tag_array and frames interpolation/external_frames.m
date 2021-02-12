function [images_stack_new, external_frames_removed, frame_start, frame_end] = external_frames (images_stack, tag_array, FLAG_remove)
% This function removes the frames before and after the actual stimulation
% time, as it has been tagged by the tag_array.
% INPUT:
% 	- images_stack: the images stack that is being analysed.
% 	- tag_array: the tag array that is being processed, where each frame
%	  is tagged with 0 if it is to be removed from the analysis.
% 	- FLAG_remove: a logic value, = 1 if the frames marked as external
% 	are to be removed.


if nargin < 3
    FLAG_remove = 1;
end

fprintf('Removing external frames...\n...\n');
[~, ~, number_of_frames] = size(images_stack);

% Default output
frame_start = 1;
frame_end = number_of_frames;  

% Check if the film starts with frames to remove.
if tag_array(1,1) == -1
    % Start counting
    frame_start = 1;
    while tag_array(1, frame_start) == -1
        frame_start = frame_start + 1;
    end
end
% Check if the film ends with frames to remove.
if tag_array(1, end) == -1
    % Start counting
    frame_end = number_of_frames;
    while tag_array(1, frame_end) == -1
        frame_end = frame_end - 1;
    end
end
if FLAG_remove == 1
    images_stack_new = images_stack(:,:, (frame_start-1):(frame_end+1));
    [~,~,number_of_frames_new] = size(images_stack_new);
    external_frames_removed = number_of_frames - number_of_frames_new;
else
    images_stack_new = images_stack;
    external_frames_removed = 0;
end
end