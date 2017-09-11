function  SmallGlyPepnew = linucs2SmallGlyPep(varargin)
%linucs2SmallGlyPep: Read the sequence file of a glycan in the format
% of LINUCS and return a string in the format of SmallGlyPep.
%
% Syntax:   
%  smallGlypep = linucs2SmallGlyPep(LINUCSFILENAME) reads a file name in the
%  string input argument INFILENAME using a LINUCS format and outputs
%  a string in SmallGlyPep format.
%
%  smallGlypep = linucs2SmallGlyPep(linucsfileformat,'linucs') converts the
%   glycan structure in Linucs format and outputs a string in SmallGlyPep
%   format
%
% Examples:
% 
% Example 1:
%  linucs2SmallGlyPep('highmannose.linucs');
% 
% Example 2: 
%  linucs2SmallGlyPep('m3gngn.linucs');
%
% Example 3:
%  man5struct=glycanMLread('highmannose.linucs','linucs');
%  man5linucs = man5struct.toLinucs;
%  linucs2SmallGlyPep(man5linucs,'linucs');
%
% See also digestSGP.

% Author: Kai Cheng,Sriram Neelamegham & Gang Liu
% Date Lastly Updated: 4/3/2014

% input check
narginchk(1,2);

% handle input arguments
if(nargin==1)
    linucsFileName = varargin{1};
    linucsformat = 'char';
    
    % input variable type check
    isCharArg = ischar(linucsFileName)&&ischar(linucsformat) ;
    if(~isCharArg)
        errorReport(mfilename,'NonStringInputs');
    end
    
    glycanstructObj = glycanMLread(linucsFileName,'linucs');
    linucsglycanstruct = glycanStrwrite(glycanstructObj,'linucs');
elseif(nargin==2)
    linucsglycanstruct  = varargin{1};
    linucsformat = varargin{2};
    
    % input variable type check
    isCharArg = ischar(linucsglycanstruct)&&ischar(linucsformat) ;
    if(~isCharArg)
        errorReport(mfilename,'NonStringInputs');
    end
end

smallGlyPep = linucs2SmallGly(linucsglycanstruct);
capexpr     = '[a-z]';
capexpr2    = '[{}]';
capexpr3    ='{}';
capexpr4    ='}[a-z]{';
SmallGlyPeptemp=char(zeros(1,length(smallGlyPep)));
list=regexp(smallGlyPep,capexpr);
list2=regexp(smallGlyPep,capexpr2);
list3=regexp(smallGlyPep,capexpr3);
list4=regexp(smallGlyPep,capexpr4);
list4=[list4 length(smallGlyPep)];
j=0;
for m=1:length(list3)*2
    if mod(m,2)
        tempgly=list(find(list <= list3((m+1)/2) & list > j));
        tempstr=list2(find(list2 <= list3((m+1)/2) & list2 > j));
        tempglyr=tempgly+ones(1,length(tempgly));
        tempstrr=tempstr-ones(1,length(tempstr));
        SmallGlyPeptemp(tempglyr) = smallGlyPep(tempgly);
        SmallGlyPeptemp(tempstrr) = smallGlyPep(tempstr);
        j=list3((m+1)/2);
    else
        SmallGlyPeptemp(list3(m/2)+1:list4(m/2))=smallGlyPep(list3(m/2)+1:list4(m/2));
        j=list4(m/2);
    end
end
SmallGlyPepnew = SmallGlyPeptemp;
end

function SmallGlyPep=linucs2SmallGly(GlyPep)
SmallGlyPep=[];
Square=findstr('][',GlyPep);
Start=findstr('[',GlyPep);
StartSquare=setdiff(Start,Square+1);
End=findstr(']',GlyPep);
EndSquare=setdiff(End,Square);
NumMono=length(StartSquare);
SquarePair=[StartSquare', EndSquare']; % optional variable

lenGlyPep=length(GlyPep);
i=1;
j=1;
Sq=1;
while (i<=lenGlyPep),
    if GlyPep(i)=='['
        String=GlyPep(StartSquare(Sq):EndSquare(Sq));
        if not((isempty(regexp(String,'GlcpNAc', 'once')))& ...
                (isempty(regexp(String,'GalNAc', 'once'))))
            NewChar='n';
        elseif not((isempty(regexp(String,'Glc', 'once')))& ...
                (isempty(regexp(String,'Man', 'once')))& ...
                (isempty(regexp(String,'Gal', 'once'))))
            NewChar='h';
        elseif not(isempty(regexp(String,'Fuc', 'once')))
            NewChar='f';
        elseif not(isempty(regexp(String,'Xyl', 'once')))
            NewChar='x';
        elseif not((isempty(regexp(String,'GlcA', 'once')))& ...
                (isempty(regexp(String,'IdoA', 'once'))))
            NewChar='u';
        elseif not(isempty(regexp(String,'Neup5Ac', 'once')))
            NewChar='s';
        elseif not(isempty(regexp(String,'Kdn', 'once')))
            NewChar='k';
        elseif not(isempty(regexp(String,'Neup5Gc', 'once')))
            NewChar='g';  % This section is currently resticted to few of the monosaccharide
        else           % types. This can be enhanced in the future
            NewChar='?';
        end
        SmallGlyPep=strcat(SmallGlyPep,NewChar);
        j=j+1;
        i=EndSquare(Sq)+1;
        Sq=Sq+1;
    else
        SmallGlyPep(j)=GlyPep(i);  % This adds the non-glycan portions to the abbreviated GlyPep sequence
        j=j+1;
        i=i+1;
    end
end
end