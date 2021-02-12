function output_ROI = remove_isolated_pixels (input_ROI, N, M)
% This function will remove every isolated pixel (pixel=1) from an ROI if, 
% in a (M by M) square around that pixel, there are less than N pixels = 1.

switch nargin
    case 1
        N = 3;
        M = 2;
    case 2
        M = 2;
    case 3
    otherwise
        error('Error: wrong number of inputs.\n');
end
[Height, Width] = size(input_ROI);
tmp_image = double(input_ROI);
output_ROI = input_ROI;


%% Pixel check loop
for i_pixel = (M+1):(Height - M)
    for j_pixel = (M+1):(Width - M)
        current_pixel = [i_pixel, j_pixel];
        if (input_ROI(i_pixel, j_pixel) == 1)
            FLAG_remove = check_non_isolated_pixel(current_pixel, input_ROI, N, M);
            if (FLAG_remove == 1)
                tmp_image(i_pixel, j_pixel) = 0.5;
            end
        end
    end
end
tmp_image = check_non_isolated_pixel_border (input_ROI, tmp_image, N, M, Height, Width);


%% Pixel removal loop
for i_pixel = 1:Height
    for j_pixel = 1:Width
        if (tmp_image(i_pixel, j_pixel) == 0.5)
            output_ROI(i_pixel, j_pixel) = 0;
        end
    end
end



%% Sub-function to check if a single pixel is to be removed.
    function FLAG_remove = check_non_isolated_pixel (current_pixel, input_image, N, M)
        neighbours_counter = 0;
        for i_neighbour = -M:1:M
            for j_neighbour = -M:1:M
                if (input_image( (current_pixel(1,1)+i_neighbour), (current_pixel(1,2)+j_neighbour) ) ~= 0)
                    neighbours_counter = neighbours_counter + 1;
                end
            end
        end
        if (neighbours_counter > N)
            FLAG_remove = 0;
        else
            FLAG_remove = 1;
        end
        return
    end

%% Sub-function to check the borders of the image
    function tmp_image = check_non_isolated_pixel_border (input_image, tmp_image, N, M, Height, Width)
        % Left border
        for i_p1 = (M+1):(Height - M)
            if (input_image(i_p1, 1) == 1)
                neighbours_counter_border = 0;
                current_p = [i_p1, 1];
                for i_neighbour_border = -M:1:M
                    for j_neighbour_border = 0:1:M
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 0)
                            neighbours_counter_border = neighbours_counter_border + 1;
                        end
                    end
                end
                if (neighbours_counter_border < ((N/2) + 1))
                    tmp_image(i_p1, 1) = 0.5;
                end
            end
        end
        
        % Right border
        for i_p1 = (M+1):(Height - M)
            if (input_image(i_p1, Width) == 1)
                neighbours_counter_border = 0;
                current_p = [i_p1, Width];
                for i_neighbour_border = -M:1:M
                    for j_neighbour_border = -M:1:0
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 0)
                            neighbours_counter_border = neighbours_counter_border + 1;
                        end
                    end
                end
                if (neighbours_counter_border < ((N/2) + 1))
                    tmp_image(i_p1, Width) = 0.5;
                end
            end
        end
        
        % Upper border
        for j_p1 = (M+1):(Width - M)
            if (input_image(1, j_p1) == 1)
                neighbours_counter_border = 0;
                current_p = [1, j_p1];
                for i_neighbour_border = 0:1:M
                    for j_neighbour_border = -M:1:M
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 0)
                            neighbours_counter_border = neighbours_counter_border + 1;
                        end
                    end
                end
                if (neighbours_counter_border < ((N/2) + 1))
                    tmp_image(1, j_p1) = 0.5;
                end
            end
        end
        
        % Lower border
        for j_p1 = (M+1):(Width - M)
            if (input_image(Height, j_p1) == 1)
                neighbours_counter_border = 0;
                current_p = [Height, j_p1];
                for i_neighbour_border = -M:1:0
                    for j_neighbour_border = -M:1:M
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 0)
                            neighbours_counter_border = neighbours_counter_border + 1;
                        end
                    end
                end
                if (neighbours_counter_border < ((N/2) + 1))
                    tmp_image(Height, j_p1) = 0.5;
                end
            end
        end
    end

end