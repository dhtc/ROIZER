function [BW,maskedImage] = segIM2(PIX)

% gaborX = createGaborFeatures(X);
% % Threshold image - manual threshold
% BW = X > 9.019600e-02;

% keyboard

%%

% Threshold image
BW = imbinarize(PIX,.1);

close all; p=imagesc(BW); 
p.CData=BW; pause(.3)

mu = mean(BW(:)); disp(mu);





%---------------TOO LITTLE SIGNAL
mu = mean(BW(:)); disp(mu);
if mu < .01
    for s = 0:.001:1

        BW = imbinarize(PIX,.1-s);
        p.CData=BW; pause(.02)

        mu = mean(BW(:));
        if mu > .01; break; end
    end
end
disp(mu);
p=imagesc(BW); 
p.CData=BW; pause(.2)

t = .1-s;


%---------------TOO MUCH BACKGROUND
if mu > .01
    for s = .1:.001:1

        BW = imbinarize(PIX,t);
        p.CData=BW; pause(.02)
        t = t+.0002;

        mu = mean(BW(:));
        if mu < .01; break; end
    end
end
disp(mu);
p=imagesc(BW); 
p.CData=BW; pause(.2)





% mask=([0 0 0 0 0 0 0 0 0
%        0 0 0 0 0 0 0 0 0
%        0 0 0 1 1 1 0 0 0
%        0 0 1 1 1 1 1 0 0
%        0 0 0 1 1 1 0 0 0
%        0 0 0 0 1 0 0 0 0
%        0 0 0 0 0 0 0 0 0
%        0 0 0 0 0 0 0 0 0]);
% 
% B = imopen(BW, strel('line', 3, 1));  close all; p=imagesc(B); p.CData=B;
% B = imopen(B, strel('line', 3, 45));  close all; p=imagesc(B); p.CData=B;
% B = imopen(B, strel('line', 3, 120));  close all; p=imagesc(B); p.CData=B;
% B = imopen(B, strel('line', 3, 90));  close all; p=imagesc(B); p.CData=B;


%%

% 0pen mask
BW = imopen(BW, strel('disk', 1, 4));

p=imagesc(BW); 
p.CData=BW; pause(.2)



% Active contour with texture
BW = activecontour(PIX, BW, 3, 'Chan-Vese');

p=imagesc(BW); 
p.CData=BW; pause(.2)







% Open mask with disk
BW = imopen(BW, strel('disk', 1, 4));

p=imagesc(BW); 
p.CData=BW; pause(.2)




% Dilate mask with disk
BW = imdilate(BW, strel('disk', 1, 4));

p=imagesc(BW); 
p.CData=BW; pause(.2)






% Clear borders, fill holes
BW = imclearborder(BW);
BW = imfill(BW, 'holes');

p=imagesc(BW); 
p.CData=BW; pause(.2)




































% Create masked image.
maskedImage = PIX;
maskedImage(~BW) = 0;
end

function gaborFeatures = createGaborFeatures(im)

disp('CREATING GABOR FEATURES PLEASE WAIT...')

if size(im,3) == 3
    im = prepLab(im);
end

im = im2single(im);

imageSize = size(im);
numRows = imageSize(1);
numCols = imageSize(2);

wavelengthMin = 4/sqrt(2);
wavelengthMax = hypot(numRows,numCols);
n = floor(log2(wavelengthMax/wavelengthMin));
wavelength = 2.^(0:(n-2)) * wavelengthMin;

deltaTheta = 45;
orientation = 0:deltaTheta:(180-deltaTheta);

g = gabor(wavelength,orientation);
gabormag = imgaborfilt(im(:,:,1),g);

for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma);
end

% Increases liklihood that neighboring pixels/subregions are segmented together
X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
featureSet = cat(3,gabormag,X);
featureSet = cat(3,featureSet,Y);
featureSet = reshape(featureSet,numRows*numCols,[]);

% Normalize feature set
featureSet = featureSet - mean(featureSet);
featureSet = featureSet ./ std(featureSet);

gaborFeatures = reshape(featureSet,[numRows,numCols,size(featureSet,2)]);

% Add color/intensity into feature set
gaborFeatures = cat(3,gaborFeatures,im);


disp('FINISHED CREATING GABOR FEATURES!')

end

function out = prepLab(in)

% Convert L*a*b* image to range [0,1]
out = in;
out(:,:,1)   = in(:,:,1) / 100;  % L range is [0 100].
out(:,:,2:3) = (in(:,:,2:3) + 100) / 200;  % a* and b* range is [-100,100].

end
