function EST =  eclipseDiskDetection(IMG, CONFIG)

resizeFactor    = CONFIG.PARAM.REG.PREP.EDED_RESIZE_FACTOR; % [%]
diskDiameterEst = CONFIG.PARAM.REG.PREP.EDED_DIAM_GUESS;    % [%]

majorAxisGuess = resizeFactor * diskDiameterEst;

IMG_REDUCED = imresize(IMG, resizeFactor);

IMG_EDGE = edge(im2gray(IMG_REDUCED), 'Roberts');

ellipseDetectionParams.minMajorAxis   = 0.85 * majorAxisGuess;
ellipseDetectionParams.maxMajorAxis   = 1.15 * majorAxisGuess;
ellipseDetectionParams.rotation       = 0.00;
ellipseDetectionParams.rotationSpan   = 5.00;
ellipseDetectionParams.minAspectRatio = 0.85;
ellipseDetectionParams.randomize      = 20;
ellipseDetectionParams.numBest        = 1;
ellipseDetectionParams.uniformWeights = false;
ellipseDetectionParams.smoothStddev   = 0.10;

bestFit = ellipseDetection(IMG_EDGE, ellipseDetectionParams, ...
    CONFIG.PARAM.REG.DEBUG);

EST.X0        = round(bestFit(1) / resizeFactor);
EST.Y0        = round(bestFit(2) / resizeFactor);
EST.A         = round(bestFit(3) / resizeFactor);
EST.B         = round(bestFit(4) / resizeFactor);
EST.ANG       = bestFit(5);
EST.EST_SCORE = bestFit(6);

if CONFIG.FLAG.VERIFY_REG == true
    FIG_HND = figure;
    imshow(IMG);
    ellipse( ...
        EST.A, ...
        EST.B, ...
        EST.ANG * (pi / 180), ...
        EST.X0, ...
        EST.Y0, 'r' ...
    );
    axis equal;
    drawnow;
    waitfor(FIG_HND);
end

end