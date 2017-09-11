function [dispfragions,varargout] = sortFragIon(fragmentIons)
%sortFragIon: sort the fragmentions
%   
%  Syntax: 
%       dispfragions = sortFragIon(fragmention)
%       [dispfragions,fragioncluster] = sortFragIon(fragmention)
%  
%  Example:
%     Example 1:
%        fragmentions = multiSGPFrag();
%        dispfragions = sortFragIon(fragmentions)
%        fragionviewer(dispfragions);
%
%
%See also breakGlyPep,multiSGPFrag.

%Author: Gang Liu
%Date: 12/27/14
sgp = fragmentIons(1).original;
[pepMat,glyMat,~]= breakGlyPep(sgp);
numAAinSGP       = length(pepMat.pep);
numMonoinSGP     = 0;           
for i = 1 : length(glyMat)
    numMonoinSGP = numMonoinSGP+ glyMat(i).len;
end

fragIonCluster.cIons=[];
fragIonCluster.zIons=[];
fragIonCluster.bIons=[];
fragIonCluster.bglycoIons=[];
fragIonCluster.yIons=[];
fragIonCluster.yglycoIons=[];
fragIonCluster.fullIons=[];
for i=1:length(fragmentIons);
    fragmentIons(i).newtype = fragmentIons(i).type;
    if (~isempty(regexp(fragmentIons(i).type,'c','once')))
       fragIonCluster.cIons=[fragIonCluster.cIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'z','once')))
       fragIonCluster.zIons=[fragIonCluster.zIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'b[^1-9]','once')))
       fragIonCluster.bglycoIons=[fragIonCluster.bglycoIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'b[1-9]','once')))
       fragIonCluster.bIons=[fragIonCluster.bIons fragmentIons(i)];   
    elseif(~isempty(regexp(fragmentIons(i).type,'y[^1-9]','once')))
       fragIonCluster.yglycoIons=[fragIonCluster.yglycoIons fragmentIons(i)];  
    elseif(~isempty(regexp(fragmentIons(i).type,'y[1-9]','once')))
       fragIonCluster.yIons=[fragIonCluster.yIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'none','once')))
       fragIonCluster.fullIons=[fragIonCluster.fullIons fragmentIons(i)];   
    end
end

% sort c,z,b,y ion in the ascerding/descending order
fragIonCluster = sortions(fragIonCluster,'cIons',numAAinSGP,1);   
fragIonCluster = sortions(fragIonCluster,'zIons',numAAinSGP,-1);   
fragIonCluster = sortions(fragIonCluster,'bIons',numAAinSGP,1);   
fragIonCluster = sortions(fragIonCluster,'yIons',numAAinSGP,-1);
fragIonCluster = sortglycoions(fragIonCluster,'bglycoIons',numMonoinSGP,1);  
fragIonCluster = sortglycoions(fragIonCluster,'yglycoIons',numMonoinSGP,-1);

%rearrange the order
subcluster = fieldnames(fragIonCluster);
dispfragions =[];
for i = 1 : length(subcluster)
    if(~isempty(fragIonCluster.(subcluster{i})))
        dispfragions=[dispfragions;(fragIonCluster.(subcluster{i})')];
    end
end
dispfragions=dispfragions';

if(nargout==2)
    varargout{1}=fragIonCluster;    
end

end

function fragIonCluster = sortglycoions(fragIonCluster,iontype,numMonoinSGP,order)
% rename the Glyco Bion and sort them based on the number of
% monosaccharides
if(isempty(fragIonCluster.(iontype)))  
  return
end

numglycoions = length(fragIonCluster.(iontype));
iontypelist = zeros(1,numglycoions);

if(order==1)
    istart=1;
    iend=numMonoinSGP;
    iinterval = 1;
    ionname = 'B';
elseif(order==-1)
    istart=numMonoinSGP;
    iend=0;
    iinterval = -1;
    ionname = 'Y';   
end

for i = 1 :numglycoions
    fragsgp =  fragIonCluster.(iontype)(i).sgp;
    [~,glyMat_frag,~]= breakGlyPep(fragsgp);
    if(~isempty(glyMat_frag))
        iontypelist(i) = glyMat_frag.len;  
    end
end

newindex=[];
for k = istart :iinterval:iend
    foundionindex = find(~(iontypelist-k));
    newindex =[newindex;foundionindex']; 
    if(length(foundionindex)==1)
         fragIonCluster.(iontype)(foundionindex).newtype=[ionname int2str(k)];
    elseif(length(foundionindex)>1)
        for j =1: length(foundionindex)
           fragIonCluster.(iontype)(foundionindex(j)).newtype=...
                 [ionname,int2str(k),'.',int2str(j)];
        end      
    end
end

fragIonCluster.(iontype)=fragIonCluster.(iontype)(newindex);
end

function fragIonCluster = sortions(fragIonCluster,ionfield,numAAinSGP,order)
if(isempty(fragIonCluster.(ionfield)))  
  return
end
iontypelist = zeros(1,length(fragIonCluster.(ionfield)));
% if(numAAinSGP-1~=length(fragIonCluster.(ionfield)))
%     error('MATLAB:GLYCOPAT:ERRORLIST','THE LIST OF IONS IS NOT COMPLETE');
% end

if(order==1)
    istart=1;
    iend=numAAinSGP-1;
    iinterval = 1;
elseif(order==-1)
    istart=numAAinSGP-1;
    iend=1;
    iinterval = -1;
end
ctheolist = istart :iinterval:iend;
for i=1:1:length(fragIonCluster.(ionfield))
    fragsgp =  fragIonCluster.(ionfield)(i).sgp;
    [pepMat_frag,~,~]= breakGlyPep(fragsgp);
    if(~isempty(pepMat_frag))
       iontypelist(i) = length(pepMat_frag.pep);    
    end
end

if(~isequal(iontypelist,ctheolist))
    if(length(iontypelist)==length(ctheolist))
        [newlist,newindexlist]=sort(ctheolist);
        if(~isequal(newlist,ctheolist))
           error('MATLAB:GLYCOPAT:ERRORLIST','THE LIST OF IONS IS NOT COMPLETE');
        end
        fragIonCluster.(ionfield)=fragIonCluster.(ionfield)(newindexlist);
    else
        newindexlist=[];
        for k = istart :iinterval:iend
            foundionindex = find(~(iontypelist-k));
            newindexlist =[newindexlist;foundionindex'];            
        end
        fragIonCluster.(ionfield)=fragIonCluster.(ionfield)(newindexlist);
    end
end

end

