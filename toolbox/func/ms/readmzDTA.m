function mzDTA = readmzDTA(varargin)
%READMZDTA: Read mass spectrometry data from DTA file directory
%
% Syntax:
%     mzDTA = readmzDTA(dtafiledir);
%
% Input:
%    dtafiledir: the directory where the dta files are stored
%
% Output:
%    mzDTA : a MATLAB structure variable containing four fields: i) scan 
%     (scan number); ii) MH: M+H; iii) z (charge); iv) spectra
%     (spectra intensity list). 
%
% Example:
%
%   mzDTA = readmzDTA('C:\glycopat\toolbox\test\data\dta');
%
%
%See also readmzXML,peptideread,varptmread,fixedptmread.

% Author: Gang Liu and Sriram Neelamegham
% Date Lastly Updated: 01/08/15

narginchk(1,1);

dtafiledir = varargin{1};
if(~ischar(dtafiledir))
    error('MATLAB:GLYCOPAT:INPUTTYPEERROR','INCORRECT INPUT TYPE');
end

dtafiles         = dir(dtafiledir);               % reads directory and puts it in a matlab structure
dtafilenames     = {dtafiles(~[dtafiles.isdir]).name}'; % reads filename from structure and puts in cell, excluding directory elements
tempfilename     = [];

for i=1:length(dtafilenames)
    [pathstr,name,ext] = fileparts(char(dtafilenames(i)));
    if regexp(ext,'dta')   % includes only files that contain the text 'dta'
        tempfilename=[tempfilename,dtafilenames(i)];
    end
end

dtafilenames   = tempfilename';
filestring     = char(dtafilenames);              % converts cell array to string array
numMS2Spectra  = length(dtafilenames);
Scan           = zeros(numMS2Spectra,1);
MH             = zeros(numMS2Spectra,1);
z              = zeros(numMS2Spectra,1);
Spectra        = cell(numMS2Spectra,1);

for i = 1 : numMS2Spectra
    ithFile    = filestring(i,:);
    dots       = strfind(ithFile,'.');
    Scan(i)    = str2double(ithFile(dots(1)+1:dots(2)-1));  % Reads all Scan numbers is a directory and places it in array Scan
    xfile      = fullfile(dtafiledir,filestring(i,:));
    [MH(i),z(i),Spectra{i}] = GetData(xfile);   % read MS data from DTA files
end

mzDTA.scan    = Scan;
mzDTA.MH      = MH;
mzDTA.z       = z;
mzDTA.spectra = Spectra;

end