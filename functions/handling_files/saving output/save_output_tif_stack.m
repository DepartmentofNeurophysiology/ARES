function save_output_tif_stack (ARES_film, ARES_film_info, options)
% This function saves the output file as a single .tif stack.

if nargin < 3 || isempty(options)
   options.FLAG_normalize_tif_output = 1;
   options.FLAG_user_ask_file_name = 0;
end
ARES_film_info.FLAG_normalize_tif_output = options.FLAG_normalize_tif_output;
fprintf ('\nWriting output .tif stack...\n...\n');


%% Getting file name.
% Getting file extention
extention_tif = '.tif';
extention_mat = '.mat';
% Making file names.
if options.FLAG_user_ask_file_name == 1
    ARES_film_file_name_tmp = options.output_FileName;
else
    ARES_film_file_name_tmp = sprintf('ARES_%s_Film', ARES_film_info.regression_mode);
    ARES_film_file_name_tmp = sprintf('%s_%s', ARES_film_info.original_stack_FileName, ARES_film_file_name_tmp);
end
ARES_film_file_name_info_tmp = sprintf('%s_info', ARES_film_file_name_tmp);
ARES_film_file_name_tif = strcat(ARES_film_file_name_tmp, extention_tif);
ARES_film_file_name_info = strcat(ARES_film_file_name_info_tmp, extention_mat);

% Getting current folder
current_folder = pwd; file_sep = filesep;


%% Checking if file_name already exists, if so add a "_new" at the end.
file_loc = sprintf('%s%s', current_folder, file_sep, ARES_film_file_name_tif);

if exist(file_loc, 'file')
    string_tmp = 'File already exists. Do you want to overwrite or save with a different name?';
    window_title = 'File already exists';
    FLAG_FileOverwrite = questdlg(string_tmp, window_title, 'Overwrite', 'Save but keep both files', 'Cancel', 'Overwrite');
    switch FLAG_FileOverwrite
        case 'Overwrite'
            % Use same name as previous.
            
            % Delete previous file.
            delete ARES_film_file_name_tif
            delete ARES_film_file_name_info
        case 'Save but keep both files'
            ARES_film_file_name_tif = sprintf('%s_new%s', ARES_film_file_name_tmp, extention_tif);
            ARES_film_file_name_info = sprintf('%s_new%s', ARES_film_file_name_info_tmp, extention_mat);
        case 'Cancel'
            fprintf('\nOperation aborted by user.\n\n');
            return
        otherwise
            error ('Something went wrong with user selecting what to do.')
    end
end


%% Saving info file.
save(ARES_film_file_name_info, 'ARES_film_info');


%% Saving .tif stack
error_counter = 0;
while error_counter < 10
    try
        % Writing file
        for i_frame = 1:ARES_film_info.number_of_frames
            % Converting frames into uint16 format (required for .tif)
            current_frame = ARES_film(:,:,i_frame);
            current_min = ARES_film_info.ARES_time_axis_projection_min_noninf(1,i_frame);
            if options.FLAG_normalize_tif_output == 1
                current_max = ARES_film_info.ARES_time_axis_projection_max_noninf(1,i_frame);
                current_frame = (current_frame - current_min)./(current_max - current_min); % Subtracting the minimum will shift negative numbers to positive, ok for uint conversion.
            else
                current_frame = (current_frame - current_min); % Subtracting the minimum will shift negative numbers to positive, ok for uint conversion.
            end
            current_frame = uint16(current_frame.*65535); % Adjust to uint16 scale
            imwrite(current_frame(:,:), ARES_film_file_name_tif, 'tif', 'Compression', 'none', 'writemode', 'append');
            clear current_frame;
        end
        break
    catch
        warning('MATLAB failed at writing the tif stack output. Trying again automatically.')
        file_loc = sprintf('%s%s', current_folder, file_sep, ARES_film_file_name_tif);
        if exist(file_loc, 'file')
            delete (file_loc);
        end
        error_counter = error_counter + 1;
        pause(1);
    end
    
end

if error_counter >= 10
   error('MATLAB could not save the output as .tif stack. This is a known problem associated with MATLAB. Please try again, save as .avi, or contact support.') 
end
fprintf('\nTif stack saved successfully.\n\n')

end