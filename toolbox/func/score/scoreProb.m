function varargout=scoreProb(varargin)
%SCOREPROB: Compare the experimental MS2 spectra that are described in 'Data' with the
% theoretical fragmentation profile of glycopeptide 'SmallGlyPep'
%
% Syntax: 
%  [peakLag,htCenter,htAvg,found,search,percentIonMatch,Top10,foundPeaks]...
%   =scoreProb(Spectra,z,SmallGlyPep,MS2tol,MS2tolUnit,fragMod,add,nFrag,maxlag)
%  
% Input:
% 1. SpectraA: Input spectra
% 2. z: Charge state of candidate SmallGlyPep
% 3. SmallGlyPep: the candidate glycopeptide
% 4. MS2tol: MS2tol number
% 5. MS2tolUnit: either 'ppm' or 'Da'
% 6. fragMod: Can be 'CID', 'HCD' or 'ETD' or 'none' (CIDSpecial already are accounted for in score1file)
% 7. add: random addition to glycan molecular mass in case of decoy
% 8. nFrag [nmFrag,ngFrag,npFrag]: Fragmentation pattern
% 9. maxlag: Unused for Xcorr (typically 50)
%
% Output:
% 1-3. Xcorr: peakLag,htCenter,htAvg: peakLag should be <=|1|, ht Cener
% should be ~1 and ht. Avg should be >> 1.
% 4. found: number of experimental peaks identified in theoretical library
% 5. Search: Number of theoretical peaks that were searched.
% 6. percentIonMatch: Percent of theoretical peaks matched by experimental data
% 7. Top10: Number of top 10 experimental peaks that were matched by the theoretical spectra
% 8. foundPeaks: structure describing peaks that were identified
%
% Children Function: PolishSpectra, breakGlyPep, multiSGPFrag, CrossCorr, Pvalue
%
% See also score1Spectrum, scoreAllSpectra.

% Author: Sriram Neelamegham
% Date Lastly Updated: 12/08/16 modified by Sriram Neelamegham

if(nargin==9)||(nargin==10)||(nargin==11)
    SpectraA=varargin{1};
    z=varargin{2};
    SmallGlyPep=char(varargin{3});
    MS2tol=varargin{4};
    MS2tolUnit=varargin{5};
    fragMode=varargin{6};
    add=varargin{7};
    nmFrag=varargin{8}(1);
    ngFrag=varargin{8}(2);
    npFrag=varargin{8}(3);
    maxlag=varargin{9};
    if (nargin==10)
       ETDYION =varargin{10}; 
    else
       ETDYION = 0; 
    end
    
    if(nargin==11)
        fdrdecoy = varargin{11};
    else
        fdrdecoy = 0;
    end
end

minSpectraA=min(SpectraA(:,1));
maxSpectraA=max(SpectraA(:,1));
TempIons=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,1);   % calculate parameters for charge =1

if (strcmpi(fragMode,'CID')||strcmpi(fragMode,'CIDSpecial')||strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))         % get rid of all c and z ions if this is CID mode
    for i=length(TempIons):-1:1
        if (~isempty(regexp(TempIons(i).type,'[cz]','once')))
            TempIons(i)=[];
        end
    end
end

if strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial')     % get rid of all b and y ions if this is ETD mode
    if(ETDYION)  % y ion in ETD mode considered
        for i=length(TempIons):-1:1
          if(~isempty(regexp(TempIons(i).type,'[b]','once')))
             TempIons(i)=[];
          end
        end
    else
        for i=length(TempIons):-1:1
            if (~isempty(regexp(TempIons(i).type,'[by]','once')))
                TempIons(i)=[];
            end
        end
    end    
end

for i=1:length(TempIons)
    [~,gMat,~]=breakGlyPep(TempIons(i).sgp);      % find out how many glycans in this fragment
    if (~isempty(gMat))
       TempIons(i).mz=TempIons(i).mz+gMat(1).len*add;  % Add the random wt. to each mono of the first glycan
    end
end
TempIons          = sortFragIon(TempIons);

% Generate theroretical spectra for Cross-correlation and Probabiliy analysis. SpectraB
% contains a unique peak for each ion at one charge. This is used during Crosscorrelation Analysis
% SpectraC contins peaks for all z values. This is used for probability scores.
fcount=1;
SpectraC=[];
for i=1:length(TempIons)
    once=false;
    peak=0;
    for charge=1:z
        Tempmz=(TempIons(i).mz+(charge-1)*1.0078246)/charge;
        match=[];
        if strcmpi(MS2tolUnit,'Da')
            match=find(abs(SpectraA(:,1)-Tempmz)<=MS2tol);  % assuming this is in units of Da
        elseif(strcmpi(MS2tolUnit,'ppm'))  % MS2tolUnit=ppm
            match=find(abs(SpectraA(:,1)-Tempmz)<=MS2tol/1e6*Tempmz);
        else
            error('MATLAB:GlycoPAT:WRONGUNIT','INCORRECT UNIT');
        end
        if ~isempty(match)
            for k=1:length(match)
                foundPeaks(fcount).original=TempIons(i).original;  % information on what peaks were identified
                foundPeaks(fcount).sgp=TempIons(i).sgp;  % information on what peaks were identified
                foundPeaks(fcount).nmFrag=TempIons(i).nmFrag;  % information on what peaks were identified
                foundPeaks(fcount).npFrag=TempIons(i).npFrag;  % information on what peaks were identified
                foundPeaks(fcount).ngFrag=TempIons(i).ngFrag;  % information on what peaks were identified
                foundPeaks(fcount).mz=TempIons(i).mz;  % information on what peaks were identified
                foundPeaks(fcount).type=TempIons(i).type;  % information on what peaks were identified
                foundPeaks(fcount).charge=TempIons(i).charge;  % information on what peaks were identified
                foundPeaks(fcount).mzTheo=Tempmz;
                foundPeaks(fcount).mzExpt=SpectraA(match(k),1);
                foundPeaks(fcount).ppmError=(SpectraA(match(k),1)-Tempmz)/Tempmz*1e6;
                foundPeaks(fcount).DaError =(SpectraA(match(k),1)-Tempmz);
                foundPeaks(fcount).Intensity=SpectraA(match(k),2);
                foundPeaks(fcount).charge=charge;
                foundPeaks(fcount).peakIndex = match(k);
                foundPeaks(fcount).iontype = TempIons(i).newtype;
                fcount=fcount+1;
            end
        end
        for j=1:length(match)      % spectra B only stores 1 peak for each fragmented SGP
            if(SpectraA(match(j),2)>peak)
                peak=SpectraA(match(j),2);
                SpectraB(i)=SpectraA(match(j),1);
                once=true;
            end
        end
        
        if((Tempmz>=minSpectraA)&&(Tempmz<=maxSpectraA))  % This is the Spectra for Pvalue determination which does not depend on peak matching
            SpectraC=[SpectraC,Tempmz];
        end
        
        if ((charge==1)&&(once==false)&&(isempty(match)))  % By default set to smallest charge species, provided this smalleset size is <3000
            once=true;
            SpectraB(i)=Tempmz;
        end
    end
end
SpectraB=SpectraB';     % theoretical spectra used for XCorr
SpectraC=SpectraC';     % theoretical spectra used for Pvalue

if strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial')  % add a few more Mwts. for HCD 
    HCDglycans = [];
    if ~isempty(strfind(SmallGlyPep,'{s'))
        HCDglycans = [HCDglycans;274.09213;292.10269];
    end
    if ~isempty(strfind(SmallGlyPep,'{n'))
        HCDglycans = [HCDglycans;204.08665];
    end
    
    if ~isempty(strfind(SmallGlyPep,'{h'))
        HCDglycans = [HCDglycans;138.05496];
    end
    SpectraB=[SpectraB;HCDglycans];
    SpectraC=[SpectraC;HCDglycans];
end

%  Cross correlation function
%  SpectraB=[AllFragIons.mz]';
peak=max(SpectraA(:,2));
SpectraB(:,2)=0.1*peak;  % make theoretical spectra for comparison, both for SpectraB and SpectraC
SpectraC(:,2)=0.1*peak;
if size(SpectraB,1)<3    % no need to do XCorr
    peakLag  = -25;
    htCenter = 0;
    htAvg    = 0;
else
    [peakLag,htCenter,htAvg]=CrossCorr(SpectraA,SpectraB,maxlag);
end

% Collect data required to evaluate P-value
[found,search,percentIonMatch,Top10]=spectracmp(SpectraA,SpectraC,MS2tol,MS2tolUnit);

if ~exist('foundPeaks')
    foundPeaks = [];    % empty structure returned if no peaks were found
end

if(nargout==9) || (nargout==10)
    varargout{1}=peakLag;
    varargout{2}=htCenter;
    varargout{3}=htAvg;
    varargout{4}=found;
    varargout{5}=search;
    varargout{6}=percentIonMatch;
    varargout{7}=Top10;
    varargout{8}=foundPeaks;
    varargout{9}=TempIons;
end

if(nargout==10)
    percentbreakpoints = 0;
    if(~isempty(foundPeaks))
         if (strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial') )
             peplength  = length(regexp(SmallGlyPep, '[ARNDCQEGHILKMFPSTWYV]'));
             nummatched = 0;
             for i = 1 : length(foundPeaks)
                foundtypes{i} = foundPeaks(1,i).type;
             end
             foundtypes = unique(foundtypes);

             for i = 1 : peplength-1
                if(sum(strcmp(foundtypes,['z' int2str(i)]))~=0)
                   nummatched = nummatched+1;
                   continue
                end

                if(sum(strcmp(foundtypes,['z' int2str(i) '+1']))~=0)
                   nummatched = nummatched+1;
                   continue
                end

                if(sum(strcmp(foundtypes,['c' int2str(peplength-i)]))~=0)
                   nummatched = nummatched+1; 
                   continue
                end  

                if(sum(strcmp(foundtypes,['c' int2str(peplength-i) '-1']))~=0)
                   nummatched = nummatched+1; 
                   continue
                end  
             end

             percentbreakpoints = nummatched/(peplength-1)*100;
        end
    end
    
    varargout{10} = percentbreakpoints;
end

end