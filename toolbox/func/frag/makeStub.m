function [SGPout]=makeStub(SGPin,stubLen)
% Purpose: Create glycopeptide stub for HCD mode fragmentation
%          This is the base peptide with small glycan overhangs
% uses glycanFrag
% Author: Sriram Neelamegham
% Date: 12/09/2016
% 
bracket=0;
breakpt=[];
for i=1:length(SGPin) 
    if strcmp(SGPin(i),'{')
    bracket=bracket+1;
    if bracket==(stubLen+1)
    breakpt=[breakpt,i];
    end  
    end
    if strcmp(SGPin(i),'}')
    bracket=bracket-1;
    end

end
SGPout=glycanFrag(SGPin,breakpt);
end