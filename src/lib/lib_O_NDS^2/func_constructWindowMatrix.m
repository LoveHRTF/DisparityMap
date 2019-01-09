function [WindowedMatrix] = func_constructWindowMatrix(ImgMat)

ImgWindowsMat = zeros(ImgMat.imgSize.V,ImgMat.imgSize.H,ImgMat.boxLength,ImgMat.boxLength);
%% Search Windows within Input Image Matrix
for searchPixV = ImgMat.searchStartPix : ImgMat.searchEndPix.V             % for all rolls
    for searchPixH = ImgMat.searchStartPix : ImgMat.searchEndPix.H         % for all points in roll
        
        %% Search Pixel Value inside Windos
        windowV = 1;
        windowH = 1;
        for boxPixIndexH = (searchPixH - ImgMat.boxLengthOffset) : (searchPixH + ImgMat.boxLengthOffset)
            for boxPixIndexV = (searchPixV - ImgMat.boxLengthOffset) : (searchPixV + ImgMat.boxLengthOffset)
                ImgWindowsMat(searchPixV,searchPixH,windowV,windowH) = ImgMat.rawImgDat(boxPixIndexV,boxPixIndexH);
                windowV = windowV + 1;
            end
            windowH = windowH + 1;
            windowV = 1;
        end
    end
end
%% Output Results
WindowedMatrix = ImgWindowsMat;
end

