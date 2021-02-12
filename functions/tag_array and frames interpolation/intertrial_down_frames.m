function [images_stack_new, images_stack_info_new, number_of_removed_frames] = intertrial_down_frames (images_stack, tag_array, images_stack_info, options)
% This function removes the frames before and after the actual stimulation
% time, as it has been tagged by the tag_array.

if nargin < 3
    options.InterTrialFrames_to_keep = 10;
end

InterTrialFrames_to_keep = options.InterTrialFrames_to_keep;
down_number_threshold = InterTrialFrames_to_keep;
[dim1, dim2, number_of_frames] = size(images_stack);

fprintf('\nRemoving inter-trial frames...\n...\n');

% Make tag array for frames to remove.
tag_array_erase = zeros(1, number_of_frames);
down_counter = 1;
for i_frame = 1:(number_of_frames - InterTrialFrames_to_keep)
% Check whether the tag array is down.
    if tag_array(1, i_frame) == -1 && ((i_frame + down_counter) < number_of_frames)
        % Start counting
        down_counter = 1;
        while (tag_array(1, i_frame + down_counter) == -1) && ((i_frame + down_counter) < number_of_frames)
            down_counter = down_counter + 1;
        end
        if down_counter > down_number_threshold
            tag_array_erase(1, (i_frame + InterTrialFrames_to_keep):(i_frame + down_counter)) = 1;
        end
        i_frame = i_frame + down_counter;
    end
end

number_of_removed_frames = numel(find(tag_array_erase));

% Make new images_stack, without culprit frames.
images_stack_new = zeros(dim1, dim2, number_of_frames - number_of_removed_frames);
j = 1;
for i = 1:number_of_frames
    if tag_array_erase(1, i) == 0
        images_stack_new(:, :, j) = images_stack(:, :, i);
        j = j + 1;
    end
end
images_stack_info_new = images_stack_info;
[~, ~, images_stack_info_new.number_of_frames] = size(images_stack_new);

fprintf('%d Inter-trial frames removed.\n\n', number_of_removed_frames);

end