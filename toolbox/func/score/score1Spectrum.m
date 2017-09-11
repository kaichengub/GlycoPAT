function [spectrascores,SpectraA, TempIons]=score1Spectrum(varargin)
%SCORE1SPECTRUM: Calculate various scoring parameters for comparing MS Data
% file and candidate theoretical SmallGlyPep.
%
% Syntax:
%   spectrascores = score1Spectrum(xfile,SmallGlyPep,fragMod,MS2tol,MS2tolUnit,...
%    param,nFrag,SelectPeak)
%   spectrascores = score1Spectrum(SpectraA,SmallGlyPep,fragMod,MS2tol,MS2tolUnit,...
%    param,nFrag,SelectPeak,z)
%
% Input format 1 (8 inputs):
% 1. xfile: Input MS data file name
% 2. SmallGlyPep: the candidate glycopeptide
% 3. fragMod: 'CID', 'HCD', 'ETD', 'CIDSpecial', 'HCDSpecial', 'ETDSpecial' or 'none'
% 4. MS2tol: MS2tol number
% 5. MS2tolUnit: either 'ppm' or 'Da'
% 6. param: array with three parameters: a. maxlag (used for Xcorr, typically 50),
% b. SpectraCutOff (used for PolishSpectra, typically 3) and FracMax (typically 0.02)
% 7. nFrag [nmFrag,ngFrag,npFrag]: In case of 'CIDSpecial', 'HCDSpecial' or
% 'ETDSpecial', the % program ignores defacult CID/HCD/ETD fragmentation rules
% and instead follows the user-specified nFrag rules.
% 8. SelectPeak: array of select glycan signature peaks to look for, e.g.
% [163.1,204.1,292.1]
%
% Input format 2 (9 inputs)
%  1. SpectraA, mass spectra peak intensity
%  9: z, charge state
%  others are the same
%
% Output: spectrascores is a structure containing 9 fields:
% 1-3. peakLag, htCenter, htAvg: Normalized cross-correlation scores
% 4. percent Ion match: % of search peaks idetified in Spectra
% 5. Pvalue: Poisson distribution based P value
% 6. decoy Ratio: Hit rate of actual peptide versus decoy peptides
% 7. Top10 peaks: Number of high intenity peaks that were matched
% 8. nFrag setting used
% 9. foundSelectPeak: Glycan signature peaks identified
%
% Children Function: GetData, PolishSpectra, SignatureGlycan, scoreProb, swapAacid
%
%See also scoreAllSpectra.

%Author: Sriram Neelamegham, Chi Lo, Gang Liu
%Date Lastly Updated: 12/11/16 by Sriram Neelamegham

calcfdr=1;
if(nargin==8)
    xfile=varargin{1};
    [MH,z,SpectraA]=GetData(xfile);      % This is experimental M+H written in .dta file at (1,1)
    SmallGlyPep=char(varargin{2});
    fragMode=varargin{3};
    MS2tol=varargin{4};
    MS2tolUnit=varargin{5};
    param=varargin{6};
    maxlag=param(1);           % parameter for XCorr
    CutOffMed=param(2);        % parameters to clean Spectra
    FracMax=param(3);
    nmFrag=varargin{7}(1);
    ngFrag=varargin{7}(2);
    npFrag=varargin{7}(3);
    selectPeak=varargin{8};
elseif(nargin==9||nargin==10||nargin==11)
    SpectraA = varargin{1};
    SmallGlyPep=char(varargin{2});
    fragMode=varargin{3};
    MS2tol=varargin{4};
    MS2tolUnit=varargin{5};
    param=varargin{6};
    maxlag=param(1);           % parameter for XCorr
    CutOffMed=param(2);        % paramters to clean Spectra
    FracMax=param(3);
    % nFrag=varargin{7};
    nmFrag=varargin{7}(1);
    ngFrag=varargin{7}(2);
    npFrag=varargin{7}(3);
    selectPeak=varargin{8};
    z = varargin{9};
    if(nargin==10)||(nargin==11)
        MH = varargin{10};
        
        if(nargin==11)
            ac=varargin{11};
        end
    end
end
% SmallGlyPepOriginal=SmallGlyPep;
%[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);

nDecoy=25;                      % number of random decoy peptides generated
[nmFrag,ngFrag,npFrag,SmallGlyPep]=getnFrag(fragMode,SmallGlyPep,nmFrag,ngFrag,npFrag);  % sets fragmentation parameters
nFrag=[nmFrag,ngFrag,npFrag];

% Load expt. spectra and clean it up
if(strcmpi(fragMode,'ETD'))||(strcmpi(fragMode,'ETDSpecial'))
    SpectraA = removePrecursorIon(SpectraA,MH,z,MS2tol,MS2tolUnit);
    SpectraA = PolishSpectraLocal(SpectraA,100,1);   % by default spannum=100 and CutOffMed=1 for ETD polishing
else
    SpectraA = PolishSpectra(SpectraA, CutOffMed, FracMax); % This program removes noise
end
SpectraA=deleteIsoPeaks(SpectraA,MS2tol,MS2tolUnit);

foundSelectPeak=SignatureGlycan(SpectraA,selectPeak,MS2tol,MS2tolUnit);  % identify signature glycan peaks

% Don't do calculations is expt spectrum does not have enough peaks
if(size(SpectraA,1)<5)
    spectrascores.peakLag  = -25;
    spectrascores.htCenter = 0;
    spectrascores.htAvg    = 0;
    spectrascores.Pvalue   = 0.99;
    spectrascores.percentIonMatch = 0;
    spectrascores.decoyRatioP = 0.99;
    spectrascores.Top10 = 0;
    spectrascores.foundPeaks=[];
    spectrascores.foundSelectPeak=foundSelectPeak;
    spectrascores.nFrag = nFrag;
    spectrascores.enscore = 0;
    spectrascores.fdrdecoyenscore =-1;
    return
end

add=0;
ETDYION=0;
[peakLag,htCenter,htAvg,K1,N1,percentIonMatch,Top10,foundPeaks,TempIons,fracbreakpoints]...                  % Fracbreakpoint used in ETD mode only
    = scoreProb(SpectraA,z,SmallGlyPep,MS2tol,MS2tolUnit,fragMode,add,nFrag,maxlag,ETDYION);        %N1: Total number, K1: matched number

if(calcfdr)                                                                                         % This part of code is not used
    fdrsgp = fdrdecoy(SmallGlyPep,'random');
    [peakLag_fdrdecoy,htCenter_fdrdecoy,htAvg_fdrdecoy,K1_fdrdecoy,N1_fdrdecoy,...
        percentIonMatch_fdrdecoy,Top10_fdrdecoy,foundPeaks_fdrdecoy,TempIons_fdrdecoy,...
        fracbreakpoints_fdrdecoy]...
        = scoreProb(SpectraA,z,fdrsgp,MS2tol,MS2tolUnit,fragMode,add,nFrag,maxlag,ETDYION);        %N1: Total number, K1: matched number
end

N=N1;
K=K1;

MaxDecoyPercentIonMatch=0;
decoyArray=[];

decoylibrary = cell(nDecoy,1);
usenewdecoy = 1;
for j = 1 : nDecoy
    if(usenewdecoy)
        decoySGP = fdrdecoy(SmallGlyPep,'random');
        add = 0;
    else
        decoySGP = swapAacid(SmallGlyPep,'random');
        minadd=5;                                 % for decoys add a random wt. between 5 ad 20 to create decoys
        maxadd=20;
        add = minadd + (maxadd-minadd).*rand(1);  % used MATLAB uniform pseudorandom number generator
    end
    
    [dpeakLag, dhtCenter, dhtAvg, Ktemp, Ntemp, dpercentIonMatch,dTop10, dfoundPeaks,dTempIons]...
        = scoreProb(SpectraA,z,decoySGP,MS2tol,MS2tolUnit,fragMode,add,nFrag,maxlag,0); %N1: Total number, K1: matched number
    K = K + Ktemp;
    N = N + Ntemp;
    decoyArray = [decoyArray,dpercentIonMatch];
    if (dpercentIonMatch>MaxDecoyPercentIonMatch)
        MaxDecoyPercentIonMatch = dpercentIonMatch;
    end
    decoylibrary{j}=decoySGP;
end

p               = K/N;
pnorm           = (K-K1)/(N-N1);
XPvalue         = (N1*p)^(K1)*exp(-N1*p)/factorial(K1);
%Pvalue         = poisspdf(K1,N1*pnorm);
Pvalue          = 1-poisscdf(K1,N1*pnorm);
% probscore     = 1-binocdf(K1,N1,pnorm);

if K1==0          % if there is no hit then Pvalue has no meaning
    Pvalue = 1;
end

decoyRatio      = percentIonMatch/MaxDecoyPercentIonMatch; % %ionmatch for actual sample vs. maximum %ionmatch for decoy
[H,decoyRatioP] = ttest2(percentIonMatch,decoyArray);
% Pvalue = decoyRatio;

if(calcfdr)                                                 % unused part since calcfdr=0
    pnorm            = (K-K1)/(N-N1);
    XPvalue          = (N1*p)^(K1)*exp(-N1*p)/factorial(K1);
    %Pvalue         = poisspdf(K1,N1*pnorm);
    Pvalue_fdrdecoy  = 1-poisscdf(K1_fdrdecoy,N1_fdrdecoy*pnorm);
    % probscore     = 1-binocdf(K1,N1,pnorm);
    [H,decoyRatioP]  = ttest2(percentIonMatch_fdrdecoy,decoyArray);
    
    if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
        spectrascores.fdrdecoyenscore = compETDenscore(peakLag_fdrdecoy,htCenter_fdrdecoy,...
            Pvalue_fdrdecoy,Top10_fdrdecoy,percentIonMatch_fdrdecoy,K1);
    elseif(strcmpi(fragMode,'CID') || strcmpi(fragMode,'CIDSpecial'))
        spectrascores.fdrdecoyenscore = compCIDenscore(peakLag_fdrdecoy,htCenter_fdrdecoy,...
            Pvalue_fdrdecoy,Top10_fdrdecoy,percentIonMatch_fdrdecoy);
    elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
        spectrascores.fdrdecoyenscore = compHCDenscore(peakLag_fdrdecoy,htCenter_fdrdecoy,...
            Pvalue_fdrdecoy,Top10_fdrdecoy,percentIonMatch_fdrdecoy);
    end
else
    spectrascores.fdrdecoyenscore  = -1;
end


%% Ensemble score
if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
    enscore = compETDenscore(peakLag,htCenter,Pvalue,Top10,fracbreakpoints,K1);
elseif(strcmpi(fragMode,'CID') || strcmpi(fragMode,'CIDSpecial'))
    enscore = compCIDenscore(peakLag,htCenter,Pvalue,Top10,percentIonMatch);
elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
    enscore = compHCDenscore(peakLag,htCenter,Pvalue,Top10,percentIonMatch);
end

spectrascores.htCenter=htCenter;
spectrascores.htAvg = htAvg;
spectrascores.peakLag=peakLag;
spectrascores.Pvalue = Pvalue;
if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
    spectrascores.percentIonMatch = fracbreakpoints;
else
    spectrascores.percentIonMatch = percentIonMatch;
end
spectrascores.decoyRatioP = decoyRatioP;
spectrascores.Top10 = Top10;
spectrascores.foundPeaks=foundPeaks;
spectrascores.nFrag = nFrag;
spectrascores.foundSelectPeak = foundSelectPeak;
spectrascores.enscore = enscore;
end

function [nmFrag,ngFrag,npFrag,newSmallGlyPep]=getnFrag(fragMode,SmallGlyPep,nmFrag,ngFrag,npFrag)
%
% Function sets the default fragmentation parameters in each mode
% Also SmallGlyPep is truncated in the case of HCD mode based on stubLen
% If fragmentation mode is 'Auto' this is handled before scrore1Spectrum
%
[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);
newSmallGlyPep=SmallGlyPep;
if  strcmpi(fragMode,'CID')
    nmFrag=0;
    ngFrag=0;
    npFrag=0;
    if (~isempty(pepMat))
        npFrag=1;               % CID typically fragments peptide if it is peptide alone
    end
    if (~isempty(modMat))  % (exception: it can also fragment modification especially in the case of sulfation and phosphorylation)
        % addition of modificaiton type check
        nmFrag=0;
    end
    if (~isempty(glyMat))   % it prefers to fragment glycan instead of peptide if it is a glycopeptide
        glyNumber=0;
        for m=1:length(glyMat)
            glyNumber=glyNumber+glyMat(m).len;
        end
        if ((glyNumber<4)&&(~isempty(pepMat)))  % if number of monosaccharides <4 then we fragment on peptide backbone also once
            ngFrag=2;
            npFrag=1;
        else
            ngFrag=2;
            npFrag=0;
        end
    end
elseif  strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial')
    if (~isempty(glyMat))
        for i = 1:length(glyMat)
            if length(glyMat(i).struct)==3
                stubLen=1;
            else
                stubLen=2;                          % stubLen=2 (default)
            end
            glyMat(i).struct=makeStub(glyMat(i).struct,stubLen);
        end
        newSmallGlyPep=joinGlyPep(pepMat,glyMat,modMat);
        if  strcmpi(fragMode,'HCD')
            ngFrag=2;               % Default HCD allows ngFrag=2
        end
       if strcmpi(fragMode,'HCDSpecial') && (ngFrag>stubLen)
            ngFrag=stubLen;    
       end
    else
        ngFrag=0;                   % no glycan
    end
    
    if (~isempty(pepMat))
        if  strcmpi(fragMode,'HCD')
            npFrag=1;               % If HCDSpecial, then don't adjust npFrag
        end
    else
        npFrag=0;                   % no peptide
    end
    
    if (~isempty(modMat))
        if  strcmpi(fragMode,'HCD')
            nmFrag=0;               % If HCDSpecial, don't change used defined nmFrag
        end
    else
        nmFrag=0;                   % no mod
    end
elseif strcmpi(fragMode,'ETD')
    ngFrag=0;
    nmFrag=0;
    npFrag=1;               % ETD prefers the peptide; If ETDspecial, don't change anything
elseif strcmpi(fragMode,'none')
    nmFrag=0;
    ngFrag=0;
    npFrag=0;
elseif strcmpi(fragMode,'CIDSpecial')
    fragMode='CIDSpecial';
elseif strcmpi(fragMode,'ETDSpecial')
    fragMode='ETDSpecial';
elseif strcmpi(fragMode,'HCDSpecial')
    fragMode='HCDSpecial';
else
    error('MATLAB:GlycoPAT:FRAGMODEERROR','FRAG MODE IS NOT CURRENTLY SUPPORTED');
end
end

function enscore=compCIDenscore(peakLag,htCenter,Pvalue,Top10,percentageIonMatch)
%
% calculate Ensemble Score for CID mode
%
if(abs(peakLag)<=1)
    if htCenter > 0.65
        norm_xcorr=1;
    else
        norm_xcorr=(htCenter/0.65);
    end
else
    norm_xcorr=0;
end

pvaluethreshold=1e-5;
if((Pvalue-0.02)>0)
    pscore=0;
elseif(Pvalue<pvaluethreshold)
    pscore=1;
else
    kslope = 1/(log(pvaluethreshold)-log(0.02));
    pscore = 1+kslope*(log(Pvalue)-log(pvaluethreshold));
end

if(percentageIonMatch>80)
    perIonmatch=1;
else
    perIonmatch=percentageIonMatch/80;
end

top10scoreweight = 0.25; pscoreweight=0.25;
perIonmatchweight = 0.25; xcorrweight = 0.25;
enscore = Top10/10*top10scoreweight + pscore*pscoreweight + ...
    perIonmatch*perIonmatchweight + norm_xcorr*xcorrweight;
if(isnan(enscore))
    enscore =0;
end

end
function enscore=compHCDenscore(peakLag,htCenter,Pvalue,Top10,percentageIonMatch)
%
% calculate Ensemble Score for HCD mode
%
if(abs(peakLag)<=1)
    if htCenter > 0.65
        norm_xcorr=1;
    else
        norm_xcorr=(htCenter/0.65);
    end
else
    norm_xcorr=0;
end

pvaluethreshold=1e-5;
if((Pvalue-0.02)>0)
    pscore=0;
elseif(Pvalue<pvaluethreshold)
    pscore=1;
else
    kslope = 1/(log(pvaluethreshold)-log(0.02));
    pscore = 1+kslope*(log(Pvalue)-log(pvaluethreshold));
end

if(percentageIonMatch>80)
    perIonmatch=1;
else
    perIonmatch=percentageIonMatch/80;
end

top10scoreweight = 0.0; pscoreweight=1/3;
perIonmatchweight = 1/3; xcorrweight = 1/3;
enscore = Top10/10*top10scoreweight + pscore*pscoreweight + ...
    perIonmatch*perIonmatchweight + norm_xcorr*xcorrweight;
if(isnan(enscore))
    enscore =0;
end

end

function enscore=compETDenscore(peakLag,htCenter,Pvalue,Top10,percentIonMatch,nummatchedpeaks)
%
% calculate Ensemble Score for ETD mode
%

htcenternorm = 0.50;
if(abs(peakLag)<=1)
    if htCenter > htcenternorm
        norm_xcorr = 1;
    else
        norm_xcorr = (htCenter/htcenternorm);
    end
else
    norm_xcorr = 0;
end

pvaluethreshold=1e-5;
pvalueupper = 0.1;
if((Pvalue - pvalueupper)>0)
    pscore = 0;
elseif(Pvalue==0)
    pscore = 0;
elseif(Pvalue<pvaluethreshold)
    pscore = 1;
else
    kslope = 1/(log(pvaluethreshold)-log(pvalueupper));
    pscore = 1+kslope*(log(Pvalue)-log(pvaluethreshold));
end

if(percentIonMatch>50)
    perIonmatch=1;
else
    perIonmatch=percentIonMatch/50;
end

top10scoreweight  = 0.10; pscoreweight = 0.70;
perIonmatchweight = 0;    xcorrweight  = 0.20;

enscore = Top10/10*top10scoreweight + pscore*pscoreweight + ...
    perIonmatch*perIonmatchweight + norm_xcorr*xcorrweight;

if(isnan(enscore))
    enscore =0;
end

penalitypara = 0.02;
penalityscore = 0;
if(nummatchedpeaks<=10)
    penalityscore = -penalitypara*(abs(nummatchedpeaks-10))^2;
end
usepenality=0;
if(usepenality)
    enscore = enscore + penalityscore;
end

if(enscore<0)
    enscore = 0;
end

end