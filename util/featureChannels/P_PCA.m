function out = P_PCA( fparam, img, typeidx )
% CREATED FOR HYPE

if ( nargin == 1 )

  out.weight = fparam.pcaWeight;
  
  out.numtypes = fparam.numberPCA;
  for i = 1:fparam.numberPCA;
      out.descriptions{i} = ['PCA' int2str(i)];
  end

else
  PCAim = makeHype2PCA(img,fparam.numberPCA);
  out.map = PCAim(:,:,typeidx);
end