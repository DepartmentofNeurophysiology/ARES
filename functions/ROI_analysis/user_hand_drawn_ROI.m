function ROI = user_hand_drawn_ROI (stack_proj_norm)
% This function lets the user freehand draw an ROI.
% INPUT: 
% - stack_proj_norm: the images stack projection.

% Initialize.
[img_Width, img_Height] = size(stack_proj_norm);
stack_proj_norm_mod = stack_proj_norm;
ROI = zeros (img_Width, img_Height);
keep_looping = 1;
ROI_tmp_cell = cell(1);

% Prepare choice button.
string_tmp = 'Continue selecting more areas or finish?';
window_title = 'ROI selection.';
dlgOptions{1,1} = 'Continue';
dlgOptions{1,2} = 'Finish';
dlgOptions{1,3} = 'Undo last';
dlgOptions{1,4} = 'Restart';

% Show image stack projection.
fig_stack_proj = figure('Name','ROI Selection','NumberTitle','off');
ROI_fig_title = 'User manual ROI selection.';

ROI_user_instruction = {'To draw an ROI, left click with the mouse and drag. Release once finished.'; 'Continue to add more ROI selections, and press finish once done.'};
counter_ROI_selection = 1;

while keep_looping == 1
    % User selected area.
    imshow(stack_proj_norm_mod);
    set(gcf,'position',get(0,'screensize'));
    title(ROI_fig_title); xlabel(ROI_user_instruction);
    ROI_FreeHand_selection = imfreehand('Closed', 'true');
    pause(0.5);
    
    % Ask user if to continue.
    ROI_SelectionMethod = bttnChoiseDialog(dlgOptions, window_title, 'Finish', string_tmp);
    switch ROI_SelectionMethod
        case 1 % Continue.
            % Save selection.
            ROI_tmp = createMask(ROI_FreeHand_selection);
            ROI_tmp_cell{1, counter_ROI_selection} = ROI_tmp;
            % Move onto next selection.
            counter_ROI_selection = counter_ROI_selection + 1;
            % Update image shown.
            for i_x = 1:img_Width
                for i_y = 1:img_Height
                    if ROI_tmp(i_x, i_y)
                        stack_proj_norm_mod(i_x, i_y) = 1;
                    end
                end
            end
        case 2 % Finish.
            % Save selection
            ROI_tmp = createMask(ROI_FreeHand_selection);
            ROI_tmp_cell{1, counter_ROI_selection} = ROI_tmp;
            % Make ROI
            for i_selection = 1:counter_ROI_selection
                ROI = ROI + ROI_tmp_cell{1, i_selection};
            end
            ROI = logical(ROI);
            % Close and finish.
            if ishandle(fig_stack_proj)
                close(fig_stack_proj)
            end
            fprintf('\nUser hand drawn ROI done.\n')
            return
        case 3 % Undo last selection.
            % Do not increase i_ROI_selection counter, do not update
            % background image, reshow previous image.
            clear ROI_FreeHand_selection;
        case 4 % Restart.
            % Clear saved variables.
            clear ROI_tmp_cell;
            clear ROI_FreeHand_selection;
            if ishandle(fig_stack_proj)
                close(fig_stack_proj)
            end
            % Restart figure.
            stack_proj_norm_mod = stack_proj_norm;
            fig_stack_proj = figure('Name','ROI Selection','NumberTitle','off');
            set(gcf,'position',get(0,'screensize'));
            title(ROI_fig_title); xlabel(ROI_user_instruction);
            counter_ROI_selection = 1;
        otherwise
            close(fig_stack_proj)
            error('Operation aborted by user.')
    end
end

end
