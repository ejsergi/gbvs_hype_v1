function out = O_orientation( fparam , img, typeidx )
% ADAPTED TO HYPE
if ( nargin == 1 )
  out.weight = fparam.orientationWeight;  
  out.numtypes = length( fparam.gaborFilters );
  for i = 1 : length( fparam.gaborFilters ),
    out.descriptions{i} = sprintf('Gabor Orientation %g',fparam.gaborangles(i));
  end
else
  Intim = makeHype2intensity(img,fparam.lambda);
  gaborFilters = fparam.gaborFilters;
  j = typeidx;
  f0 = myconv2(Intim,gaborFilters{j}.g0);
  f90 = myconv2(Intim,gaborFilters{j}.g90);
  out.map = abs(f0) + abs(f90);
  out.map = attenuateBordersGBVS(out.map,13);
end
