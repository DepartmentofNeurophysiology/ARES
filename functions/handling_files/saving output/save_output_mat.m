function save_output_mat (ARES_film, ARES_film_info, options)
% This function saves the output film as a .mat file.
% If options.FLAG_normalize_mat_output is set to 1, the output film will 
% be normalized by the frame average time projection.

number_of_frames = ARES_film_info.number_of_frames;

if nargin < 3
   options.FLAG_normalize_mat_output = 1;
   options.FLAG_user_ask_file_name = 0;
end
fprintf ('\nWriting output as .mat file...\n...\n');


%% Normalize film per time projection?
if options.FLAG_normalize_mat_output == 1
    try
        for i_frame = 1:number_of_frames
            current_frame = ARES_film(:,:,i_frame);
            ARES_film(:,:,i_frame) = current_frame - (ARES_film_info.ARES_time_axis_projection_min_noninf(1, i_frame));
        end
    catch
        ARES_film_info.FLAG_normalize_frame_avg_MatFile = 'No';
        warning('Problem while trying to save the stack as .mat file. Could not normalize the stack. Probable out of memory error: more RAM required.');
    end
end
ARES_film_info.FLAG_normalize_mat_output = options.FLAG_normalize_mat_output;


%% Getting file name.
% Getting file extention
extention_mat = '.mat';
% Making file names.
if options.FLAG_user_ask_file_name == 1
    ARES_film_file_name_tmp = options.output_FileName;
else
    ARES_film_file_name_tmp = sprintf('ARES_%s_Film', ARES_film_info.regression_mode);
    ARES_film_file_name_tmp = sprintf('%s_%s', ARES_film_info.original_stack_FileName, ARES_film_file_name_tmp);
end
ARES_film_file_name_info_tmp = sprintf('%s_info', ARES_film_file_name_tmp);
ARES_film_file_name = strcat(ARES_film_file_name_tmp, extention_mat);
ARES_film_file_name_info = strcat(ARES_film_file_name_info_tmp, extention_mat);

% Getting current folder
current_folder = pwd; file_sep = filesep;


%% Checking if file_name already exists, if so add a "_new" at the end.
file_loc = sprintf('%s%s', current_folder, file_sep, ARES_film_file_name);
if exist(file_loc, 'file')
    string_tmp = 'File already exists. Do you want to overwrite or save with a different name?';
    window_title = 'File already exists';
    FLAG_FileOverwrite = questdlg(string_tmp, window_title, 'Overwrite', 'Save but keep both files', 'Cancel', 'Overwrite');
    switch FLAG_FileOverwrite
        case 'Overwrite'            
            % Use same name as previous & delete previous file
            if exist(ARES_film_file_name, 'file') ~= 0
                delete ARES_film_file_name
                delete ARES_film_file_name_info
            end
        case 'Save but keep both files'
            ARES_film_file_name = sprintf('%s_new%s', ARES_film_file_name_tmp, extention_mat);
            ARES_film_file_name_info = sprintf('%s_new%s', ARES_film_file_name_info_tmp, extention_mat);
        case 'Cancel'
            fprintf('\nOperation aborted by user.\n\n');
            return
        otherwise
            error ('Something went wrong with user selecting what to do.')
    end
end


%% Saving files.
save(ARES_film_file_name_info, 'ARES_film_info');
save(ARES_film_file_name, 'ARES_film', '-v7.3');
fprintf('File saved successfully.\n\n')


end