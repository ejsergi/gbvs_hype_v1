
% Read the image
img = imread('samplepics/building.tiff');
sizeImg = size(img(:,:,1));

% inicialize some parameters
param = makeGBVSParams;
param.channels = 'LPO';                 % Feature maps to be computed

param.lambda = 400:10:1000;             % Wavelenght of each channel of the
                                        % input image
                                        
param.numberPCA = 3;                    % Number of PCAs to be used

% Run gbvs on the hyperspecral image
out = gbvs_hype_v1(img,param);

% Plot out the resutls of each feature channel
numChannels = length(out.map_types);
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,numChannels+2,1)
imgRGB = makeHype2RGB(img,param.lambda);
imshow(imgRGB); title('Original')
for i = 1 : numChannels
    
    colorSmap = imresize(out.top_level_feat_maps{i},sizeImg);
    subplot(1,numChannels+2,i+1);
    imshow(heatmap_overlay( imgRGB , colorSmap ));
    title(out.map_types{i})
    
end

% Plot the final saliency map
figure; imshow(heatmap_overlay( imgRGB, out.master_map_resized ));
title('Final Saliency Map');