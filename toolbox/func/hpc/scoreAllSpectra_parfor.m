function hit=scoreAllSpectra_parfor(varargin)
%SCOREALLSPECTRA_PARFOR: Score all MS2 spectra against glycopeptide library.
%
% Syntax:
%    hit = scoreAllSpectra_parfor(Pepfile,dtafilesDirectory,fragMod,MS1tol,MS1toUnit,...
%           MS2tol,MS2tolUnit,CSVOutputDir,CSVfilename,MaxLag,CutOffMed,FracMax,...
%           nmFrag,npFrag,ngFrag,selectPeak)
%
%    hit = scoreAllSpectra_parfor(Pepfile,dtafilesDirectory,fragMod,MS1tol,MS1toUnit,...
%           MS2tol,MS2tolUnit,CSVOutputDir,CSVfilename,MaxLag,CutOffMed,FracMax,...
%           nmFrag,npFrag,ngFrag,selectPeak,dispProgress)
%
%    hit = scoreAllSpectra_parfor(Pepfile,mzxmlfileDirectory,fragMod,MS1tol,MS1toUnit,...
%           MS2tol,MS2tolUnit,CSVOutputDir,CSVfilename,MaxLag,CutOffMed,FracMax,...
%           nmFrag,ngFrag,npFrag,selectPeak,dispProgress,mzxmlfilename)
%
% Input:
%    Pepfile: Theoretical peptide list generated by digestSGP.m
%    dtafilesDirectory: DTA file storage location
%    mzxmlfileDirectory: mzXML file storage location
%    fragMod: 'CID', 'HCD', 'ETD', 'CIDSpecial', 'HCDSpecial', 'ETDSpecial' or 'none'
%    MS1tol, MS1tolUnit: number and units either 'ppm' or 'Da'
%    MS2tol, MS2tolUnit: number and units either 'ppm' or 'Da'
%    CSVOutputDir, CSVfilename: Output directory and CSV file name
%    maxlag:    parameter used for Xcorr
%    CutOffMed, FractMax: Parameters used for PolishSpectra
%    nmFrag, ngFrag and npFrag: used in case of CID/HCD/ETDSpecial
%    selectPeak: glycan signature peaks or other peaks of interest
%    mzxmlfilename: mzXML file name
%
% Output: 
%    hit: score results
%    Output file with hits and scores tabulated
% 
% Example:
%   glycopatroot = 'c:\glycopat\'; % replace ��c:\glyocpat�� with glycopat installation directory 
%   pepfile= 'digestedfetuin_Nglycanonly.txt ';
%   xmlfilepath = fullfile(glycopatroot, 'toolbox', 'test', 'data', 'mzxml');
%   pepfilefullname = fullfile(xmlfilepath,pepfile);
%   mzxmlfilename = 'fetuin_test.mzXML';
%   fragMode = 'AUTO';
%   MS1tol = 10.000000;
%   MS1tolUnit = 'ppm';
%   MS2tol = 1.000000;
%   MS2tolUnit = 'Da';
%   OutputDir = xmlfilepath;
%   OutCSVname = 'testscore.csv';
%   maxlag = 50;
%   CutOffMed = 2.000000;
%   FracMax = 0.020000;
%   nmFrag = 0;
%   npFrag = 2;
%   ngFrag = 0;
%   selectPeak =[163.1,292.1,366,454.1,657.2];
%   calchit = scoreAllSpectra_parfor(pepfilefullname,xmlfilepath,fragMode,MS1tol,MS1tolUnit,MS2tol, ...
%     MS2tolUnit,OutputDir,OutCSVname,maxlag,CutOffMed,FracMax,nmFrag,npFrag,ngFrag, ...
%     selectPeak,false,mzxmlfilename);
%
% Children functions: GetData, score1File, glypepMW, struct2csv, isoDist
%
%See also scoreAllSpectra, scoreAllSpectra_spmd.

% Author: Gang Liu, Sriram Neelamegham.
% Date Lastly Updated: 8/3/14
% Note here that this PARFOR program is written based on the original scoreAllSpectra program  
% written by Dr. Sriram Neelamegham.

narginchk(16,18);
Pepfile=varargin{1};
DataDirectory=varargin{2};
fragMode=varargin{3};
MS1tol=varargin{4};
MS1tolUnit=varargin{5};
MS2tol=varargin{6};
if(~isnumeric(MS1tol)||~isnumeric(MS2tol))
    error('MATLAB:GlycoPAT:ERRORINPUT','MS1/2 TOLERANCE INPUT TYPE ERROR');
end
MS2tolUnit=varargin{7};
OutputDir=varargin{8};
Outfname=varargin{9};
maxlag=varargin{10};
CutOffMed=varargin{11};
FracMax=varargin{12};
nmFrag=varargin{13};
npFrag=varargin{14};
ngFrag=varargin{15};
selectPeak=varargin{16};
if(nargin>=17)
    dispprogress=varargin{17};
else
    dispprogress = false;
end
usemzxml = 0;
if(nargin==18)
    mzxmlfilename = varargin{18};
    usemzxml = 1;
end

%% read MS data from mzXML file or DTA fils
if(usemzxml)  % mzXML file support
    xmlfullfilename = fullfile(DataDirectory,mzxmlfilename);
    mzXMLobj        = mzXML(xmlfullfilename,0,'memsave');
    Scan = mzXMLobj.retrieveScanNum;
    z    = mzXMLobj.retrievezCharge;
    Mz   = mzXMLobj.retrieveMz;
    MH   = Mz.*z - (z-1)*1.007825032;
    numSpectra=length(Scan);
    Spectra = cell(numSpectra,1);
    for i = 1 : numSpectra
        Spectra{i}= mzXMLobj.retrieveMSSpectra(i);
    end
else % support for DTA file format
    files        = dir(DataDirectory);               % reads directory and puts it in a matlab structure
    filename     = {files(~[files.isdir]).name}'; % reads filename from structure and puts in cell, excluding directory elements
    tempfilename = [];
    for i=1:length(filename)
        [pathstr,name,ext] = fileparts(char(filename(i)));
        if regexp(ext,'dta')   % includes only files that contain the text 'dta'
            tempfilename=[tempfilename,filename(i)];
        end
    end
    filename   = tempfilename';
    filestring = char(filename);              % converts cell array to string array
    numSpectra = length(filename);
    for i = 1 : numSpectra
        ithFile    = filestring(i,:);
        dots       = strfind(ithFile,'.');
        Scan(i)    = str2double(ithFile(dots(1)+1:dots(2)-1));  % Reads all Scan numbers is a directory and places it in array Scan
        xfile      = fullfile(DataDirectory,filestring(i,:));
        [MH(i),z(i),Spectra{i}] = GetData(xfile);   % read MS data from DTA files
    end
end

nFrag       = [nmFrag,ngFrag,npFrag];
param       = [maxlag,CutOffMed,FracMax];
fullOutName = fullfile(OutputDir,Outfname);

% Read list of theoretically possible products
fileID = fopen(Pepfile);
if(fileID==-1)
    error('MATLAB:GlycoPAT:OPENFILEERROR','FILE DOES NOT EXIST');
end
pepData = textscan(fileID,'%s%*[^\n]');
fclose(fileID);
[nProtein,startPep,endPep,headerinfo]=ParsePeptideCell(pepData{1});

if(dispprogress)
    counttot = nProtein*numSpectra;
    count    = 0;
    h        = waitbar(0,'Please wait...');
end

% assign the parameter to csvheaderinfo.
csvheaderinfo.Pepfile = Pepfile;

if (~usemzxml)
    csvheaderinfo.DataDirectory = DataDirectory;
else
    csvheaderinfo.xmlfullfilename = xmlfullfilename;
end

csvheaderinfo.fragMode   = fragMode;
csvheaderinfo.MS1tol     = MS1tol;
csvheaderinfo.MS1tolUnit = MS1tolUnit;
csvheaderinfo.MS2tol     = MS2tol;
csvheaderinfo.MS2tolUnit = MS2tolUnit;
csvheaderinfo.nFrag      = nFrag;
csvheaderinfo.maxlag     = maxlag;
csvheaderinfo.CutOffMed  = CutOffMed;
csvheaderinfo.FracMax    = FracMax;
csvheaderinfo.selectPeak = selectPeak;

if(usemzxml)
    actmethod = getMSActMethod(mzXMLobj,fragMode,numSpectra);
else
    parfor i =1 : numSpectra
        actmethod{i} = fragMode;
    end
end

spectralengthfilter = 10;
PepNames     = {};
ProteinIDs = [];
for k = 1 : nProtein
    singlePepNames  =  pepData{1}(startPep(k):endPep(k));
    PepNames        =  [PepNames;singlePepNames];
    singleProtIDs = ones(length(singlePepNames),1)*k;
    ProteinIDs = [ProteinIDs;singleProtIDs];
end

disp('calculating isotopic mass');
PepMS1 = zeros(length(PepNames),1);
PepMost = zeros(length(PepNames),1);

parfor i = 1 : length(PepNames)
    % [PepMS1(i,1),PepMost(i,1),~]=glypepformula(char(PepNames(i)));
     PepMS1(i,1)=glypepMW(char(PepNames(i)));
end

hitCount=0;
hit=[];
for i = 1 : numSpectra
    if(dispprogress)
        count  =  count + 1;
        waitbar(count/counttot,h);
    end
    
    if(usemzxml==1)&&(mzXMLobj.mzxmljava.rap(i).getMsLevel~=2)
        continue;
    end
    
    if(length(Spectra{i})<=spectralengthfilter)
        continue;
    end
    
    if(strcmpi(actmethod{i},'pass'))
        continue;
    end
    
    % check if the spectra has fewer than 10 peaks
    SmallGlyPep =[];
    
    if (strcmpi(MS1tolUnit,'ppm'))
        mhMonoDiff = abs(PepMS1(:,1)+1.007825032-MH(i))<=MS1tol/1e6*MH(i);
        if any(mhMonoDiff)
            list=find(mhMonoDiff);
            SmallGlyPep=PepNames(list);   % find the peptide of interest, there may be more than one
            Mono=PepMS1(list);
            Most=PepMost(list);
        end
    elseif(strcmpi(MS1tolUnit,'Da'))
        mhMonoDiffDa = abs(PepMS1(:,1)+1.007825032-MH(i))<=MS1tol;
        if any(mhMonoDiffDa) % if tolerance is given in Da units
            list=find(mhMonoDiffDa);
            SmallGlyPep=PepNames(list);   % find the peptide of interest, there may be more than one
            Mono=PepMS1(list);
            Most=PepMost(list);
        end
    else
        error('MATLAB:GlycoPAT:ERRORUNIT','INCORRECT UNIT FOR MS1 TOL');
    end
    
    % display scan number and possible hits
    i
    fprintf(1,'scan number: %i\n',Scan(i));
    fprintf(1,'possible glycopeptide:\n');
    zA = z(i);
    ithspectra = Spectra{i};
    ithactmethod = actmethod{i};
    parfor j=1:length(SmallGlyPep)
        spectrascores(j) = score1Spectrum(ithspectra,SmallGlyPep(j),...
            ithactmethod,MS2tol,MS2tolUnit,param,nFrag,selectPeak,zA,1);
    end
    
    for j=1:length(SmallGlyPep)
        hitCount=hitCount+1;
        hit(hitCount).protein    = headerinfo{ProteinIDs(list(j))};
        hit(hitCount).Scan       = Scan(i);
        hit(hitCount).Expt       = MH(i)-1.0078246;
        hit(hitCount).Mono       = Mono(j);
        hit(hitCount).Most       = Most(j);
        hit(hitCount).charge     = zA;
        hit(hitCount).sgp        = SmallGlyPep{j};
        hit(hitCount).fragmode   = ithactmethod;
        hit(hitCount).peakLag    =  spectrascores(j).peakLag;
        hit(hitCount).htCenter   =  spectrascores(j).htCenter;
        hit(hitCount).htAvg      =  spectrascores(j).htAvg;
        hit(hitCount).percentIonMatch = spectrascores(j).percentIonMatch;
        hit(hitCount).Pvalue     = spectrascores(j).Pvalue;
        hit(hitCount).decoyRatio = spectrascores(j).decoyRatioP;
        hit(hitCount).Top10      = spectrascores(j).Top10;
        hit(hitCount).selectPeak = spectrascores(j).foundSelectPeak;
        hit(hitCount).nmFrag     = spectrascores(j).nFrag(1);
        hit(hitCount).ngFrag     = spectrascores(j).nFrag(2);
        hit(hitCount).npFrag     = spectrascores(j).nFrag(3);
        hit(hitCount).enscore    = spectrascores(j).enscore;
        hit(hitCount).fdrdecoyenscore  = spectrascores(j).fdrdecoyenscore;
    end
end

% convert select peak to string
for i = 1 : length(hit)
    peakstring='';
    for j=1:length(hit(i).selectPeak)
        peakstring=[peakstring,num2str(hit(i).selectPeak(j)),'*'];
    end
    hit(i).selectPeak = peakstring;
end

% output file using subfunctions
scoreCSVwrite(csvheaderinfo,hit,fullOutName);

if(dispprogress)
    close(h);
end

end

function actmethod = getMSActMethod(mzXMLobj,fragMode,numSpectra)

actmethod = cell(1,length(numSpectra));

for i = 1 : numSpectra
    % check if the spectra is the right spectra for the fragmentation
    % mode
    if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
        actmethod{i} = 'ETD';
    elseif(strcmpi(fragMode,'CID')||strcmpi(fragMode,'CIDSpecial'))
        actmethod{i} = 'CID' ;
    elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
        actmethod{i} = 'HCD';
    elseif(strcmpi(fragMode,'Auto'))
        actmethod{i} = 'Auto';
    else
        error('MATLAB:GlycoPAT:ERRORFRAGMENT','ERROR IN FRAGEMENTATION MODE');
    end
    
    if(strcmpi(actmethod{i},'auto'))
        actmetfromdata = mzXMLobj.retrieveActMethod(i);
        if(~isempty(strfind(upper(actmetfromdata),'ETD')))
            actmethod{i} ='ETD';
        elseif(~isempty(strfind(upper(actmetfromdata),'CID')))
            actmethod{i} ='CID';
        elseif(~isempty(strfind(upper(actmetfromdata),'HCD')))
            actmethod{i} ='HCD';
        else
            actmethod{i} ='pass';
        end
    elseif(~isempty(actmethod{i}))
        actmetfromdata = mzXMLobj.retrieveActMethod(i);
        if(isempty(strfind(upper(actmetfromdata),upper(actmethod{i}))))
            actmethod{i} ='pass';
        else
            actmethod{i} = fragMode;
        end
    else
        error('MATLAB:GlycoPAT:ERRORACTIVATION','ERROR IN ACTIVATION METHOD');
    end
end

end

