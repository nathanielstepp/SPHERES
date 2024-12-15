function [IMG_DATA, CONFIG] = SETIP_IMPORT(IMG_DATA, CONFIG)
%% FILE INFORMATION:

% FILENAME:    TSE_IMG_IMPORT.m
% PROJECT:     2024 Total Solar Eclipse Photography
% COMPONENT:   Image Import MATLAB Function
% CREATED BY:  Nathaniel A. Stepp
%              stepp.nathaniel@gmail.com
% CREATED ON:  12 April 2024
% UPDATED ON:  17 April 2024
%
% -----------------------------------------------------------------------
% DESCRIBTION: TBD.
% -----------------------------------------------------------------------

% Initializing custom MATLAB RAW image reading from MLFE:
    readraw;

% TBD:
    cd(CONFIG.PATH.INPUT_PATH);
    CONFIG.IMG_FILE_LIST = dir(CONFIG.PATH.INPUT_EXT);
    cd(CONFIG.PATH.MAIN_DIR);

% TBD:
    [~, IMG_DATA.RAW.FNS, ~] = fileparts(transpose( ...
        fullfile({CONFIG.IMG_FILE_LIST(:).folder}, ...
        {CONFIG.IMG_FILE_LIST(:).name})));

% TBD:
    IMG_DATA.IMG_CNT = numel(CONFIG.IMG_FILE_LIST);

if CONFIG.PARAM.REG.IMPORT == false

% TBD:
    IMG_DATA.RAW.DATA =  cell(IMG_DATA.IMG_CNT, 1);
    IMG_DATA.INFO     =  cell(IMG_DATA.IMG_CNT, 1);
    IMG_DATA.EV.ABS   = zeros(IMG_DATA.IMG_CNT, 1);

% TBD:
for i = 1:1:IMG_DATA.IMG_CNT
% TBD:
    clc; fprintf( ...
        'Importing image %2.0f of %2.0f ...\n', ...
        i, IMG_DATA.IMG_CNT);
% TBD:
    IMG_DATA.RAW.DATA{i} = imread( ...
        fullfile( ...
            CONFIG.PATH.INPUT_PATH, ...
            CONFIG.IMG_FILE_LIST(i).name ...
        ) ...
    );
% TBD:
    IMG_DATA.INFO{i} = imfinfo( ...
        fullfile( ...
            CONFIG.PATH.INPUT_PATH, ...
            CONFIG.IMG_FILE_LIST(i).name ...
        ) ...
    );
% TBD:
    IMG_DATA.EV.ABS(i) = IMG_DATA.INFO{i}.DigitalCamera.ExposureTime;
end

% TBD:
    IMG_DATA.EV.REL = IMG_DATA.EV.ABS / ...
        IMG_DATA.EV.ABS(CONFIG.PARAM.REF_FRAME);

else

% TBD:
    IMG_DATA.REG.DATA =  cell(IMG_DATA.IMG_CNT, 1);
    IMD_DATA.INFO     =  cell(IMG_DATA.IMG_CNT, 1);

% TBD:
for i = 1:1:IMG_DATA.IMG_CNT
    clc; fprintf( ...
        'Importing image %2.0f of %2.0f ...\n', ...
        i, IMG_DATA.IMG_CNT);
    IMG_DATA.REG.DATA{i} = imread( ...
        fullfile( ...
            CONFIG.PATH.INPUT_PATH, ...
            CONFIG.IMG_FILE_LIST(i).name ...
        ) ...
    );
    IMG_DATA.INFO{i} = imfinfo( ...
        fullfile( ...
            CONFIG.PATH.INPUT_PATH, ...
            CONFIG.IMG_FILE_LIST(i).name ...
        ) ...
    );
end

end
end