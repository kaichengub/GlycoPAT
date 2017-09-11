function [pepFull,pepB,pepY,pepC,pepZ] = pepMW(varargin)
%PEPMW: Calculate peptide molecular weight or its mass to charge ratio 
%  
% Synatx: 
%   [pepFull,pepB,pepY,pepC,pepZ]=pepMW(peptidestring,z)
%  
% Input: 
%   peptidestring: peptide string containing modifications in <>, e.g. 
%   Y<s> denotes tyrosine sulfation and M<o> methionine oxidation. 
%   z: Charge state
% 
% Output: 
%   pepFull: Peptide MW given as M (NOT M+H) 
%   pepB,pepY,pepC,pepZ: mass charge ratio of peptide presented in forms of 
%    b-y and c-z ions at charge state z. To calculate m/z of peptide,add 
%    z*1.0078246 to calculated peptide wt. and divide by z.
% 
% Examples: 
%
% Example 1:
% For overall molecular wt.:
% >> pepMW('FNWYVDGVEVHNAK',1)
% Answer:
%       ans= 1676.7947014 (This is the molecular wt. only)
%
% Example 2:
% To obtain overall MW and fragment mass at z=2:
% >> [pepFull,pepB,pepY,pepC,pepZ]=pepMW('FNWYVDGVEVHNAK',2)
% Answer:
%       pepFull = 1676.7947014; pepB = 830.399893385; pepY =
%       839.405175735; pepC =838.9131679355; pepZ = 831.395813702
% 
%
% Example 3 (if there is PTM modification):
% For z=1
% >> [pepFull,pepB,pepY,pepC,pepZ]=pepMW('FNWY<s>VDGVM<o>VHNAK',1)
% Answer:
%       pepFull =  1774.7443129; pepB =1757.741573235; pepY = 1775.752137935; pepC
%       =  1774.768122336; pepZ = 1759.733413869
% 
% For z=2
% >> [pepFull,pepB,pepY,pepC,pepZ]=pepMW('FNWY<s>VDGVM<o>VHNAK',2)
% Answer:
%       pepFull =  1774.7443129; pepB = 879.374699135; pepY =  888.379981485; pepC
%       = 887.8879736855; pepZ =  880.370619452
%
% Example 4 (if there is custom PTM modific ation):
% >> [pepFull,pepB,pepY,pepC,pepZ]=pepMW('FNWY<s>VDGVM<o>VHNAK<-100>',1)
% For z=1
% Answer:
%       pepFull = 1674.7443129; pepB = 1657.741573235; pepY =   1675.752137935;
%       pepC =  1674.768122336; pepZ = 1659.733413869
%
% For z=2
% >> [pepFull,pepB,pepY,pepC,pepZ]=pepMW('FNWY<s>VDGVM<o>VHNAK<-100>',2)
% Answer:
%       pepFull = 1674.7443087; pepB = 829.374697035; pepY = 838.379979385;
%       pepC = 837.8879715855; pepZ = 830.370617352
% 
% Answer check:
% Answers for multiple charges for both b-y and c-z checked using protein prospector
% Example 1:
% Monoisotopic M+H at z=1 equals 1677.8020 using protein prospector
% M=1676.7947 from Expasy PeptideMass
%
% Example 2:
% bion(z=2)=830.3993; cion (z=2)= 838.9126; yion (z=2)=839.4046; zion
% (z=2)=831.3953 using protein prospector
%
% Example 3:
% Prot. Prospect results : M+H=1775.7516;
% For z=1:: bion= 1757.7410; cion=1774.7676; yion=1775.7516; zion=1759.7329
% For z=2:: bion= 879.3742 ; cion=887.8874; yion=888.3794; zion=880.3701
%
%See also glyMW,ptm,glypepMW,pepformula. 

% Authro: Sriram Neelamegham
% Date Last modified: 8/10/2014 by Gang Liu

if(nargin==2)
    pep=varargin{1};
    z=varargin{2};
% else
%     pep='FNWY<s>VDGVM<o>VHNAK';
%     z=1;
end
format longg;

% calculate molecular weight for peptide portion 
pepseqpos  = regexp(pep,Aminoacid.getaa1letcharexpr);
pepseq     = pep(pepseqpos);
pepMW =0;
for i = 1: length(pepseq)
    aacid = pepseq(i);
    add=0;
    aacidMW =0;
     if (aacid=='G')
        aacidMW=57.0214635+add; %Gly
    elseif (aacid=='A')
        aacidMW=71.0371136+add; %Ala
    elseif (aacid=='S')
        aacidMW=87.0320282+add; %Ser
    elseif (aacid=='P')
        aacidMW=97.0527637+add; %Pro
    elseif (aacid=='V')
        aacidMW=99.0684137+add; %Val
    elseif (aacid=='T')
        aacidMW=101.047678+add; %Thr
    elseif (aacid=='C')
        aacidMW=103.009184+add; %Cys
    elseif (aacid=='L')
        aacidMW=113.084064+add; %Leu
    elseif (aacid=='I')
        aacidMW=113.084064+add; %Ile
    elseif (aacid=='N')
        aacidMW=114.042927+add; %Asn
    elseif (aacid=='D')
        aacidMW=115.0269429+add; %Asp
    elseif (aacid=='Q')
        aacidMW=128.0585771+add; %Gln
    elseif (aacid=='K')
        aacidMW=128.0949627+add; %Lys
    elseif (aacid=='E')
        aacidMW=129.0425929+add; %Glu
    elseif (aacid=='M')
        aacidMW=131.0404844+add; %Met
    elseif (aacid=='H')
        aacidMW=137.0589113+add; %His
    elseif (aacid=='F')
        aacidMW=147.0684137+add; %Phe
    elseif (aacid=='R')
        aacidMW=156.1011103+add; %Arg
    elseif (aacid=='Y')
        aacidMW=163.0633284+add; %Tyr
    elseif (aacid=='W')
        aacidMW=186.0793126+add; %Trp
    end
    pepMW=pepMW+aacidMW;     
end

% calculate modification part
modchar    = regexp(pep,'<[+-\d\.a-z]+>','match');
for i = 1 : length(modchar)
    mod = modchar{i}(2:end-1);
    modmw = ptm(mod);
    if(modmw==0)
       modmw = str2double(mod) ;
    end
    pepMW=pepMW+modmw; 
end

pepFull  =  pepMW+18.0105647;                                         % add water to MW since there is no hydrolysis at ends
pepBMono =  pepMW+1.007825035;                                        % b-ion when z=1 (internal amino acids + H)
pepB     = (pepBMono+(z-1)*1.007825035)/z;                            % This is the b-fragment of pep with charge z 
pepC     = (pepBMono+17.026549101+(z-1)*1.007825035)/z;               % This is the c-fragment of pep [=(bion+NH3+(z-1))/z
pepYMono =  pepFull+1.007825035;                                      % y-ion when z=1
pepY     = (pepYMono+(z-1)*1.007825035)/z;                            % This is the y-fragment of pep at charge z
pepZ     = (pepYMono-17.026549101+1.007825035+(z-1)*1.007825035)/z;   % z-ion at charge z

end