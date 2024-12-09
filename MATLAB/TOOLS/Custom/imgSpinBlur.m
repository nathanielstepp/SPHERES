function [imgOut, maskOut] = imgSpinBlur(...
    imgIn, cx, cy, angRng, gaussDev, maskOffset, debugFlag)

[rows, cols] = size(imgIn);
imgOut = zeros(rows, cols, 'like', imgIn);

rotFrameNum = numel(angRng);

parfor i = 1:numel(angRng)
    imgRot = rotateAround(imgIn, cx, cy, angRng(i), 'bicubic');
    imgOut = imgOut + imgRot/rotFrameNum;
end

if gaussDev > 0
    imgOut = imgaussfilt(imgOut, gaussDev);
end

if debugFlag == true
    waitfor(imshowpair(imgOut,imgOut,'diff'));
end

maskOut = imsubtract(imgIn, imgOut) + maskOffset;

if debugFlag == true
    waitfor(imshow(maskOut));
end

end