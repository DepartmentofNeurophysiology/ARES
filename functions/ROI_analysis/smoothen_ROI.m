function [smooth_ROI] = smoothen_ROI (selected_ROI)
% This function is just a series of 
% fill_isolated_pixels -> remove_isolated_pixels function calls, to
% smoothen the ROI.


% figure();imshow(autocorrelation_ROI);

% Fill big holes
ROI_fill_1 = fill_isolated_pixels (selected_ROI, 5 ,1);
% figure();imshow(ROI_fill_1);

% Fill small holes
ROI_fill_2 = fill_isolated_pixels (ROI_fill_1);
% figure();imshow(ROI_fill_2);

% Remove big granes
ROI_erod_1 =  remove_isolated_pixels (ROI_fill_2, 5 ,1);
% figure();imshow(ROI_erod_1);

% Remove small granes
ROI_erod_2 =  remove_isolated_pixels (ROI_erod_1);
% figure();imshow(ROI_erod_2);

% Remove small holes
ROI_fill_3 = fill_isolated_pixels (ROI_erod_2, 4, 1);
% figure();imshow(ROI_fill_3);

% Remove small granes
ROI_erod_3 =  remove_isolated_pixels (ROI_fill_3);
% figure();imshow(ROI_erod_2);

% Remove small holes
ROI_fill_4 = fill_isolated_pixels (ROI_erod_3, 4, 1);
% figure();imshow(ROI_fill_3);

smooth_ROI = ROI_fill_4;
return
end




