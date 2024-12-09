function [IMG_DATA, CONFIG] = SETIP_STACK(IMG_DATA, CONFIG)
%% FILE INFORMATION:

% FILENAME:    TSE_IMG_STACK.m
% PROJECT:     2024 Total Solar Eclipse Photography
% COMPONENT:   Image Registration MATLAB Function
% CREATED BY:  Nathaniel A. Stepp
%              stepp.nathaniel@gmail.com
% CREATED ON:  12 April 2024
% UPDATED ON:  17 April 2024
%
% -----------------------------------------------------------------------
% DESCRIBTION: TBD.
% -----------------------------------------------------------------------

%% IMAGE STACKING:

if CONFIG.FLAG.GENERATE_STACK == true
% TBD:
    IMG_DATA.IMG_STACK.DATA = (blendexposure(IMG_DATA.POST.DATA{:}));
% TBD:
if CONFIG.FLAG.VERIFY_STACK == true
    waitfor(imshow(IMG_DATA.IMG_STACK.DATA));
end
end

%% REGISTERED IMAGES EXPORT:

% TBD:
    if ~isfolder(CONFIG.OUTPUT_PATH)
        mkdir(CONFIG.OUTPUT_PATH);
    end
    cd(CONFIG.OUTPUT_PATH);

% TBD:
if CONFIG.FLAG.EXPORT_STACK_FRAMES == true
% TBD:
    frameExportPath = horzcat(CONFIG.OUTPUT_PATH, '\Frames');
% TBD:
    if ~isfolder(frameExportPath)
        mkdir(frameExportPath);
    end
% TBD:
    cd(frameExportPath);
% TBD:
for i = 1:1:IMG_DATA.IMG_CNT
    clc; fprintf('Exporting registered image %2.0f of %2.0f ...\n', ...
        i, IMG_DATA.IMG_CNT);
    imwrite( ...
        IMG_DATA.POST.DATA{i}, ...
        horzcat( ...
            IMG_DATA.RAW.FNS{i}, ...
            '.tif' ...
        ) ...
    );
end
% TBD:
    cd(CONFIG.OUTPUT_PATH);
end

% TBD:
if CONFIG.FLAG.EXPORT_STACK_RESULT == true
imwrite( ...
    IMG_DATA.IMG_STACK.DATA, ...
    horzcat( ...
        CONFIG.PATH.OUTPUT_FOLDER_NAME, ...
        '_STACKED_RESULT', '.tif' ...
    ) ...
);
end

% TBD:
    cd(CONFIG.PATH.MAIN_DIR);

end