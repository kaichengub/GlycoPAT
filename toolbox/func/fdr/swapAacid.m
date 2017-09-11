function Decoy=swapAacid(varargin)
%SWAPAACID: Flip the aminoacids of the input SmallGlyPep in a variety of
% manners/'types' to create a 'Decoy' output.
%
% Syntax: 
%   Decoy=swapAacid(SmallGlyPep,type)
%   Decoy=swapAacid(SmallGlyPep,'select',inSeq,outSeq)
%
% Input: 'SmallGlyPep' to be swapped, 'types' of modification:
% 1. 'first': flips the first and last a. acids
% 2. 'firstTwo': flips the first two a. acids with the last two
% 3. 'flip': Reverses input SmallGlyPep sequence
% 4. 'select': arbitrarily exchanges amino acids in array 'inSeq' with those in 'outSeq',
% e.g. to exchange a. acids 3 and 7 in SmallGlyPep, inSeq=[3,7] and outSeq=[7,3].
% 5. 'random': Randomizes the amino acids
%
% Output: 'Decoy' which is the modified SmallGlyPep output
%
% Children function: breakGlyPep
%
% Example 1:
% SmallGlyPep='M<o>{n{h{s}}}GHKL<o>FLM{n{h{x}}}L';
% type='flip';
% Decoy=swapAacid(SmallGlyPep, type)
% Ans: LM{n{h{x}}}LFL<o>KHGM<o>{n{h{s}}}
% 
% Example 2:
% SmallGlyPep='M<o>{n{h{s}}}GHKL<o>FLM{n{h{x}}}L';
% type='select';
% inSeq=[3,8]
% outSeq=[8,3]
% Decoy=swapAacid(SmallGlyPep, type, inSeq, outSeq)
% Ans: M<o>{n{h{s}}}GM{n{h{x}}}KL<o>FLHL
%
%See also glycanDecoy, fdrdecoy, fdr, fdrfiler, scorProb, Pvalue. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

inSeq=[];
outSeq=[];
if (nargin==4)
    SmallGlyPep=varargin{1};
    type=varargin{2};
    inSeq=varargin{3};
    outSeq=varargin{4};
elseif (nargin==2)
    SmallGlyPep=varargin{1};
    type=varargin{2};
end

Aacid=[];
Acell={};
Decoy='';
[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);
for i=1:length(pepMat.pep)
    Aacid=pepMat.pep(i);
    for j=1:length(modMat)
        if modMat(j).pos==i
            Aacid=[Aacid,modMat(j).struct];
        end
    end
    for j=1:length(glyMat)
        if glyMat(j).pos==i
            Aacid=[Aacid,glyMat(j).struct];
        end
    end
    Acell(i)=cellstr(Aacid);
end
inMat=1:length(Acell);
outMat=inMat;
if strcmpi(type,'first')  % case insensitive comparison
    outMat(1)=inMat(end);
    outMat(end)=inMat(1);
elseif strcmpi(type,'firstTwo')
    outMat(1)=inMat(end);
    outMat(2)=inMat(end-1);
    outMat(end)=inMat(1);
    outMat(end-1)=inMat(2);
elseif strcmpi(type,'flip')
    outMat=length(Acell):-1:1;
elseif strcmpi(type,'random')
    outMat=randperm(length(inMat));
else                      % must be 'select'
    for i=1:length(inSeq)
        outMat(outSeq(i))=inMat(inSeq(i));
    end
end
for i=1:length(Acell)
    Decoy=[Decoy,char(Acell(outMat(i)))];
end

end
