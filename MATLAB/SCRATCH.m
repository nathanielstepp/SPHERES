%% SCRATCH CLEAN START:

close all; clear; clc

mainDirectory = pwd;
toolsPath = '\TOOLS';
addpath(genpath(fullfile(mainDirectory, toolsPath)));

fig = 1;

%% IMAGE GRADIENT EXPERIMENTING:

close all; clc;

[Gmag,Gdir] = imgradient(im2gray(imgData_RAW{20}),'sobel');
imshowpair(Gmag,Gdir,"montage");

%% DEBLUR ATTEMPT #1 - PART 01:

close all; clc;

I = im2double(im2gray(imgData_RAW{1}));

noise_var = 0.0001;
estimated_nsr = noise_var / var(I(:));

WEIGHT = edge(im2gray(imgData_RAW{1}), "Sobel");
se = strel('disk', 3);
WEIGHT = 1 - double(imdilate(WEIGHT, se));
WEIGHT([1:3, end - (0:2)], :) = 0;
WEIGHT(:, [1:3, end - (0:2)]) = 0;

figure
imshow(WEIGHT)
title("Weight Array")

%% DEBLUR ATTEMPT #1 - PART 02:

close all; clc;

PSF = fspecial('gaussian', [20, 20], 100);

tic
[J, PSF_RECON] = deconvblind(I, PSF, 30, [], WEIGHT, estimated_nsr);
toc

imshow(J)

%% DEBLUR ATTEMPT #1 - PART 03:

close all; clc;

fig = fig + 1;
figure(fig);

ax = tight_subplot(1, 2, 0.05, 0.05, 0.05); hold on;

axes(ax(1));
view(3);
mesh(PSF);
grid on; grid minor;
title('Original PSF Guess');
xlabel('x');
ylabel('y');
zlabel('z');
view(3)

axes(ax(2));
view(3);
mesh(PSF_RECON);
grid on; grid minor;
title('Estimated PSF');
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

 % linkprop(ax,'CameraPosition');

hold off;

%% DEBLUR ATTEMPT #2:

close all; clc;

g = im2double(imgData_RAW{1});
H = fspecial('gaussian', [9 9], 2);

opts.rho_r   = 2;
opts.beta    = [1 1 0];
opts.print   = true;
opts.alpha   = 0.7;
opts.method  = 'l2';

mu = 10000;

tic
out = deconvtv(g, H, mu, opts);
toc

figure(1);
imshow(g);
title('input');

figure(2);
imshow(out.f);
title('output');

%% ECLIPSE-DISK CENTER-ESTIMATION:

close all; clc;

imFile = "H:\20240408_TSE24-Vacay_Day-6\PHOTO\DEV\IMG-SEQ\MATLAB\DSC_6874-Enhanced-NR.tif";
img = imread(imFile);

% PARAMS.RESIZE_FACTOR         = 0.25;
% PARAMS.DIAMETER_EST_PX       = 1200;
% PARAMS.DEBUG_FLAG            = true;

EST = eclipseDiskDetection(img, CONFIG);


%% CUSTOM SPIN BLUR TEST:

clear maskOut; close all; clc;

% img = im2uint16(checkerboard(400, 5, 5));

% cx = 1000;
% cy = 1000;

cx = round(EST.X0/resizeFactor);
cy = round(bestFits(:, 2)/resizeFactor);

angMax = 1.5;
angInc = 0.005;
angRng = -angMax:angInc:angMax;

gaussDev = 1;
offset  = (2^16)/2;

[~, maskOut] = imgSpinBlur( ...
    adapthisteq(im2gray(img)), ...
    EST.X0,                    ...
    EST.Y0,                    ...
    angRng,                    ...
    gaussDev,                  ...
    offset,                    ...
    true                       ...
);

%% IMG CONTRAST ENHANCEMENT WITH SPIN BLUR MASK:

close all; clc;

blendIter = 1;
offsetAdj = +0.00;

imgBlend = img;
for i = 1:blendIter
    imgBlend = imblend( ...
        maskOut - offsetAdj*offset, imgBlend, 1, 'soft light eb2', 2);
end

figure; imshowpair(img,imgBlend,'diff');

figure; imshow(imgBlend);

%%

close all; clear imgTEMP_A; clear L; clear imgTEMP_B; clc;

imgTEMP_A = rgb2lab(imgBlend);
maxL = 100;
L = imgTEMP_A(:, :, 1) / maxL;

imgTEMP_A(:,:,1) = adapthisteq(L, ...
    'NumTiles'    , [20, 20], ...
    'ClipLimit'   , 0.0050, ...
    'NBins'       , round(1.00*256), ...
    'Range'       , 'full', ...
    'Distribution', 'rayleigh', ...
    'Alpha'       , 0.40...
    ) * maxL;

% nL = 10;
% avgL   = mean2(L);
% sigmaL = std2(L);
% upLimL = 0;%avgL - nL*sigmaL;
% loLimL = 0.80;%avgL + nL*sigmaL;
% gammaL = 1.25;
% imgTEMP_A(:,:,1) = imadjust(L, [upLimL, loLimL], [], gammaL)*maxL;

imgTEMP_B = lab2rgb(imgTEMP_A);

figure; imshow(imgTEMP_B);