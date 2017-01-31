function [PCAim, coeffSel] = makeHype2PCA(hypIM,numPCA)

% This functions transforms a hyperspectral image of size NxMxD, where D is
% the number of spectral channels, into an image of the first P principal 
% components.
%   - hypIM: hysperspectral image
%   - numPCA: firsts P principal components to caluclate

if ( ~exist('numPCA','var') || isempty(numPCA) ), numPCA = 3; end

[xS, yS, zS] = size(hypIM);
hypSP = reshape(hypIM, xS*yS, zS);

[coeff,score,latent] = pca(hypSP);

pcaIM = reshape(score, xS, yS, []);

PCAim = pcaIM(:,:,1:numPCA);
coeffSel = coeff(:,1:numPCA);
