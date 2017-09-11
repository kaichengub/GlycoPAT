function [foundPeaks]=annotate1spectramzxml(varargin)
%ANNOTATE1SPECTRAMZXML: Annotate the spectra stored in mzXML format 
%
% Syntax: 
%   foundPeaks = annotate1spectramzxml(mzxmlfilename,SmallGlyPep,...
%     fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,save,...
%     ScanNumber,zz);
%
%   foundPeaks = annotate1spectramzxml(mzxmlfilename,SmallGlyPep,...
%     fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,save,...
%     ScanNumber,zz,outputcsvfilename);
%
% Input:
%   mzxmlfilename: mzXML file name
%   SmallGlyPep: glycopeptide in SmallGlyPep format
%   fragMode: fragmentation mode
%   MS2tol, MS2tolUnit: MS2 tolerance and unit
%   param: 3*1 vector, including maxlag,CutOffMed,FracMax 
%   nFrag: 3*1 vector, including npFrag,nmFrag,ngFrag
%   selectPeak: signature ion mass
%   save: if "foundPeak" is saved as a local file
%   ScanNumber: the scan number of spectra
%   zz: charge state
%   outputcsvfilename: csv file containing found peaks
%
% Output: 
%   foundPeaks: peaks found matching to theoretical fragment ion mass.
%
% Example:
%    Example 1:  
%       mzxmlfilename = 'fetuin_test.mzXML';
%       sgp='HTFSGVASVESSSGEAFHVGK';
%       fragMode='CID';
%       MS2tol=1;
%       MS2tolUnit='da';
%       param=[50,2,0.02];
%       nFrag=[0,0,2];
%       selectPeak='';
%       save=0;
%       ScanNumber=3416;
%       zz=4;
%       foundPeaks = annotate1spectramzxml(mzxmlfilename,sgp,...
%          fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,save,...
%          ScanNumber,zz);
% 
%    Example 2:
%       foundPeaks = annotate1spectramzxml(mzxmlfilename,sgp,...
%          fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,save,...
%          ScanNumber,zz,'testannotation.csv');
%       
%    
%  
%See also annotate1spectradta.

% Author: Gang Liu,Sriram Neelamegham
% Date Lastly Updated: 8/12/14 by Gang Liu

narginchk(11,12);
if (nargin==11) || (nargin==12)    
    if(ischar(varargin{1}))
       mzxmlfilename  = varargin{1};
       mzXMLobj = mzXML(mzxmlfilename,0,'memsave');
    elseif(isa(varargin{1},'mzXML'))
       mzXMLobj = varargin{1}; 
    else
       error('MATLAB:GlycoPAT:ERRORINPUT','INPUT TYPE ERROR');
    end
    
    SmallGlyPep    = char(varargin{2});
    fragMode       = varargin{3};
    MS2tol         = varargin{4};
    MS2tolUnit     = varargin{5};
    param          = varargin{6};
    maxlag         = param(1);           % parameter for XCorr
    CutOffMed      = param(2);        % paramters to clean Spectra
    FracMax        = param(3);
    nFrag          = varargin{7};
    nmFrag         = varargin{7}(1);
    ngFrag         = varargin{7}(2);
    npFrag         = varargin{7}(3);
    selectPeak     = varargin{8};
    save           = varargin{9};
    ScanNumber     = varargin{10};
    zz             = varargin{11};
  if(nargin==12)
     fullfilename  = varargin{12};
  end
end

if(save) 
    if(nargin==12)
        fid  = fopen(fullfilename,'w');
        if(fid==-1)
            error('MATLAB:GlycoPAT:ERROROPENFILE','ERROR IN OPENING THE FILE');
        end
    else
        save = false;
    end
end


                
 % check if the spectra has fewer than 10 peaks\
 spectralengthfilter=10;
 if(length(Spectra)<=spectralengthfilter)
     error('MATLAB:GlycoPAT:SPECTRALESSTHAN10PEAKS','THE SPECTRA HAS FEWER THAN 10 PEARKS');
 end
 switch mode
     case 'mzxml'
         Spectra = mzXMLobj.retrieveMSSpectra('scannum',ScanNumber);
Mz      = mzXMLobj.retrieveMz('scannum',ScanNumber);
zz_XML   = mzXMLobj.retrievezCharge('scannum',ScanNumber);
if(zz_XML~=zz)
   error('MATLAB:GlycoPAT:WRONGZCHARGE','ERROR IN PRECURSOR CHARGE'); 
end
MH      = Mz.*zz - (zz-1)*1.007825032;  

% xfile=strcat(mzxmlfilename,'\',filename(ith).name);
% [MH,z,Spectra]=GetData(char(xfile));

               
 %% spectra filter (3 filter)
 % check if the spectra is MS2 data
 if(mzXMLobj.retrieveMSlevel('scannum',ScanNumber)~=2)
     error('MATLAB:GlycoPAT:NOTMSLEVEL2','THE SPECTRA IS NOT AN MS2 SPECTRUM')
 end
         [actmethod,fragMode]=setfragMode(fragMode,mzXMLobj,ScanNumber);  % This function sets the actmethod and fragMode depending on inputs
     case 'dta'
         
         
end
[spectrascores,Spectra, TempIons] = score1Spectrum(Spectra,SmallGlyPep,fragMode,...
     MS2tol,MS2tolUnit,param,nFrag,selectPeak,zz,MH);   % Spectra is already polished in score1Spectrum and
                                                        % spectrascores.foundPeaks contains matched peaks
                                            % TempIons is also returned from scoreProb via score1Spectrum
                                                    
% TheoMW        = glypepMW(SmallGlyPep,'full',1);         % Theoretical MW
% errortheoexpt = abs(MH-1.007825032-TheoMW)*1e6/TheoMW;% difference in ppm
% fragparam = getFragParam(SmallGlyPep,fragMode,nmFrag,ngFrag,npFrag);
% nmFrag=fragparam.nmFrag;
% npFrag=fragparam.npFrag;
% ngFrag=fragparam.ngFrag;

% if strcmpi(actmethod,'Auto')||strcmpi(actmethod,'CID/HCD')
%     spectrascores = score1Spectrum(Spectra,SmallGlyPep,actmethod,...
%     MS2tol,MS2tolUnit,param,nFrag,selectPeak,zz,MH);
% else 

% end

%Spectra = deleteIsoPeaks(Spectra,MS2tol,MS2tolUnit);
% TempIons      = multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,1);        % calculate parameters for charge =1
% 
% if strcmpi(actmethod,'CID') ||strcmpi(actmethod,'HCD')
% %   ...|| strcmpi(actmethod,'CIDSpecial') || strcmpi(actmethod,'HCDSpecial')    % get rid of all c and z ions if this is CID mode
%     for i = length(TempIons):-1:1
%         if (~isempty(regexp(TempIons(i).type,'[cz]','once')))
%             TempIons(i)=[];
%         end
%     end
% end
% 
% ETDYION = 0;
% if strcmp(actmethod,'ETD') % || strcmpi(actmethod,'ETDSpecial')                                  % get rid of all b and y ions if this is ETD mode
%     if(ETDYION)  % y ion in ETD mode considered
%         for i=length(TempIons):-1:1
%             if (~isempty(regexp(TempIons(i).type,'[b]','once')))
%                 TempIons(i)=[];
%             end
%         end
%     else
%         for i = length(TempIons):-1:1
%             if(~isempty(regexp(TempIons(i).type,'[by]','once')))
%                 TempIons(i)=[];
%             end
%         end
%     end    
% end
% 
% if(strcmpi(actmethod,'ETD'))
%      Spectra = removePrecursorIon(Spectra,MH,z,MS2tol,MS2tolUnit);
%      Spectra = PolishSpectraLocal(Spectra,100,1);   % by default spannum=100 and CutOffMed=1 for ETD polishing
% else
%      Spectra = PolishSpectra(Spectra, CutOffMed, FracMax); % This program removes noise  
% end 
% Spectra = deleteIsoPeaks(Spectra,MS2tol,MS2tolUnit);


peakMatchIndex    = zeros(size(Spectra,1),1);
peakMatchIonIndex = cell(size(Spectra,1),1);
foundPeaks=spectrascores.foundPeaks;

% fcount=1;
% SpectraC=[];
% for i=1:length(TempIons)
%     for charge=1:zz
%         Tempmz=(TempIons(i).mz+(charge-1)*1.0078246)/charge;
%        if strcmpi(MS2tolUnit,'Da')
%             ionCompSpectra=abs(Spectra(:,1)-Tempmz)<=MS2tol;  % assuming this is in units of Da
%         elseif(strcmpi(MS2tolUnit,'ppm')) % MS2tolUnit=ppm
%             ionCompSpectra=abs(Spectra(:,1)-Tempmz)<=MS2tol/1e6*Tempmz;
%         else
%             error('MATLAB:GlycoPAT:ERRORUNIT','WRONG UNIT FOR MS TOLERANCE');
%         end
%         
%         peakMatchIndex = peakMatchIndex|ionCompSpectra;
%         match = find(ionCompSpectra);
%         
%         if ~isempty(match)
%             for k=1:length(match)
%                 foundPeaks(fcount).original=TempIons(i).original;  % information on what peaks were identified
%                 foundPeaks(fcount).sgp=TempIons(i).sgp;  % information on what peaks were identified
%                 foundPeaks(fcount).nmFrag=TempIons(i).nmFrag;  % information on what peaks were identified
%                 foundPeaks(fcount).npFrag=TempIons(i).npFrag;  % information on what peaks were identified
%                 foundPeaks(fcount).ngFrag=TempIons(i).ngFrag;  % information on what peaks were identified
%                 foundPeaks(fcount).type=TempIons(i).type;  % information on what peaks were identified
%                 foundPeaks(fcount).charge=TempIons(i).charge;  % information on what peaks were identified
%                 foundPeaks(fcount).mzTheo=Tempmz;
%                 foundPeaks(fcount).mzExpt=Spectra(match(k),1);
%                 foundPeaks(fcount).ppmError=(Spectra(match(k),1)-Tempmz)/Tempmz*1e6;
%                 foundPeaks(fcount).DaError=(Spectra(match(k),1)-Tempmz);
%                 foundPeaks(fcount).Intensity=Spectra(match(k),2);
%                 foundPeaks(fcount).charge=charge;
%                 foundPeaks(fcount).peakIndex = match(k);
%                 foundPeaks(fcount).iontype = TempIons(i).newtype;
%                 fcount=fcount+1;
%             end
%         end
%     end
% end
%
% 
for i=1:length(foundPeaks)
    peakMatchIndex(foundPeaks(i).peakIndex)=1;
end
%

for i = 1 : length(peakMatchIonIndex)
   peakMatchIonIndex{i} =[];
   for j = 1 : length(foundPeaks)
     if(foundPeaks(j).peakIndex==i)
       peakMatchIonIndex{i}=[peakMatchIonIndex{i,1};j]; % number of peaks * 1, cell
     end
   end
end

ionFragmentMatrix =comptFragIonMatrix(SmallGlyPep,TempIons,foundPeaks);
spectraAnnotation(ScanNumber,Spectra,peakMatchIndex,peakMatchIonIndex,...
    foundPeaks,SmallGlyPep,zz,Mz,ionFragmentMatrix,spectrascores,fragMode,MS2tol,MS2tolUnit);

if(save)
    if(~isempty(foundPeaks))
        struct2csv(foundPeaks,fid);
        fclose(fid);
    end
end

end


function ionFragPeakMatrix = comptFragIonMatrix(sgp,fragmentIons,foundPeaks)
[~,glyMat,~]= breakGlyPep(sgp);
numMonoinSGP=0;
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
    if(~isempty(regexp(fragmentIons(i).type,'c','once')))
        fragIonCluster.cIons=[fragIonCluster.cIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'z','once')))
        fragIonCluster.zIons=[fragIonCluster.zIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'b[^0-9]','once')))
        fragIonCluster.bglycoIons=[fragIonCluster.bglycoIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'b[0-9]','once')))
        fragIonCluster.bIons=[fragIonCluster.bIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'y[^0-9]','once')))
        fragIonCluster.yglycoIons=[fragIonCluster.yglycoIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'y[0-9]','once')))
        fragIonCluster.yIons=[fragIonCluster.yIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'none','once')))
        fragIonCluster.fullIons=[fragIonCluster.fullIons fragmentIons(i)];
    end
end

% for b-y ions
ionFragPeakMatrix = struct('cIons',[],'zIons',[],'bglycoIons',[],...
    'yglycoIons',[],'bIons',[],'yIons',[],'fullIons',[]);
ionfragnames = fieldnames(ionFragPeakMatrix);
for i = 1 : length(ionfragnames)
    iontype = ionfragnames{i};
    for j = 1 : length(fragIonCluster.(iontype))
        ionFragPeakMatrix.(iontype){j,1} = fragIonCluster.(iontype)(j).newtype;
        ionFragPeakMatrix.(iontype){j,2} = 0;
        for k = 1 : length(foundPeaks)
            if(strcmp(fragIonCluster.(iontype)(j).sgp,foundPeaks(k).sgp))
                ionFragPeakMatrix.(iontype){j,2} = 1;
                continue;
            end
        end
    end
end
end
