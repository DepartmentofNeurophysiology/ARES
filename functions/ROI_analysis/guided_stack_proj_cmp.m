function [stack_proj_norm, stack_proj_info, images_stack_info] = guided_stack_proj_cmp (images_stack, images_stack_info, tag_array, options)
% This function guides the user in choosing the stack projection used to
% compute the ROI (the image to be thresholded).
% INPUT:
% - "images_stack", a 3D matrix int or double
%   containing the raw imaging data.
%   its format is (Height, Width, Number_of_Frames).
% - "images_stack_info", a struct variable containing the infos about 
%   the image_stack. It is automatically produced by the toolbox when
%   loading or modifying the images_stack used.
% -  "tag_array" is an array containing tags for each of the
%   film frames: tags might take different values, but every tag different
%   than 1 will be skipped in these computations.
%   For more info on the tag_array vector check the corresponding 
%   generating function "tag_intertrial_frames" included the toolbox.
%   To use every frame, generate an array of ones with the correct length.
% OUTPUT:
% - "stack_proj_norm": a 2D double image, which is the selected
%   projection of the input images stack, normalized by its maximum value.
% - "stack_proj_info": a struct which contains info about 
%   the stack projection.
% - "images_stack_info": the struct containing infos about the raw
%   data, updated with the projection infos.



% Build the user interface.
string_tmp = 'Select which stack projection to use to select ROI, or load an external ROI:';
window_title = 'Select stack projection for the ROI.';
dlgOptions{1,1} = 'Avg projection';
dlgOptions{1,2} = 'Max projection';
dlgOptions{1,3} = 'Load Custom ROI .mat file';
dlgOptions{1,4} = 'Pixelwise (avg) autocorrelation projection';
dlgOptions{1,5} = 'Pixelwise (max) autocorrelation projection';
dlgOptions{1,6} = 'Cancel';

StackProjectionSelected = bttnChoiseDialog(dlgOptions, window_title, 'Max projection', string_tmp);

% Check the user selection and compute.
switch StackProjectionSelected
    case 1
        [stack_projection, stack_proj_info] = compute_img_stack_projection(images_stack, 'avg');
    case 2
        [stack_projection, stack_proj_info] = compute_img_stack_projection(images_stack, 'max');
    case 3  % User custom ROI
        % Compute max projection anyway and save it in the info file.
        [stack_projection, stack_proj_info] = compute_img_stack_projection(images_stack, 'max');
        images_stack_info.stack_projection_type = stack_proj_info.type;
        images_stack_info.stack_projection = stack_projection;
        images_stack_info.stack_proj_info = stack_proj_info;
        % Skip the stack projection computation, go to ROI selection.
        stack_proj_norm = NaN;
        return
    case 4
        [stack_projection, stack_proj_info] = compute_pixelwise_autocorr_projection (images_stack, images_stack_info, 'avg', tag_array, options.opts_autocorr_matrix_on_stack);
    case 5
        [stack_projection, stack_proj_info] = compute_pixelwise_autocorr_projection (images_stack, images_stack_info, 'max', tag_array, options.opts_autocorr_matrix_on_stack);
    case 6
        % Cancel
        error('\n Operation interrupted by user.\n');
    otherwise
        error ('Something went wrong with the user selecting the stack projection to compute the ROI.');
end

% Normalize by max.
stack_proj_norm = (stack_projection./stack_proj_info.max);

% Update the info file.
images_stack_info.stack_projection_type = stack_proj_info.type;
images_stack_info.stack_projection = stack_projection;
images_stack_info.stack_proj_info = stack_proj_info;

fprintf ('\nStack projection computed.\n\n')

end