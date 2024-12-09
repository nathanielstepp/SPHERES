%% FILE INFORMATION:

% FILENAME:    Stepp_SETIP_Main.m
% PROJECT:     2024 Total Solar Eclipse Photography
% COMPONENT:   Image Processing Wrapper Script
% CREATED BY:  Nathaniel A. Stepp
%              stepp.nathaniel@gmail.com
% CREATED ON:  12 April 2024
% UPDATED ON:  25 May 2024
%
% -----------------------------------------------------------------------
% DESCRIBTION: TBD.
% -----------------------------------------------------------------------

%% SCRIPT SETUP:

% Close all current figure-windows, clear workspace variables, clear
% MATLAB command window, & and format printing of data to MATLAB command
% window in "long" format:
    close all; clear; clc; format long;

% TBD:
    CONFIG   = struct();
    IMG_DATA = struct();

% Definition of main analysis directory present-working-path:
    CONFIG.PATH.MAIN_DIR = pwd;

% Adding tools (e.g, custom functions, classes, tools, & MLFE content)
% directory (& all nested sub-directories) to path:
    toolsPath = '\TOOLS';
    addpath(genpath(fullfile(CONFIG.PATH.MAIN_DIR, toolsPath)));

% Adding tools (e.g, custom functions, classes, tools, & MLFE content)
% directory (& all nested sub-directories) to path:
    resultsPath = '\RESULTS';

%% USER INPUT:

% Definition of filepath to original image raw data:
    CONFIG.PATH.INPUT_PATH = 'C:\Users\Nathaniel Stepp\Desktop\ONGOING\20240918_Partial-Lunar-Eclipse\DEV\MATLAB\DATA\SEQ-01';
% Definition of original image raw data filetype:
    CONFIG.PATH.INPUT_EXT = '*.TIF';

% Definition of script configuration for either performing image
% registration processing or perform an image import of a previously
% completed registration process (uses same reference filepath):
    CONFIG.PARAM.REG.IMPORT = false;

% Definition of base output folder name:
    CONFIG.PATH.OUTPUT_FOLDER_NAME = 'IMG-SEQ-01_MATLAB';

% TBD:
    CONFIG.PARAM.REF_FRAME                   = 1;
    CONFIG.PARAM.REG.PREP.CROP_MARGIN        = 0.25; % [%]
    CONFIG.PARAM.REG.PREP.EDED_RESIZE_FACTOR = 0.15; % [%]
    CONFIG.PARAM.REG.PREP.EDED_DIAM_GUESS    = 4000; % [px]
    CONFIG.PARAM.REG.PREP.SPIN_BLUR_ANG      = 0; % [deg]
    CONFIG.PARAM.REG.TYPE                   = 'PhaseCorr';
    CONFIG.PARAM.REG.TRANSFORM_TYPE         = 'Similarity';
    CONFIG.PARAM.REG.DEBUG                  = false;
    CONFIG.FLAG.VERIFY_REG                  = false;

% TBD:
    CONFIG.FLAG.GENERATE_STACK = true;
    CONFIG.FLAG.VERIFY_STACK = false;

% TBD:
    CONFIG.FLAG.EXPORT_STACK_FRAMES = true;
    CONFIG.FLAG.EXPORT_STACK_RESULT = true;

% TBD:
    CONFIG.GEN_SEQ_VID = true;
    CONFIG.VERIFY_SEQ_VID_FRAME = false;

%% IMAGE DATA IMPORT:

[IMG_DATA, CONFIG] = SETIP_IMPORT(IMG_DATA, CONFIG);

% TBD:
    CONFIG.DATE_TIME.STR = ...
        char(datetime('now', 'TimeZone', 'local'), 'yyyyMMdd_HHmmss_');

% TBD:
    CONFIG.OUTPUT_PATH = ...
        horzcat( ...
            CONFIG.PATH.MAIN_DIR, ...
            resultsPath, ...
            horzcat( ...
                '\', ...
                CONFIG.DATE_TIME.STR, ...
                CONFIG.PATH.OUTPUT_FOLDER_NAME ...
            ) ...
        );

%% IMAGE PRE-PROCESSING / REGISTRATION / POST-PROCESSING:

[IMG_DATA, CONFIG] = SETIP_REG_PRE(IMG_DATA, CONFIG);

[IMG_DATA, CONFIG] = SETIP_REG_EXE(IMG_DATA, CONFIG);

[IMG_DATA, CONFIG] = SETIP_REG_PST(IMG_DATA, CONFIG);

%% IMAGE STACKING:

[IMG_DATA, CONFIG] = SETIP_STACK(IMG_DATA, CONFIG);

%% IMAGE STACK VIDEO GENERATION & EXPORT

if CONFIG.GEN_SEQ_VID == true

% TBD:
    cd(CONFIG.OUTPUT_PATH);

% TBD:
    frameRate = 60; % [frames/sec]
    dwellTimePerImg = 0.15; % [sec]

% TBD:
    frameCropWidth = 3900; % [px]
    frameAspectRatio = 1; % [px/px]

% TBD:
    frameCropHeight = frameCropWidth / frameAspectRatio;

% TBD:
    imgSeqVidOutput = VideoWriter(horzcat(CONFIG.PATH.OUTPUT_FOLDER_NAME, ...
        '_SEQ-VID.mp4'), 'MPEG-4');

% TBD:
    imgSeqVidOutput.FrameRate = frameRate;

% TBD:
    open(imgSeqVidOutput);

% TBD:
    framesPerImg = round(frameRate * dwellTimePerImg);
    totVidFrames = IMG_DATA.IMG_CNT*framesPerImg;

% TBD:
for i = 1:1:IMG_DATA.IMG_CNT
% TBD:
    frame = IMG_DATA.REG.DATA{i};
% TBD:
    [frameRows, frameCols, ~] = size(frame);
    frameCenterX = round(frameCols / 2) + 90;
    frameCenterY = round(frameRows / 2) - 100;
    frameCropX = max(1, frameCenterX - round(frameCropWidth / 2));
    frameCropY = max(1, frameCenterY - round(frameCropHeight / 2));
    frameCropWidthAdjusted = ...
        min(frameCropWidth, frameCols - frameCropX);
    frameCropHeightAdjusted = ...
        min(frameCropHeight, frameRows - frameCropY);
    frameCropArea = [frameCropX, frameCropY, ...
        frameCropWidthAdjusted, frameCropHeightAdjusted];
    frame = imcrop(frame, frameCropArea);
    if CONFIG.VERIFY_SEQ_VID_FRAME == true
        waitfor(imshow(frame));
    end
% TBD:
    frame = im2uint8(frame);
% TBD:
    for j = 1:round(frameRate * dwellTimePerImg)
        clc; fprintf( ...
            'Writing Vid. Frame %3.0f of %3.0f ...\n', ...
            ((i - 1)*framesPerImg + j), ...
            totVidFrames ...
        );
        writeVideo(imgSeqVidOutput, frame)
    end
end

% TBD:
    close(imgSeqVidOutput);

% TBD:
    cd(CONFIG.PATH.MAIN_DIR);

end