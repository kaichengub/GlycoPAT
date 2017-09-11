function gpMW = glypepMW(varargin)
%GLYPEPMW: Calculate the molecular weight or mass to charge ratio 
% depending on its fragment type and charge state.
% 
% Syntax: 
%     gpMW = glypepMW(glypepstring)
%     gpMW = glypepMW(glypepstring,fragmenttype)
%     gpMW = glypepMW(glypepstring,fragmenttype,charge)
%
% Input: 
%    glypepstring: a glycopeptide in SmallGlyPep format
%    fragmenttype: the type of glycopeptide fragment. It can be 'full','b'
%       'y' for glycan, or 'full', 'b', 'y','c' or 'z' for peptide.
%    charge: charge state z
% 
% Output: 
%   gpMW: is M (not M+H) if the fragment type is full.It is m/z if the 
%     fragment types is 'b','c','y' or 'z'
%   
% 
% Children function: breakGlyPep, joinGlyPep, pepMW, glyMW
% 
% Examples: 
%  
% Example 1 (same as pepMW.m, peptide with modifications):
% >> [finalMW]=glypepMW('FNWY<s>VDGVM<o>VHNAK','b',1)
% Answer:
%       finalMW = 1757.741573235
%
% >> [finalMW]=glypepMW('FNWY<s>VDGVM<o>VHNAK','b',2)
% Answer:
%       finalMW = 879.374699135
% 
% >> [finalMW]=glypepMW('FNWY<s>VDGVM<o>VHNAK','y',2)
% Answer:
%       finalMW = 888.379981485
%
% **(if 'full' is used, charge is not considered)
% >> [finalMW]=glypepMW('FNWY<s>VDGVM<o>VHNAK','full',1) 
% Answer:
%       finalMW = 1774.7443129
%
% >> [finalMW]=glypepMW('FNWY<s>VDGVM<o>VHNAK','full',2) 
% Answer:
%       finalMW = 1774.7443129
%
% Example 2 (glycan only):
% >> gly = '{n{n{h{h{h{h}}{h{h{h}{h{h}}}}}}}}'
%    [finalMW] = glypepMW(gly,'full',1)
% Answer: 
%       finalMW = 1882.6447196
%
% >> gly='{h{h{h{h}}{h{h{h}{h{h}}}}}}'
%    [finalMW] = glypepMW(gly,'b',1)
% Answer: 
%       1459.483235132
%
% >> gly='{n{n{h{h{h{h}}}}}}'
%    [finalMW] = glypepMW(gly,'y',1)
% Answer: 
%       finalMW = 1073.3884267
%
% Example 3 (glycopeptide):
% >> SmallGlyPep='FLPET{n{s}{h{s}}}EPPRPM<o>M<o>D';
%    [finalMW]=glypepMW(SmallGlyPep,'full',1)
% Answer: 
%       SmallGlyPep = FLPET{n{s}{h{s}}}EPPRPM<o>M<o>D
%       finalMW =  2538.0288503
%
% >> z=3;
%    H=1.007825035;
%    (finalMW+(z*H))/z
% Answer:
%       ans = 847.017430535
%
% >> [finalMW]=glypepMW('LPET{n{s}{h{s}}}EPPRPM<o>M<o>D','y',3)
% Answer: 
%       finalMW = 797.994637235
%
% >> [finalMW]=glypepMW('FLPET{n{h}}EPPRPM<o>M<o>D','y',2)
% Answer: 
%       finalMW = 978.926833785
%
% Example 4 (glycopeptide- custom monosaccharides and variable modification):
% >> SmallGlyPep='FLPET{n{s}{h{s}{50}}}EPPR<100>PM<o>M<o>D';
%    [finalMW]=glypepMW(SmallGlyPep,'full',1)
% Answer: 
%       finalMW = 2688.0288503
%
% >> [finalMW]=glypepMW(SmallGlyPep,'b',2)
% Answer:
%       finalMW = 1336.016967835
%
% Example 5 
% >> SmallGlyPep='VPT{n{h}}T{n{h{s}}}AASTPDAVDK';
%     [finalMW]=glypepMW(SmallGlyPep,'full',1)
%  Answer: 
%      finalMW = 2393.0479764;
%
%See also glyMW,ptm,pepMW,glypepformula. 

% Example 3 is from Lo et al. J Biol Chem, 2013. 288(20): p. 13974-87.
% Author: Sriram Neelamegham and Gang Liu
% Last Date Updated: 8/10/2014 by Gang Liu

format longg
if(nargin==3)
    SmallGlyPep=varargin{1};
    fragType=varargin{2};
    z=varargin{3};
elseif (nargin==2)
    SmallGlyPep=varargin{1};
    fragType=varargin{2};
    z=1;
elseif (nargin==1)
    SmallGlyPep=varargin{1};
    fragType='full';
    z=1;
end

[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);  % Parse SmallGlyPep
pep=pepMat.pep;
if ~isempty(modMat)
    pep=joinGlyPep(pepMat,[],modMat);   % join modMat and pepMat to form modified peptide, pep
end

if isempty(pepMat.pep)                        % This is purely a glycan
    glyFull = glyMW(SmallGlyPep);
    if strcmpi(fragType,'full')           %fragType=='full'
        gpMW=glyFull;
    elseif strcmpi(fragType,'b')          %fragType=='b'
        gpMW=glyFull-18.0105647+1.007825032; % Full MW-OH
    else                    % must be y-type glycan
        gpMW=glyFull+1.0078246;             % Full MW+H
    end
    if ~strcmp(fragType,'full')  %  (fragType~='full')
        gpMW=(gpMW+(z-1)*1.007825032)/z;
    end
else                                          % This has a peptide
    [pepFull,pepB,pepY,pepC,pepZ] = pepMW(pep,z);
    if strcmp(fragType,'full')              %fragType=='full'
        gpMW=pepFull;
    elseif strcmpi(fragType,'b')             %fragType=='b'
        gpMW=pepB;
    elseif strcmpi(fragType,'c');            %fragType=='c'
        gpMW=pepC;
    elseif strcmpi(fragType,'y');            %fragType=='y'
        gpMW=pepY;
    else
        gpMW=pepZ;   % must be z-type peptide fragment
    end
    if ~isempty(glyMat)     % This is a glycopeptide with backbone breakage
        if ~strcmpi(fragType,'full')      % (fragType~='full')
            gpMW=z*(gpMW-1.007825032);  % change back to full MW for ions
        end
        for i=1:length(glyMat)
            gly=glyMat(i).struct;
            glyFull=glyMW(gly);
            gpMW=gpMW+glyFull-18.0105647;  % Add glycan MW and subtract water
        end
        if ~strcmpi(fragType,'full')            % (fragType~='full')   % go back to m/z if ions
            gpMW=(gpMW+z*1.007825032)/z;
        end
    end
end
end
