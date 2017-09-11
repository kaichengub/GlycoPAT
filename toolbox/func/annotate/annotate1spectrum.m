function [foundPeaks]=annotate1spectrum(varargin)
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
%       foundPeaks = annotate1spectrum(mzxmlfilename,sgp,...
%          fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,save,...
%          ScanNumber,zz);
%
%    Example 2:
%       foundPeaks = annotate1spectrum(mzxmlfilename,sgp,...
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
    %     filename        = char(varargin{1});
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

if(ischar(varargin{1}))
    filename = varargin{1};
    [~,~,ext] = fileparts(filename);
    if ~isempty(ext)
        mode = 'mzxml';
        mzxmlfilename  = varargin{1};
        mzXMLobj = mzXML(mzxmlfilename,0,'memsave');
    else
        datfiledir = varargin{1};
        mode = 'dta';
    end
elseif(isa(varargin{1},'mzXML'))
    mzXMLobj = varargin{1};
    mode = 'mzxml';
else
    error('MATLAB:GlycoPAT:ERRORINPUT','INPUT TYPE ERROR');
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
        
        %% spectra filter (3 filter)
        % check if the spectra is MS2 data
        if(mzXMLobj.retrieveMSlevel('scannum',ScanNumber)~=2)
            error('MATLAB:GlycoPAT:NOTMSLEVEL2','THE SPECTRA IS NOT AN MS2 SPECTRUM')
        end
        [actmethod,fragMode]=setfragMode(fragMode,mzXMLobj,ScanNumber);  % This function sets the actmethod and fragMode depending on inputs
        
    case 'dta'
        filename = dir(datfiledir);               % reads directory and puts it in a matlab structure
        cat      = strcat('.',num2str(ScanNumber),'.',num2str(zz),'.dta');
        tempfname=[];
        ith=-1;
        for i=1:length(filename)                    % includes only files that contain the text 'dta'
            [pathstr,name,ext] = fileparts(char(filename(i).name));
            if regexp(ext,'dta')
                tempfname=[tempfname;cellstr(filename(i).name)];
                if ~isempty(findstr(filename(i).name,cat))
                    ith=i;
                end
            end
        end
        if(ith==-1)
            error('MATLAB:GlycoPAT:FILENOTFOUND','SPECIFIC SPECTRA IS NOT FOUND');
        end
        xfile=strcat(datfiledir,'\',filename(ith).name);
        [MH,z,Spectra]=GetData(char(xfile));
        Mz = ((MH-1.0078246)+z*1.0078246)/z;
        if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
            actmethod = 'ETD';
        elseif(strcmpi(fragMode,'CID')||strcmpi(fragMode,'CIDSpecial'))
            actmethod = 'CID' ;
        elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
            actmethod = 'HCD';
        else
            error('MATLAB:GlycoPAT:NOTSUPPORTEDFRAGMENTATION','THE FRAGMENTATION MODE IS NOT SUPPORTED');
        end
end


% check if the spectra has fewer than 10 peaks\
spectralengthfilter=10;
if(length(Spectra)<=spectralengthfilter)
    error('MATLAB:GlycoPAT:SPECTRALESSTHAN10PEAKS','THE SPECTRA HAS FEWER THAN 10 PEARKS');
end
[spectrascores,Spectra, TempIons] = score1Spectrum(Spectra,SmallGlyPep,fragMode,...
    MS2tol,MS2tolUnit,param,nFrag,selectPeak,zz,MH);   % Spectra is already polished in score1Spectrum and
% spectrascores.foundPeaks contains matched peaks
% TempIons is also returned from scoreProb via score1Spectrum



peakMatchIndex    = zeros(size(Spectra,1),1);
peakMatchIonIndex = cell(size(Spectra,1),1);
foundPeaks=spectrascores.foundPeaks;

% [~,ind] = sort([foundPeaks(:).mzExpt],'descend');
% foundPeaks = foundPeaks(ind);
for i=1:length(foundPeaks)
    peakMatchIndex(foundPeaks(i).peakIndex)=1;
end
peakMatchIndex=logical(peakMatchIndex);

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
