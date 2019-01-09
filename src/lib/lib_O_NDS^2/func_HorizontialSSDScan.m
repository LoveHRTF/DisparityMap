function SSDvectorMatrix = func_HorizontialSSDScan(BaseMat,RefeMat,D)
sizeBase = size(BaseMat);

ImgV = sizeBase(1);
ImgH = sizeBase(2);
WinV = sizeBase(3);
WinH = sizeBase(4);
WindowOffset = (WinV - 1)/2;

SSDVector = zeros(1,D);
DisparityMat = zeros(ImgV,ImgH);



%% Loop For All Pixels in Base Image Range
for indexImgV = WindowOffset + D: ImgV + WindowOffset - D
    for indexImgH = WindowOffset + D: ImgH + WindowOffset - D
        
        %% Loop For All Pixels in Reference Image Range in Given D
        indexSSDVec = 0;
        for indexImgRefeH = indexImgH - D + 1: indexImgH 
            %% Find Sum of Square Difference String (SSD) for Perticular Pixel
            indexSSDVec = indexSSDVec + 1;
            
            for indexWinV = 1 : WinV
                for indexWinH = 1 : WinH
                    % Calculate SSD of one window on ImageL vs. Every
                    % window in Range D on ImageR, store as a vector
                    SSDVector(indexSSDVec) = SSDVector(indexSSDVec) +...
                        (BaseMat(indexImgV,indexImgH,indexWinV,indexWinH) -...
                        RefeMat(indexImgV,indexImgRefeH,indexWinV,indexWinH))^2;
                end
            end
        end
        %% Find Local Minimum for Current SSD String
        localMin = min(SSDVector);
        for index = 1:D
            if SSDVector(index) == localMin
                DisparityMat(indexImgV,indexImgH) = index - D;
            end
        end
        SSDVector = zeros(1,D);
        % Find Local Minimal and Record Disparity Number
    end  
end
SSDvectorMatrix = DisparityMat;
end

