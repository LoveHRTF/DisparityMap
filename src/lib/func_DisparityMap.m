% File Name: func_DisparityMap.m
% Author   : Ziwei Chen
% Date     : Oct-05-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.1
% Descrip  : This function was to calculate the disparity map for two
%            perfectally horizontial images
%%
function [imageDisparityLeft] = func_DisparityMap(imageL,imageR,windowLength,D,Method)
%% Function Settings
method = Method;                                                                % 0 for O(NDS^2), 1 for O(ND), 2 for O(ND) with Dynamic Window Size
%% Parpear data and format data matrix
ImgMaxL = func_ImageDataPrePorcess((imread(imageL)),windowLength);
ImgMaxR = func_ImageDataPrePorcess((imread(imageR)),windowLength);

%% Switch Different Mode
if method == 0
    %% Regular Approach
    WindowedMatrixL = func_constructWindowMatrix(ImgMaxL);                    % Calculate windowed pixel value map
    WindowedMatrixR = func_constructWindowMatrix(ImgMaxR);
    DisparityMap = func_HorizontialSSDScan(WindowedMatrixL,WindowedMatrixR,D);% Find SSD Vector for Left Image
    
elseif method ==1
    %% Integral Image Approach
    ImageStack = func_DIntegralImages(ImgMaxL.rawImgDat,ImgMaxR.rawImgDat,D);
    DisparityMap = func_DIntegralImages2Disparity(ImgMaxL,ImageStack,D);
    
elseif method == 2
    %% Integral Image With Adaptive Window and Noise Reduction Method
    ImageStack = func_DIntegralImages(ImgMaxL.rawImgDat,ImgMaxR.rawImgDat,D);
    DisparityMap = func_DIntegralImages2Disparity_Adp(ImgMaxL,ImageStack,D);
end
imageDisparityLeft = DisparityMap;
end

