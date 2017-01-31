% Read the image
img = imread('samplepics/building.tiff');
sizeImg = size(img(:,:,1));

% inicialize some parameters
param = makeGBVSParams;
param.channels = 'LPO';                % Feature maps to be computed

param.lambda = 400:10:1000;             % Wavelenght of each channel of the
                                        % input image
                                        
param.numberPCA = 3;                    % Number of PCAs to be used

% Run gbvs on the hyperspecral image
out = falsecolor_gbvs(img,param,700);

lege = repmat(max(out,[],3).^.25,1,1,3);

imgRGB = makeHype2RGB(img,param.lambda);

finalIM = imgRGB.*(1-lege) + out.*lege;
figure; subplot(1,2,1); imshow(imgRGB); title('Original');
subplot(1,2,2); imshow(finalIM); title('Mapped');