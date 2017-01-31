function out = C_color( fparam, img, typeidx )
% ADAPTED TO HYPE

if ( nargin == 1 )

  out.weight = fparam.colorWeight;
  
  out.numtypes = 2;
  out.descriptions{1} = 'Blue-Yellow';
  out.descriptions{2} = 'Red-Green';

else
  RGBim = makeHype2RGB(img,fparam.lambda);
  imgR = RGBim(:,:,1); imgG = RGBim(:,:,2); imgB = RGBim(:,:,3);
  imgGray = max(max(imgR,imgG),imgB);
    
  if ( typeidx ) == 1
    out.map = safeDivideGBVS( abs(imgB-min(imgR,imgG)) , imgGray );
  else
    out.map = safeDivideGBVS( abs(imgR-imgG) , imgGray );
  end
end
