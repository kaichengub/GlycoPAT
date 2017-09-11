function newFrag=UQFragIon(Frag)
%UQFRAGION: Remove duplicates in Frag based on reported peptide structure
%
% Syntax: 
%   newFrag=UQFragIon(Frag)
% 
% Input: Fragment ion structure, Frag, which may contain duplicate elements
%
% Output: Fragment ion structure, newFrag, after removal of duplicate elements based
%   on .sgp structure field
%
% Children function: None
%
%See also COMPILEFRAGS,JOINGLYPEP,GLYCANFRAG,BREAKGLYPEP,MULTISGPFRAG. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 08/11/14 by Gang Liu

temp=[];
newFrag=[];
for i=1:length(Frag)
    tempFrag=Frag(i).sgp;
    if not(any(strcmp(tempFrag,temp)))
        newFrag=[newFrag,Frag(i)];
    end
    temp=[temp,cellstr(Frag(i).sgp)];
end
end