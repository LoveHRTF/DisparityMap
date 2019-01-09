% File Name: func_DIntegralImages2Disparity_Adp.m
% Author   : Ziwei Chen
% Date     : Oct-08-2018
% Modified : Ziwei Chen
% Date     : Oct-14-2018
% Version  : Ver.1.2
% Descrip  : This function was to calculate disparity map base on the
%            integral image stack and adaptive window size
%%
function [DisparityMap] = func_DIntegralImages2Disparity_Adp(BaseImage,ImgStack,D)
%% Parameters

% Larger Range Would Increase Chance to Detect Area with Similar Pattern
% But Decreate the Edge Accuracy

% Sum of Square Difference Vector min/max Ratio Threshold (Defaule: 0.4/0.1)
ratioThresholdHigh = 0.4;
ratioThresholdLow = 0.1;
% Sum of Square Difference Vector Standard Deviation Ratio Threshold (Defaule: 0.4/0.225)
stdThresholdHigh = 0.4;
stdThresholdLow = 0.225;
% High Thresholds
ratioHighThreshold = 0.25;
stdHighThreshold = 0.4;

%% Get Image Size Info
sizeMat = size(BaseImage.rawImgDat);                                       
ColsMat = BaseImage.imgSize.V;
RowsMat = BaseImage.imgSize.H;

boxLength = 0;

%% Memory Allocations
ratioMap = zeros(sizeMat);                                                 
stdMap = zeros(sizeMat);
stdValPrevious = zeros(sizeMat);
StackNumberNoiseReduced = zeros(sizeMat);
boxLengthMat = zeros(sizeMat);
SSDVector = zeros(1,D);
StackNumber = zeros(sizeMat);
DispValStack = {D};
for StackIndex = 1:D
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
    waitbar(StackIndex/D * 0.2,WaitBarX,'Calculating Sum of Square Difference SSD...');
end

%% Find The Disparity
for indexCol = 1:ColsMat
    for indexRow = 1:RowsMat
        for StackIndex = 1:D                                               % Store Value for Each Same Position Element on Each Stack as Vector
            SSDVector(StackIndex) = DispValStack{StackIndex}(indexCol,indexRow);
        end
        %% Adaptive Window Size
        stdMap(indexCol,indexRow) = func_NormalizedVectorSTD(SSDVector);   % Find Normalized Window Std Value and window min/max ratio
        ratioMap(indexCol,indexRow) = min(SSDVector)/max(SSDVector);
        %% Increase Window Size When Variation was small
        entry = 1;
        while  ((ratioThresholdHigh > ratioMap(indexCol,indexRow) && ratioMap(indexCol,indexRow) > ratioThresholdLow) &&...
                ( stdThresholdHigh > stdMap(indexCol,indexRow) && stdMap(indexCol,indexRow) > stdThresholdLow)) ||...
                ((ratioMap(indexCol,indexRow) > ratioHighThreshold) && (stdMap(indexCol,indexRow) > stdHighThreshold))
            
            EnlargeRatio = ratioMap(indexCol,indexRow) * 100;              % Calculate Initial Window Zoom Ratio
            if entry == 1                                                  % Setup Initial New Window Length by Initial Window Zoom Ratio
                boxLength = BaseImage.boxLengthOffset;                     % Initial Value for Box Length
                if (indexCol > BaseImage.boxLengthOffset * EnlargeRatio + 1 && indexRow > BaseImage.boxLengthOffset * EnlargeRatio + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset * EnlargeRatio + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset * EnlargeRatio + 1 < RowsMat)
                    boxLength = round(BaseImage.boxLengthOffset * EnlargeRatio);
                    entry = 0;
                    
                elseif (indexCol > BaseImage.boxLengthOffset * EnlargeRatio * 0.75 + 1 && indexRow > BaseImage.boxLengthOffset * EnlargeRatio * 0.75 + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset * EnlargeRatio * 0.75 + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset * EnlargeRatio * 0.75 + 1 < RowsMat)
                    boxLength = round(BaseImage.boxLengthOffset * EnlargeRatio* 0.75);
                    entry = 0;
                elseif (indexCol > BaseImage.boxLengthOffset * EnlargeRatio * 0.5 + 1 && indexRow > BaseImage.boxLengthOffset * EnlargeRatio * 0.5 + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset * EnlargeRatio * 0.5 + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset * EnlargeRatio * 0.5 + 1 < RowsMat)
                    boxLength = round(BaseImage.boxLengthOffset * EnlargeRatio* 0.5);
                    entry = 0;
                    
                elseif (indexCol > BaseImage.boxLengthOffset * EnlargeRatio * 0.25+ 1 && indexRow > BaseImage.boxLengthOffset * EnlargeRatio * 0.25 + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset * EnlargeRatio * 0.25 + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset * EnlargeRatio * 0.25 + 1 < RowsMat)
                    boxLength = round(BaseImage.boxLengthOffset * EnlargeRatio * 0.25);
                    entry = 0;
                    
                elseif (indexCol > BaseImage.boxLengthOffset * EnlargeRatio * 0.1+ 1 && indexRow > BaseImage.boxLengthOffset * EnlargeRatio * 0.1 + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset * EnlargeRatio * 0.1 + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset * EnlargeRatio * 0.1 + 1 < RowsMat)
                    boxLength = round(BaseImage.boxLengthOffset * EnlargeRatio * 0.1);
                    entry = 0;
                    
                elseif (indexCol > BaseImage.boxLengthOffset * 2 + 1 && indexRow > BaseImage.boxLengthOffset * 2 + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset * 2 + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset * 2 + 1 < RowsMat)
                    boxLength = BaseImage.boxLengthOffset * 2;
                    
                elseif (indexCol > BaseImage.boxLengthOffset + 2 + 1 && indexRow > BaseImage.boxLengthOffset + 2 + 1) &&...
                        (indexCol + BaseImage.boxLengthOffset + 2 + 1 < ColsMat && indexRow + BaseImage.boxLengthOffset + 2 + 1 < RowsMat)
                    boxLength = BaseImage.boxLengthOffset + 2;
                else
                    break                                                  % Exit When Window Size Reach Max
                end
            else                                                           % Calculate Non-Initial Window Zoom Ratio
                if boxLength < ColsMat/8 && boxLength < RowsMat/8          % Check if New Window Length Exceeds Boundry
                    if (indexCol > boxLength + 1 + 1 && indexRow > boxLength + 1 + 1) &&...
                            (indexCol + boxLength + 1 + 1 < ColsMat && indexRow + boxLength + 1 + 1 < RowsMat)
                        
                        boxLength = boxLength + 1;                         % Addup Initial New Window Length
                    else
                        break                                              % Exit When Window Size Reach Max
                    end
                else
                    break
                end
            end
            %% Use Integral Image for Calculating SSD Vector for Current Box Size
            for StackIndex = 1:D
                DispValLL = ImgStack{StackIndex}(indexCol + round(boxLength) + 1, indexRow + boxLength + 1);
                DispValLU = ImgStack{StackIndex}(indexCol - round(boxLength)    , indexRow + boxLength + 1);
                DispValRL = ImgStack{StackIndex}(indexCol + round(boxLength) + 1, indexRow - boxLength);
                DispValRU = ImgStack{StackIndex}(indexCol - round(boxLength)   , indexRow - boxLength);
                DispValStack{StackIndex}(indexCol,indexRow) =  DispValLL - DispValLU - DispValRL + DispValRU;
                SSDVector(StackIndex) = DispValStack{StackIndex}(indexCol,indexRow);
            end
            %% Store Previous Std Value
            stdValPrevious(indexCol,indexRow) = stdMap(indexCol,indexRow);
            
            %% ReCalculate Std Value
            stdMap(indexCol,indexRow) = func_NormalizedVectorSTD(SSDVector);
            
            %% Check if Next Window Size Enlarge is needed
            if (ratioThresholdHigh > ratioMap(indexCol,indexRow) && ratioMap(indexCol,indexRow) > ratioThresholdLow) &&...
                    (stdMap(indexCol,indexRow) <= stdValPrevious(indexCol,indexRow)) ||...
                    ((ratioMap(indexCol,indexRow) > ratioHighThreshold) && (stdMap(indexCol,indexRow) > stdHighThreshold)) % Enlarge only once
                break
            end
            boxLengthMat(indexCol,indexRow) = boxLength;
        end
        %%
        for VectorIndex = 1:D                                              % Find Stack Globan Minimun
            if SSDVector(VectorIndex) == min(SSDVector)
                StackNumber(indexCol,indexRow) = VectorIndex;
            end
        end
        waitbar(0.2 + indexCol/ColsMat*0.8,WaitBarX,'Calculating Disparity Map...');
    end
end
%% Noise Reduction
for indexCol = 2:ColsMat-1
    for indexRow = 2:RowsMat-1
        % Store Reference Pixel Value
        sp1 = StackNumber(indexCol+1,indexRow+1); sp2 = StackNumber(indexCol-1,indexRow-1);
        sp3 = StackNumber(indexCol+1,indexRow-1); sp4 = StackNumber(indexCol-1,indexRow+1);
        sp5 = StackNumber(indexCol+1,indexRow);   sp6 = StackNumber(indexCol,indexRow+1);
        sp7 = StackNumber(indexCol-1,indexRow);   sp8 = StackNumber(indexCol,indexRow-1);
        pixelSample = StackNumber(indexCol,indexRow);                      % Store Sample Pixel Value
        ErrorPixel = 0;
        
        if pixelSample ~= sp1                                              % Count for Error Rate
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp2
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp3
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp4
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp5
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp6
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp7
            ErrorPixel = ErrorPixel + 1;
        end
        if pixelSample ~= sp8
            ErrorPixel = ErrorPixel + 1;
        end
        
        if ErrorPixel >= 6                                                 % High Error Rane, Noise Pixel, need to be reduced
            StackNumberNoiseReduced(indexCol,indexRow) = (sp1 + sp2 + sp3 + sp4 + sp5 + sp6 + sp7 + sp8)/8;
        end
        
    end
end
for indexCol = 1:ColsMat
    for indexRow = 1:RowsMat
        if StackNumberNoiseReduced(indexCol,indexRow) ~= 0
            StackNumber(indexCol,indexRow) = StackNumberNoiseReduced(indexCol,indexRow);
        end
    end
end
close(WaitBarX);
%% Plot Data Figures
% figure(10);
% mesh(stdMap);
% figure(11);
% mesh(ratioMap);
% figure(12);
% mesh(boxLengthMat);
% figure(13);
% mesh(StackNumber);

%% Output Disparity Map
DisparityMap = StackNumber;

end

