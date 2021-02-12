function [ output_args ] = measure_adjacent_pixel_corr ( images_stack, images_stack_info, selected_ROI )
% This function is to measure the correlation between adjacent pixels.

% READ ME
% To sample from selected areas, divide the image into regions like already
% implemented, and ask to select them. 

%% Settings
number_of_neighbours = 8;
% Number of pixels to sample from random places in the image.
number_of_sample_pixels = 1000;
window_type = 'rectangular';
window_g_std = 6;
window_advance_step = 1;
window_length = 10;

number_of_frames = images_stack_info.number_of_frames;
image_Height = images_stack_info.Height;
image_Width = images_stack_info.Width;


%% ~~~ Counting Number of pixels in ROI ~~~ %%
number_of_pixels_in_ROI = 0;
for i_pixel = 1:image_Height
    for j_pixel = 1:image_Width
        if (selected_ROI(i_pixel, j_pixel) == 1)
            number_of_pixels_in_ROI = number_of_pixels_in_ROI + 1;
        end
    end
end


%% ~~~ Setting the window ~~~ %%
window_used = set_window (window_type, window_length, window_g_std);


%%
current_central_pixel_corr = zeros(1, number_of_neighbours);
counter_frame = 1;
previous_random_pixel = [0, 0];
tic
for i_image = 1:window_advance_step:(number_of_frames - window_length)
    index_central_pixel = 1;
    while  index_central_pixel <= number_of_sample_pixels
        % Get random pixel.
        random_pixel = [randi([1 image_Height]), randi([1 image_Width])];
        if isequal(random_pixel, previous_random_pixel)
            continue
        end
        i_pixel = random_pixel(1,1);
        j_pixel = random_pixel(1,2);
        % Check it and his neighborhood to be in the ROI.
        if (selected_ROI(i_pixel, j_pixel) == 1) && (i_pixel < image_Height) && (j_pixel < image_Width) % Use only ROI pixels.
            FLAG_neighborhood_ok = check_central_pixel_border_ROI (i_pixel, j_pixel, selected_ROI);
            if FLAG_neighborhood_ok ~= 1
                continue
            end
            current_central_time_series(:) = double(images_stack(i_pixel, j_pixel, i_image:(i_image + window_length - 1)));
            % Compute correlation with neighboring pixels
            counter_neighborhood = 1;
            for index_pixel_1 = -1:1:1
                for index_pixel_2 = -1:1:1
                    if (index_pixel_1 == 1) && (index_pixel_2 == 1) % Exclude Autocorrelation
                        continue
                    else
                        current_time_series(:) = double(images_stack(i_pixel + index_pixel_1, j_pixel + index_pixel_2, i_image:(i_image + window_length - 1)));
                        current_central_pixel_corr(1, counter_neighborhood) = corr2(current_central_time_series, current_time_series);
                        counter_neighborhood = counter_neighborhood + 1;
                    end
                    
                    
                end
            end
            current_central_pixel_corr_avg(1, index_central_pixel) = nanmean(nonzeros(current_central_pixel_corr));
            index_central_pixel = index_central_pixel + 1; 
        end
    end
    
end



end


%% Auxiliary Functions
    function FLAG_neighborhood_ok = check_central_pixel_border_ROI (i_pixel, j_pixel, selected_ROI)
        FLAG_neighborhood_ok = 0;
        if selected_ROI(i_pixel + 1, j_pixel) == 1 && selected_ROI(i_pixel + 1, j_pixel - 1) == 1 && selected_ROI(i_pixel + 1, j_pixel + 1) == 1
            if selected_ROI(i_pixel - 1, j_pixel) == 1 && selected_ROI(i_pixel - 1, j_pixel - 1) == 1 && selected_ROI(i_pixel - 1, j_pixel + 1) == 1
                if selected_ROI(i_pixel, j_pixel - 1) == 1 && selected_ROI(i_pixel, j_pixel + 1)
                    FLAG_neighborhood_ok = 1;
                end
            end
        end
        
    end

end

