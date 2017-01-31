function [rawfeatmaps, motionInfo] = getFeatureMaps( img , param , prevMotionInfo )

%
% this computes feature maps for each cannnel in featureChannels/
%

load mypath;

%%%%
%%%% STEP 1 : form image pyramid and prune levels if pyramid levels get too small.
%%%%

mymessage(param,'forming image pyramid\n');

levels = [ 2 : param.maxcomputelevel ];

imgH = {};
imgH{1} = imresize(img,0.5);

for i=levels

    imgH{i} = imresize(imgH{i-1},0.5);
    if ( (size(imgH{i},1) < 3) || (size(imgH{i},2) < 3 ) )
        mymessage(param,'reached minimum size at level = %d. cutting off additional levels\n', i);
        levels = [ 2 : i ];
        param.maxcomputelevel = i;
        break;
    end

end

%%% update previous frame estimate based on new frame
if ( (param.flickerNewFrameWt == 1) || (isempty(prevMotionInfo) ) )
    motionInfo.imgL = imgH;
else    
    w = param.flickerNewFrameWt;    
    for i = levels,
        %%% new frame gets weight flickerNewFrameWt
        motionInfo.imgL =  w * imgH{i} + ( 1 - w ) * prevMotionInfo.imgL{i};
    end
end
    
%%%
%%% STEP 2 : compute feature maps
%%%

mymessage(param,'computing feature maps...\n');

rawfeatmaps = {};

%%% get channel functions in featureChannels/directory

channel_files = dir( [pathroot '/util/featureChannels/*.m'] );

motionInfo.imgShifts = {};

for ci = 1 : length(channel_files)
  
    %%% parse the channel letter and name from filename
    parts = regexp( channel_files(ci).name , '^(?<letter>\w)_(?<rest>.*?)\.m$' , 'names');
    if ( isempty(parts) ), continue; end % invalid channel file name
    
    channelLetter = parts.letter;
    channelName = parts.rest;
    channelfunc = str2func(sprintf('%s_%s',channelLetter,channelName));
    useChannel = sum(param.channels==channelLetter) > 0;

    if (useChannel)

        mymessage(param,'computing feature maps of type "%s" ... \n', channelName);

        obj = {};
        obj.info = channelfunc(param);
        obj.description = channelName;

        obj.maps = {};
        obj.maps.val = {};

        %%% call the channelfunc() for each desired image resolution (level in pyramid)
        %%%  and for each type index for this channel.

        for ti = 1 : obj.info.numtypes            
            obj.maps.val{ti} = {};
            mymessage(param,'..pyramid levels: ');
            for lev = levels,                
                mymessage(param,'%d (%d x %d)', lev, size(imgH{lev},1), size(imgH{lev},2));                
                 if ( (channelLetter == 'F') || (channelLetter == 'M') )                   
                    if ( ~isempty(prevMotionInfo) )
                        prev_img = prevMotionInfo.imgH{lev};
                    else
                        prev_img = imgH{lev};
                    end
                    
                    if ( ~isempty(prevMotionInfo) && isfield(prevMotionInfo,'imgShifts') && (channelLetter == 'M') )
                      prev_img_shift = prevMotionInfo.imgShifts{ti}{lev};
                    else
                      prev_img_shift = 0;
                    end

                    map = channelfunc(param,imgH{lev},prev_img,prev_img_shift,ti);                    
                    if (isfield(map,'imgShift'))
                       motionInfo.imgShifts{ti}{lev} = map.imgShift; 
                    end                    
                else
                    map = channelfunc(param,imgH{lev},ti);
                end    
                obj.maps.origval{ti}{lev} = map.map;
                map = imresize( map.map , param.salmapsize , 'bicubic' );
                obj.maps.val{ti}{lev} = map;
            end
            mymessage(param,'\n');
        end

        %%% save output to rawfeatmaps structure
        eval( sprintf('rawfeatmaps.%s = obj;', channelName) );

    end
end

