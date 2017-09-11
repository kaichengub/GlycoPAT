function residueToTerminalChar = getresiduetoterminal(obj,residue,varargin)
%getresiduetoterminal return the string starting from specificied
% residue to the terminal
%    getresiduetoterminal(obj,residue)
%
% See also removeNonRedEndResidue

if(~isempty(varargin))
    nreResidue = varargin{1};    
end
iterresidue = residue;
residueToTerminalChar='';
count = 0;
isChild = ~isempty(iterresidue.linkageChildren);
while(isChild)
    residueTypeChar =  [iterresidue.stereoConfig.symbol,'-'];
    resType = iterresidue.residueType;
    if(~strcmp(resType.name,'freeEnd'))
        residueTypeChar = [residueTypeChar,resType.name];
        residueTypeChar = [residueTypeChar,','];
        residueTypeChar = [residueTypeChar,iterresidue.ringType.rSize];
    else
        residueTypeChar=resType.name;
    end  
    
    if(~isempty( iterresidue.linkageParent))
            LinkageChar = iterresidue.linkageParent.bonds.posParent;
            LinkageChar = [LinkageChar,...
                iterresidue.anomer.symbol];
            LinkageChar = [LinkageChar,...
                iterresidue.anomer.carbonPos];
    else
        LinkageChar='';
    end
    residuelinkage        = [LinkageChar,residueTypeChar];
    residueToTerminalChar = [residueToTerminalChar,residuelinkage]; 
    isChild = ~isempty(iterresidue.linkageChildren);
    if(isChild)
        if(length(iterresidue.linkageChildren)==2)
            for i = 1 : length(iterresidue.linkageChildren);
                ithchildresidude = iterresidue.linkageChildren(i).child;
                if(isequal(ithchildresidude.residueType.name,nreResidue.residueType.name))
                    continue
                end
                iterresidue = ithchildresidude;
            end
        else
            iterresidue = iterresidue.linkageChildren.child;
        end
        residueToTerminalChar = [residueToTerminalChar,'--'];
        count =count +1;
    end
    
end