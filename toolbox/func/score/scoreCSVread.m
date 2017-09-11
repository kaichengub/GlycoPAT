function [headerpar,msdatatype,headerstr,scoredata,varargout] = scoreCSVread(varargin)
%SCORECSVREAD: Read data from scoring result CSV file
%
% Syntax: 
%   [headerpar,msdatatype,headerstr,scoredata] = scoreCSVread(filefullname)
%   [headerpar,msdatatype,headerstr,scoredata] = scoreCSVread(fpath,fname)
%   [headerpar,msdatatype,headerstr,scoredata,scoretable] = scoreCSVread()
% 
% Input: 
%   filefullname: file full name including file path
%   fpath       : file directory
%   fname       : file name 
%
% Output: 
%   heardpar    : a MATLAB structure containing the properties used for
%     scoring. 
%   msdatatype  : mzXML or DTA file type     
%   headerstr   : header information for csv file
%   scoredata   : score data 
%    
% Example: 
%    [par,msdatatype,headerstr,scoredata]=scoreCSVread('score.csv');
%   
%See Also SCORECSVWRITE.

% Author: Gang Liu
% Date Lastly Updated: 8/4/14

if(nargin==1)
    fname = varargin{1};
elseif(nargin==2)
    fname = fullfile(varargin{1},varargin{2});
end

scoredata              = readtabulardata(fname);
[headerstr,headercell] = readheader(fname);
[headerpar,msdatatype] = readparfromheader(headercell);

if(nargout==5)
    scoretable = struct2table(scoredata);
    modetypes = unique(scoretable.fragMode);
    for i=1:length(modetypes)
        if(~isempty(strfind(upper(modetypes{i}),'CID')))        
            scoretable.fragMode=strrep(scoretable.fragMode,modetypes{i},'CID');
            modetypes{i}='CID';
        elseif(~isempty(strfind(upper(modetypes{i}),'ETD')))
            scoretable.fragMode=strrep(scoretable.fragMode,modetypes{i},'ETD');
            modetypes{i}='ETD';
        elseif(~isempty(strfind(upper(modetypes{i}),'HCD')))
            scoretable.fragMode=strrep(scoretable.fragMode,modetypes{i},'HCD');
            modetypes{i}='HCD';
        else
            error('MATLAB:GLYCOPAT:ERRORTYPEFRAGMODE','INCORRECT FRAGMENTATION MODE');
        end   
    end
    varargout{1} = scoretable;
end

end

function [headerpar,msdatatype] = readparfromheader(headercell)
CommaPos=regexp(headercell{2},',');    % 8th line has parameters for Polishing Spectra
headfield1 = headercell{2}(1:CommaPos(1)-1);
headfield1 = strtrim(headfield1);
if(isempty(strfind(headfield1,'XML File Name')))
    msdatatype = 'dta';
    if(length(CommaPos)>=2)
        headerpar.DataDirectory = headercell{2}(CommaPos(1)+1:CommaPos(2)-1);
    else
        headerpar.DataDirectory = headercell{2}(CommaPos(1)+1:end);
    end
else
    msdatatype = 'mzxml';
    if(length(CommaPos)>=2)
        headerpar.xmlfilename=headercell{2}(CommaPos(1)+1:CommaPos(2)-1);
    else
        headerpar.xmlfilename=headercell{2}(CommaPos(1)+1:end);
    end
end

if(length(CommaPos)>=2)
    headerpar.DataDirectory=headercell{2}(CommaPos(1)+1:CommaPos(2)-1);
else
    headerpar.DataDirectory=headercell{2}(CommaPos(1)+1:end);
end

CommaPos=regexp(headercell{3},',');   
if(length(CommaPos)>=2)
    headerpar.fragMod = headercell{3}(CommaPos(1)+1:CommaPos(2)-1);
else
    headerpar.fragMod = headercell{3}(CommaPos(1)+1:end);
end

CommaPos=regexp(headercell{5},',');    % parse for MS2 Tolerance
[MS2tolUnit,startUnit,endUnit]=regexp(upper(headercell{5}),'DA|PPM','match');    % parse for MS2 Tolerance
headerpar.MS2tolUnit = MS2tolUnit{:};
headerpar.MS2tol=str2num(headercell{5}(CommaPos(1)+1:startUnit-1));

CommaPos=regexp(headercell{6},',');    % parse for nmFrag, ngFrag, npFrag
if(length(CommaPos)>=4)
    a=str2num(headercell{6}(CommaPos(3)+1:CommaPos(4)-1));
else
    fragstr = double(headercell{6}(CommaPos(3)+1:end));
    if any(fragstr > 58)
        a = [0,0,0];
    else
        a=str2num(headercell{6}(CommaPos(3)+1:end));
    end
end
headerpar.nmFrag=a(1);
headerpar.ngFrag=a(2);
headerpar.npFrag=a(3);

CommaPos=regexp(headercell{7},',');    % 8th line has parameters for Polishing Spectra
if(length(CommaPos)>=2)
    headerpar.mxLag=str2num(headercell{7}(CommaPos(1)+1:CommaPos(2)-1));
else
    headerpar.mxLag=str2num(headercell{7}(CommaPos(1)+1:end));
end

CommaPos=regexp(headercell{8},',');    % 8th line has parameters for Polishing Spectra
headerpar.CutOffMed=str2num(headercell{8}(CommaPos(1)+1:CommaPos(2)-1));
if(length(CommaPos)>=3)
    headerpar.FracMax=str2num(headercell{8}(CommaPos(2)+1:CommaPos(3)-1));
else
    headerpar.FracMax=str2num(headercell{8}(CommaPos(2)+1:end));
end

CommaPos=regexp(headercell{9},',');    % 8th line has parameters for Polishing Spectra
headerpar.selectpeak = zeros(1,length(CommaPos)-1);
if(length(CommaPos)>=2)
    headerpar.selectpeak = str2num(headercell{9}(CommaPos(1)+1:CommaPos(2)-1));
else
    headerpar.selectpeak = str2num(headercell{9}(CommaPos(1)+1:end));
end
end

function [headerstr,headercell] = readheader(filename)
fid = fopen(filename);
headerstr = '';
for i = 1 : 9
   tline = fgetl(fid);
   linestr = sprintf('%s\n',tline);
   headerstr =[headerstr,linestr];
   headercell{i} = tline;
end
headerstr = regexprep(headerstr,',',' ');
fclose(fid);
end

function csvstruct = readtabulardata(fname)
fid = fopen(fname); % This is where output from matchPepList.m is stored in csv format file
datatable = textscan(fid, '%s %d %f %f %f %d %s %s %d %f %f %f %f %f %f %s %d %d %d %f %f %*[^\n]','Delimiter',...
    ',','HeaderLines',10);  % reads the data from the .csv format file

fieldnames = {'protein','scan','exptMass','monoMass','mostAbMass','charge','peptide','fragMode',...
              'peakLag','htCenter','htAvg','percentIonMatch','pValue','decoyRatio',...
              'top10','selectPeak','nmFrag','ngFrag','npFrag','enscore','decoyES'};
for i = 1 : length(fieldnames)
    csvstruct.(fieldnames{i}) = datatable{i};
end    

% ensure fragmode is either CID/HCD/ETD
for i = 1 : length(csvstruct.fragMode)
    if(~isempty(strfind(csvstruct.fragMode{i},'CID')))
        csvstruct.fragMode{i}='CID';
    elseif(~isempty(strfind(csvstruct.fragMode{i},'ETD')))    
        csvstruct.fragMode{i}='ETD';
    elseif(~isempty(strfind(csvstruct.fragMode{i},'HCD')))    
        csvstruct.fragMode{i}='HCD';
    end
end
fclose(fid);
end