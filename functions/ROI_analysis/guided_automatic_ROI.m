function smooth_ROI = guided_automatic_ROI (stack_proj_norm, stack_proj_info, images_stack_info, options)
% User adjustable threshold, and visualize updated ROI until user press
% button to say he is satisfied.

ROI_StdThreshold = options.ROI_StdThreshold;
string_tmp = 'If you are satisfied with the ROI, press Ok, otherwise adjust the ROI threshold coefficient.';
window_title = 'ROI Ok';
FLAG_user_ok_ROI = 0;
selected_ROI_fig = figure();

while FLAG_user_ok_ROI == 0
    if ishandle(selected_ROI_fig)
        close(selected_ROI_fig);
    end
    % User set threshold coefficient.
    diag_win_prompt = {'Enter threshold coefficient for ROI:'};
    diag_win_name = 'Threshold Coefficient';
    diag_win_default_ans = {'0.5'};
    ROI_StdThreshold_tmp = inputdlg(diag_win_prompt,diag_win_name,[1 40],diag_win_default_ans);
    ROI_StdThreshold = str2double(ROI_StdThreshold_tmp{1,1}); clear ROI_StdThreshold_tmp;
    
    % Create raw ROI.
    ROI_threshold = (stack_proj_info.avg/stack_proj_info.max) + (ROI_StdThreshold*(stack_proj_info.std/stack_proj_info.max));
    if ROI_threshold > 1 || ROI_threshold < 0
        warning ('ROI threshold must have a value between -1 and 1!');
        continue
    end
    selected_ROI = im2bw(stack_proj_norm, ROI_threshold);
    
    % Counting Number of pixels in ROI
    number_of_pixels_in_ROI = 0;
    number_of_pixels_per_frame = images_stack_info.Height*images_stack_info.Width;
    for i_pixel = 1:images_stack_info.Height
        for j_pixel = 1:images_stack_info.Width
            if (selected_ROI(i_pixel, j_pixel) == 1)
                number_of_pixels_in_ROI = number_of_pixels_in_ROI + 1;
            end
        end
    end
    
    % Smoothen ROI - select pixel region pipeline.
    [smooth_ROI] = smoothen_ROI (selected_ROI);
    % Counting Number of pixels in ROI
    number_of_pixels_in_ROI = 0;
    number_of_pixels_per_frame = images_stack_info.Height*images_stack_info.Width;
    for i_pixel = 1:images_stack_info.Height
        for j_pixel = 1:images_stack_info.Width
            if (smooth_ROI(i_pixel, j_pixel) == 1)
                number_of_pixels_in_ROI = number_of_pixels_in_ROI + 1;
            end
        end
    end
    ROI_percentage = (number_of_pixels_in_ROI/number_of_pixels_per_frame)*100;
    fprintf('\n %3.1f%% of pixels included in smooth ROI, for a total of %d pixels.\n\n', ROI_percentage, number_of_pixels_in_ROI);
    
    title_tmp = sprintf('\n %3.1f%% of pixels included in smooth ROI, for a total of %d pixels.\n\n', ROI_percentage, number_of_pixels_in_ROI);
    
    C = imfuse(smooth_ROI*0.75, stack_proj_norm, 'falsecolor','Scaling','joint','ColorChannels',[1 2 2]);
    selected_ROI_fig = figure(); imshow(C);
    xlabel('Red areas are included in the ROI.', 'FontSize',14);
    set(gcf, 'position', get(0, 'screensize'));
    text(0, 0, title_tmp, 'FontSize',14)
    
    % Ask user if satisfied with ROI, or adjust threshold coefficient again.
    OkOrAdjust = questdlg(string_tmp, window_title, 'Ok', 'Adjust threshold', 'Ok');
    if strcmp(OkOrAdjust, 'Ok') == 1
        FLAG_user_ok_ROI = 1;
    end
end
close(selected_ROI_fig);
