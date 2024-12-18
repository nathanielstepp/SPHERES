function [IMG_DATA, CONFIG] = SPHERES_REG_EXE(IMG_DATA, CONFIG)
%% FILE INFORMATION:

% FILENAME:    SETIP_REF.m
% PROJECT:     2024 Total Solar Eclipse Photography
% COMPONENT:   Image Registration MATLAB Function
% CREATED BY:  Nathaniel A. Stepp
%              stepp.nathaniel@gmail.com
% CREATED ON:  12 April 2024
% UPDATED ON:  25 May 2024
%
% -----------------------------------------------------------------------
% DESCRIBTION: TBD.
% -----------------------------------------------------------------------

%% IMAGE REGISTRATION:

if CONFIG.PARAM.REG.IMPORT == false

% == IMAGE REGISTRATION SETUP: ==========================================

% TBD:
    IMG_DATA.REG.TFORM = cell(IMG_DATA.IMG_CNT, 1);
    IMG_DATA.REG.DATA  = cell(IMG_DATA.IMG_CNT, 1);

% TBD:
    R_FIXED = imref2d(size(IMG_DATA.RAW.DATA{CONFIG.PARAM.REF_FRAME}));

% == IMAGE REGISTRATION PROCESSING: =====================================

for i = 1:1:IMG_DATA.IMG_CNT

% TBD:
    clc;
    fprintf('Registering image %2.0f of %2.0f ...\n', ...
        i, IMG_DATA.IMG_CNT);

switch CONFIG.PARAM.REG.TYPE  
% -----------------------------------------------------------------------
% PHASE-CORRELATION REGISTRATION:
% -----------------------------------------------------------------------

case {'phasecorr', 'Phasecorr', 'PhaseCorr', 'PHASECORR',}

% TBD:
    IMG_DATA.REG.TFORM{i} = imregcorr( ...
        IMG_DATA.PRE.DATA{i}, ...
        IMG_DATA.PRE.DATA{CONFIG.PARAM.REF_FRAME}, ...
        CONFIG.PARAM.REG.TRANSFORM_TYPE, ...
        "Window", true ...
    );

% -----------------------------------------------------------------------
% MONO-MODAL REGISTRATION:
% -----------------------------------------------------------------------
case {'monomodal', 'Monomodal', 'MonoModal', 'MONOMODAL'}

% TBD:
    [optimizer, metric] = imregconfig(CONFIG.PARAM.REG.TYPE  );

% TBD:
    optimizer.GradientMagnitudeTolerance = 1.0000e-05;
    optimizer.MinimumStepLength = 1.0000e-05;
    optimizer.MaximumStepLength = 0.001;
    optimizer.MaximumIterations = 300;
    optimizer.RelaxationFactor = 0.75;

% TBD:
    IMG_DATA.REG.TFORM{i} = imregtform( ...
        IMG_DATA.PRE.DATA{i}, ...
        IMG_DATA.PRE.DATA{CONFIG.PARAM.REF_FRAME}, ...
        CONFIG.PARAM.REG.TRANSFORM_TYPE, ...
        optimizer, ...
        metric, ...
        'InitialTransformation', IMG_DATA.REG.TFORM{i}, ...
        'DisplayOptimization', true ...
    );

% -----------------------------------------------------------------------
% MULTI-MODAL REGISTRATION:
% -----------------------------------------------------------------------
case {'multimodal', 'Multimodal', 'MultiModal', 'MULTIMODAL'}

% TBD:
    CONFIG.PARAM.REG.TYPE   = 'multimodal';
    [optimizer, metric] = imregconfig(CONFIG.PARAM.REG.TYPE  );

% TBD:
    optimizer.GrowthFactor = 1.01;
    optimizer.Epsilon = 1.50e-7;
    optimizer.InitialRadius = 6.25e-3;
    optimizer.MaximumIterations = 300;
    metric.NumberOfSpatialSamples = 500;
    metric.NumberOfHistogramBins = 50;
    metric.UseAllPixels = 1;

% TBD:
    IMG_DATA.REG.TFORM{i} = imregtform( ...
        IMG_DATA.PRE.DATA{i}, ...
        IMG_DATA.PRE.DATA{CONFIG.PARAM.REF_FRAME}, ...
        CONFIG.PARAM.REG.TRANSFORM_TYPE, ...
        optimizer, ...
        metric, ...
        'InitialTransformation', IMG_DATA.REG.TFORM{i}, ...
        'DisplayOptimization', true ...
    );
    
% TBD:
    IMG_DATA.REG.DATA{i} = imregister( ...
        IMG_DATA.PRE.DATA{i}, ...
        IMG_DATA.PRE.DATA{CONFIG.PARAM.REF_FRAME}, ...
        CONFIG.PARAM.REG.TRANSFORM_TYPE, ...
        optimizer, ... 
        metric, ...
        'InitialTransformation', IMG_DATA.REG.TFORM{i}, ...
        'DisplayOptimization', true ...
    );

% -----------------------------------------------------------------------
end

% TBD:
    IMG_DATA.REG.DATA{i} = imwarp(...
        IMG_DATA.RAW.DATA{i}, ...
        IMG_DATA.REG.TFORM{i}, ...
        'OutputView', R_FIXED ...
    );

end
end

%% REGISTRATION VERIFICATION:

if CONFIG.FLAG.VERIFY_REG == true
    waitfor(imshowpair( ...
                IMG_DATA.REG.DATA{1}, ...
                IMG_DATA.REG.DATA{end}, ...
                'diff' ...
                ) ...
        );
end

end