function output_ROI = fill_isolated_pixels (input_ROI, N, M)
% This function will remove every hole (pixel = 0) from an input ROI if, 
% in a (M by M) square around that pixel, there are less than N pixels = 0.

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
        if (input_ROI(i_pixel, j_pixel) == 0) % Consider only pixels = 0.
            FLAG_fill = check_non_isolated_hole(current_pixel, input_ROI, N, M); % Check if they need to be filled.
            if (FLAG_fill == 1)
                tmp_image(i_pixel, j_pixel) = 0.5;
            end
        end
    end
end
tmp_image = check_non_isolated_holes_border (input_ROI, tmp_image, N, M, Height, Width);


%% Pixel removal loop
for i_pixel = 1:Height
    for j_pixel = 1:Width
        if (tmp_image(i_pixel, j_pixel) == 0.5)
            output_ROI(i_pixel, j_pixel) = 1;
        end
    end
end


%% Sub-function to check if a single pixel = 0 is to be set = 1.
    function FLAG_fill = check_non_isolated_hole (current_pixel, input_image, N, M)
        neighbours_counter = 0;
        for i_neighbour = -M:1:M
            for j_neighbour = -M:1:M
                if (input_image( (current_pixel(1,1)+i_neighbour), (current_pixel(1,2)+j_neighbour) ) ~= 1)
                    neighbours_counter = neighbours_counter + 1;
                end
            end
        end
        if (neighbours_counter > N)
            FLAG_fill = 0;
        else
            FLAG_fill = 1;
        end
        return
    end


%% Sub-function to check the borders of the image
    function tmp_image = check_non_isolated_holes_border (input_image, tmp_image, N, M, Height, Width)
        % Left border
        for i_p1 = (M+1):(Height - M)
            if (input_image(i_p1, 1) == 0)
                neighbours_counter_border = 0;
                current_p = [i_p1, 1];
                for i_neighbour_border = -M:1:M
                    for j_neighbour_border = 0:1:M
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 1)
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
            if (input_image(i_p1, Width) == 0)
                neighbours_counter_border = 0;
                current_p = [i_p1, Width];
                for i_neighbour_border = -M:1:M
                    for j_neighbour_border = -M:1:0
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 1)
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
            if (input_image(1, j_p1) == 0)
                neighbours_counter_border = 0;
                current_p = [1, j_p1];
                for i_neighbour_border = 0:1:M
                    for j_neighbour_border = -M:1:M
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 1)
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
            if (input_image(Height, j_p1) == 0)
                neighbours_counter_border = 0;
                current_p = [Height, j_p1];
                for i_neighbour_border = -M:1:0
                    for j_neighbour_border = -M:1:M
                        if (input_image( (current_p(1,1)+i_neighbour_border), (current_p(1,2)+j_neighbour_border) ) ~= 1)
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