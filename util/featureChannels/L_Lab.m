function out = L_Lab( fparam, img, typeidx )
% ADAPTED TO HYPE

if ( nargin == 1 )

  out.weight = fparam.colorWeight;
  
  out.numtypes = 2;
  out.descriptions{1} = 'Lightness';  
  out.descriptions{2} = 'Red-Green';
  out.descriptions{3} = 'Blue-Yellow';

else
  RGBim = makeHype2RGB(img,fparam.lambda);
  Labim = rgb2lab(RGBim);
  
  out.map = Labim(:,:,typeidx)/max(Labim(:));
end