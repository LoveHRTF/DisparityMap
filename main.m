%% ========================================================================
% File Name: main.m
% Author   : Ziwei Chen
% Date     : Oct-05-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.0
%% ========================================================================
clear; clc; close all;
% Add Path
addpath(genpath('src'));
addpath(genpath('images'));

% Import Left and Right Images
imageL = ('tsukubaL.pgm');imageR = ('tsukubaR.pgm');
windowSize = 5; D = 12;

% Change Method. 0 for O(NDS^2), 1 for O(ND), 2 for O(ND) with adaptive
% window
Method = 2;

% Function for disparity map calculation
imageDisparityLeft = func_DisparityMap(imageL,imageR,windowSize,D,Method);

% Display Results
x= mat2gray(imageDisparityLeft);
figure(1);
imshow(x);




