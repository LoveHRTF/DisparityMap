% File Name: func_DIntegralImages.m
% Author   : Ziwei Chen
% Date     : Oct-08-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.0
% Descrip  : This function was to create image stack of layer D, shift the
%            stack and compute IntegralImage for Square Difference Stack
%%
function [OutputStack] = func_DIntegralImages(BaseImg,RefeImg,D)

sizeImg = size(BaseImg);                                                   % Get Image Size Info
sizeV = sizeImg(1);
sizeH = sizeImg(2);

Image = zeros(sizeImg);                                                    % Memory Allcation for Initial Image
ImageStack = {D};                                                          % Memory Allcation for Initial Image Stack
DifferenceStack = {D};                                                     % Memory Allcation for Difference Stack
SqrDiffStack = {D};                                                        % Memory Allcation for Square Difference Stack
IngImgStack = {D};                                                         % Memory Allcation for Square Difference Integral Image Stack

WaitBarX = waitbar(0,'Creating Shifted Image Stack...');
%% Create Image Stack
for StackIndex = 1:D                                                       % For Every Displacement
    for indexV = 1 : sizeV                                                 % For Every Colum in Each Displacemtnt
        for indexH = 1 + D: sizeH                                          % For Every Row Pixel
            Image(indexV,indexH) = RefeImg(indexV, indexH - StackIndex);   % Calculate Square Difference
        end
    end
    ImageStack{StackIndex} = Image;
    
    %% Calculate Difference for ImageStack and BaseImage (D)
    DifferenceStack{StackIndex} = BaseImg - ImageStack{StackIndex};
    
    %% Calculate Square for Difference Stack (SD)
    SqrDiffStack{StackIndex} = DifferenceStack{StackIndex} .^ 2;
    
    %% Convert SD to IntegralImage
    IngImgStack{StackIndex} = func_Img2IntegralImage(SqrDiffStack{StackIndex});
    
    waitbar(StackIndex/D,WaitBarX,'Creating Inegral Shifted Image Stack...');
end
OutputStack = IngImgStack;
close(WaitBarX);
end