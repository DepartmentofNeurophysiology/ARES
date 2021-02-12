function [images_stack, images_stack_info] = remove_tagged_frames (images_stack, images_stack_info, tag_array)
% This function removes all frames tagged with anything than 1 
% in the tag_array, and updates the images_stack.

number_of_frames = images_stack_info.number_of_frames;
image_Height = images_stack_info.Height;
image_Width = images_stack_info.Width;

i_frame_new = 1;
for i_frame = 1:number_of_frames
    if (tag_array(1, i_frame) == 1)
        images_stack_new(:,:,i_frame_new) = images_stack(:,:,i_frame);
        i_frame_new = i_frame_new + 1;
    end
end
images_stack_new_info = images_stack_info;
images_stack_new_info.number_of_frames = size(images_stack_new, 3);
clear images_stack; clear images_stack_info;
images_stack = images_stack_new; images_stack_info = images_stack_new_info;
clear images_stack_new; clear images_stack_new_info;

return
end