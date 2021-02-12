function [images_stack, images_stack_info] = normalize_frames(images_stack, images_stack_info)
% This function normalizes each frame by its average (subtraction).

if isfield(images_stack_info, '') == 0
    time_axis_projection = compute_stack_time_profile (images_stack, images_stack_info, 'avg');
end

for i_frame = 1:images_stack_info.number_of_frames
    images_stack(:,:, i_frame) = images_stack(:,:, i_frame) - time_axis_projection(1, i_frame);
end

images_stack_info.normalized = 'Yes';

end