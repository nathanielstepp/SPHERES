function imgSeq2Vid(varargin)

if nargin == 1
    config = varargin{1};
elseif(nargin > 1) && (nargin < 3)
    config = varargin{1};
    frame = varargin{2};
else
    error('Invalid number of input arguments!');
end

%%

% Unpacking "config" structure parameters:
    if exist('frame', 'var')
        fprintf(' ** Using proveded cell array of image data for video frames...\n');
    elseif isfield(config, 'imgDir')
        imgDir = config.imgDir;
    else
        error('ERROR: Image directory parameter undefined!')
    end
% Unpacking "config" structure parameters:
    if isfield(config, 'imgType')
        imgType = config.imgType;
    else
        warning('WARNING: imgType undefined! Using all files in imgDir.');
    end
% Unpacking "config" structure parameters:
    if isfield(config, 'vidName')
        vidName = config.vidName;
    else
        warning('WARNING: vidName undefined! Using date/timestamped string of format "YYYYDDMM_HHmmSS_VID-SEQ" for vidName.');
        vidName = horzcat( ...
            char( ...
                datetime( ...
                    'now', ...
                    'TimeZone', ...
                    'local' ...
                ), ...
                'yyyyMMdd_HHmmss_' ...
            ), ...
            'VID-SEQ' ...
        );
    end
% Unpacking "config" structure parameters:
    if isfield(config, 'vidEncoding')
        vidEncoding   = config.vidEncoding;
    else
        warning('WARNING: vidEncoding undefined! Using default "MPEG-4".');
        vidEncoding = 'MPEG-4';
    end
% Unpacking "config" structure parameters:
    if isfield(config, 'frameRate')
        frameRate   = config.frameRate;
    else
        warning('WARNING: frameRate undefined! Using default 60 fps.');
        frameRate = 60;
    end
% Unpacking "config" structure parameters:
    if isfield(config, 'dwellTime')
        dwellTime   = config.dwellTime;
    else
        warning('WARNING: dwellTime undefined! Using default 0.1 sec.');
        dwellTime = 0.1; % [sec]
    end

%%

if ~exist('frame', 'var')
% Definition of current working directory:
    mainDir = pwd;
% TBD:
    cd(imgDir)
    if isfield(config, 'imgType')
        frameList = dir(imgType);
    else
        frameList = dir;
        frameList = frameList(~[frameList.isdir]);
    end
    cd(mainDir);
% TBD:
    frameCnt = numel(frameList);
% TBD:
    frame = cell(frameCnt, 1);
% TBD:
    textprogressbar(' *** Importing Images: ');
% TBD:
    for i = 1:1:frameCnt
        progress = round((i/frameCnt)*100);
        textprogressbar(progress)
        frame{i} = imread( ...
            fullfile( ...
                frameList(i).folder, ...
                frameList(i).name ...
            ) ...
        );
    end
    textprogressbar(' Done!');
else
% TBD:
    frameCnt = numel(frame);
end

%%

% TBD:
    imgSeqVidOutput = VideoWriter( ...
        vidName, ...
        vidEncoding ...
    );

% TBD:
    imgSeqVidOutput.FrameRate = frameRate;

% TBD:
    open(imgSeqVidOutput);

% TBD:
    framesPerImg = round(frameRate * dwellTime);

% TBD:
textprogressbar(' *** Writing Video Frames: ');
for i = 1:frameCnt

% TBD:
if isfield(config, 'crop')
    % TBD:
        [frameRows, frameCols, ~] = size(frame);
    % TBD:
        frameCenterX = round(frameCols / 2) - cropOffsetX;
        frameCenterY = round(frameRows / 2) + cropOffsetY;
    % TBD:
        frameCropX = ...
            max(1, frameCenterX - round(  frameCropWidth / 2 ));
        frameCropY = ...
            max(1, frameCenterY - round( frameCropHeight / 2 ));
    % TBD:
        frameCropWidthAdjusted = ...
            min(frameCropWidth, frameCols - frameCropX);
        frameCropHeightAdjusted = ...
            min(frameCropHeight, frameRows - frameCropY);
    % TBD:
        frameCropArea = [ ...
            frameCropX, ...
            frameCropY, ...
            frameCropWidthAdjusted, ...
            frameCropHeightAdjusted ...
        ];
        frame = imcrop(frame, frameCropArea);
    % TBD:
        if DEBUG == true
            waitfor(imshow(frame));
        end
end

% TBD:
    for j = 1:framesPerImg
        progress = round(...
            (((i - 1)*framesPerImg + j)/(frameCnt*framesPerImg))*100 ...
        );
        textprogressbar(progress);
        writeVideo(imgSeqVidOutput, im2double(frame{i}))
    end

end

% TBD:
    textprogressbar(' Done!');

% TBD:
    close(imgSeqVidOutput);

end