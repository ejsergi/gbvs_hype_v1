function out = R_contrast( fparam , img, typeidx )
% ADAPTED TO HYPE

if ( nargin == 1 )

  out.weight = fparam.contrastWeight;
  out.numtypes = 1;
  out.descriptions{1} = 'Intensity Contrast';  

else
  
  Intim = makeHype2intensity(img,fparam.lambda);
  out.map = myContrast( Intim , round(size(Intim,1) * fparam.contrastwidth) );

end
