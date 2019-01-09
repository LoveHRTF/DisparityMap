% File Name: func_NormalizedVectorSTD.m
% Author   : Ziwei Chen
% Date     : Oct-10-2018
% Modified : Ziwei Chen
% Date     : NA
% Version  : NA
% Descrip  : This function was to calculate the normalized STD for vector
%%
function VectorStd = func_NormalizedVectorSTD(VectorValues)

localMin = min(VectorValues);                                              % Find local min
VectorValuesNew = VectorValues - localMin;                                 % Calculate new vector
newlocalMax = max(VectorValuesNew);                                        % Find local max
SSDVectorNormalized = VectorValuesNew./newlocalMax;                        % Normalize vector

VectorStd = std(SSDVectorNormalized);

end

