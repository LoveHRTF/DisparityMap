% File Name: func_DIntegralImages2Disparity.m
% Author   : Ziwei Chen
% Date     : Oct-08-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.0
% Descrip  : This function was to calculate disparity map base on the
%            integral image stack
%%
function [DisparityMap] = func_DIntegralImages2Disparity(BaseImage,ImgStack,D)

sizeMat = size(BaseImage.rawImgDat);                                       % Get Image Size Info
ColsMat = BaseImage.imgSize.V;
RowsMat = BaseImage.imgSize.H;

SSDVector = zeros(1,D);                                                    % Memory Allocation for Sum of Square Difference Vector
StackNumber = zeros(sizeMat);                                              % Memory Allocation for StackNumber Map
DispValStack = {D};                                                        % Memory Allocation for Disparity Value Stack
for StackIndex = 1:D                                                       % Memory Allocation for Disparity Value Map Stack 
    DispValStack{StackIndex} = zeros(sizeMat);
end
WaitBarX = waitbar(0,'Calculating Sum of Square Difference SSD...');
%% Calculate Sum of Squared Difference (SSD)
for StackIndex = 1:D
    for indexCol = BaseImage.boxLengthOffset + 2 : ColsMat - BaseImage.boxLengthOffset - 1
        for indexRow = D + BaseImage.boxLengthOffset + 2 : RowsMat - BaseImage.boxLengthOffset - 1     % Use Integral Image for SSD Calculation
            DispValLL = ImgStack{StackIndex}(indexCol + BaseImage.boxLengthOffset + 1, indexRow +  BaseImage.boxLengthOffset + 1);
            DispValLU = ImgStack{StackIndex}(indexCol - BaseImage.boxLengthOffset    , indexRow + BaseImage.boxLengthOffset + 1);
            DispValRL = ImgStack{StackIndex}(indexCol + BaseImage.boxLengthOffset + 1, indexRow - BaseImage.boxLengthOffset);
            DispValRU = ImgStack{StackIndex}(indexCol - BaseImage.boxLengthOffset    , indexRow - BaseImage.boxLengthOffset);
            DispValStack{StackIndex}(indexCol,indexRow) =  DispValLL - DispValLU - DispValRL + DispValRU;
        end
    end
    waitbar(StackIndex/D*0.5,WaitBarX,'Calculating Sum of Square Difference SSD...');
end
%% Find The Disparity
for indexCol = 1:ColsMat
    for indexRow = 1:RowsMat
        for StackIndex = 1:D                                               % Store Value for Each Same Position Element on Each Stack as Vector
            SSDVector(StackIndex) = DispValStack{StackIndex}(indexCol,indexRow);
        end
        
        localMin = min(SSDVector);                                         % Find Local Minimal for Each SSDVector
        for VectorIndex = 1:D                                              % Find Which Stack does Local Minimal Exists
            if SSDVector(VectorIndex) == localMin
                StackNumber(indexCol,indexRow) = VectorIndex;
            end
        end
    end
    waitbar(0.5 + indexCol/ColsMat*0.5,WaitBarX,'Calculating Disparity Map...');
end
close(WaitBarX);
%% Output Disparity Map
DisparityMap = StackNumber;


end

