%% FILE INFORMATION:

% FILENAME:    vidSeqTestWrapper.m
% PROJECT:     2024 Total Solar Eclipse Photography
% COMPONENT:   Image Sequence to Video Wrapper Script
% CREATED BY:  Nathaniel A. Stepp
%              stepp.nathaniel@gmail.com
% CREATED ON:  13 May 2024
% UPDATED ON:  14 May 2024
%
% -----------------------------------------------------------------------
% DESCRIBTION: TBD.
% -----------------------------------------------------------------------

%% IMGSEQ2VID FUNCTION TEST:

% Close all current figure-windows, clear workspace variables, clear
% MATLAB command window, & and format printing of data to MATLAB command
% window in "long" format:
    close all;
    clear;
    clc; 
    format short;

% Configuration Parameters:
    config.imgDir           = 'H:\20240408_TSE24-Vacay_Day-6\PHOTO\DEV\IMG-SEQ\MATLAB\RESULTS\20240419_082428_IMG-SEQ-03_C2-C3-DR_MATLAB\Frames\';
    config.imgType          = '*.tif';
    config.vidName          = 'test';
    config.vidEncoding      = 'MPEG-4';
    config.frameRate        = 60;   % [frames/sec]
    config.dwellTime        = 0.1;  % [sec] 
    config.crop.width       = 4000; % [px]
    config.crop.aspectRatio = 16/9; % [ND; width/height]
    config.crop.offsetX     = -200; % [px]
    config.crop.offsetY     =  700; % [px]
    config.debugFlag        = true;

% "imgSeq2Vid" function call for function test:
    imgSeq2Vid(config);