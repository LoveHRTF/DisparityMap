%% ========================================================================
% File Name: func_ImageDataPrePorcess.m
% Author   : Ziwei Chen
% Date     : Oct-05-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.0
% Descrip  : This function was to extract the parameters from imput image
%            matrix and window size
%% ========================================================================
function [ImgMat] = func_ImageDataPrePorcess(RawImageMatrix,WindowEdgeLength)

ImgMat.rawImgDat = double(RawImageMatrix);
%% Get Image Size
ImageSize = size(RawImageMatrix);
ImgMat.imgSize.V = ImageSize(1);
ImgMat.imgSize.H = ImageSize(2);
%% Get box Parameters
ImgMat.boxLength = WindowEdgeLength;
ImgMat.boxLengthOffset = (WindowEdgeLength - 1)/2;
%% Get search Parameters
ImgMat.searchStartPix = ImgMat.boxLengthOffset + 1;
ImgMat.searchEndPix.V = ImgMat.imgSize.V - ImgMat.boxLengthOffset;
ImgMat.searchEndPix.H = ImgMat.imgSize.H - ImgMat.boxLengthOffset;
end

