function out = I_intensity( fparam , img, typeidx)
% ADAPTED TO HYPE

if ( nargin == 1)  
  out.weight = fparam.intensityWeight;
  out.numtypes = 1;
  out.descriptions{1} = 'Intensity';    
else
    Intim = makeHype2intensity(img,fparam.lambda);
    out.map = Intim;
end
