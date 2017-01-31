function final_map = falsecolor_gbvs(img,param,cutting)

param1 = param; param2 = param;
lambda = param.lambda;
param1.lambda = lambda(lambda<cutting);
param2.lambda = lambda(lambda>=cutting);
param2.channels = 'P';

vis_map = gbvs_hype_v1(img(:,:,lambda<cutting),param1);
inf_map = gbvs_hype_v1(img(:,:,lambda>=cutting),param2);

final_map = zeros(size(img(:,:,1:3)));
final_map(:,:,1) = inf_map.master_map_resized;
final_map(:,:,2) = vis_map.master_map_resized;
final_map(:,:,3) = inf_map.master_map_resized;


