% File Name: func_Img2IntegralImage.m
% Author   : Ziwei Chen
% Date     : Oct-08-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.0
% Descrip  : This function was to create integral image
%%
function IntegralImage = func_Img2IntegralImage(ImageMatrix)

ImageSize = size(ImageMatrix);
ImageCol = ImageSize(1);
ImageRow = ImageSize(2);

sumVal = zeros(ImageCol + 1, ImageRow + 1);                                % Create Template for Result Image

for indexCol = 1:ImageCol
    for indexRow = 1:ImageRow
        sumVal(indexCol + 1, indexRow + 1) = sumVal(indexCol + 1, indexRow) + ...
            sumVal(indexCol, indexRow + 1) - sumVal(indexCol, indexRow) +...
            ImageMatrix(indexCol, indexRow);
    end
end
IntegralImage = sumVal;
end
