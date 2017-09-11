function glycanMat = glycanMLread(glyFileName,varargin)
%glycanMLread read the sequence file of a glycan and return an 
% GlycanStruct object 
%
% GLYCANSTRUCTOBJ = glycanMLread(FILENAME,FILEFORMAT) reads a file named 
%  as the string input argument FILENAME using a sequence format specified 
%  with the input argument FILEFORMAT. It returns an object of GlycanStruct 
%  class,GLYCANSTRUCTOBJ. Note GLYDE format is not supported yet.
%
% GLYCANSTRUCTOBJ = glycanMLread(FILENAME) reads a file in GlycoCT format.
%
% Example 1:
%  m6_glycan = glycanMLread('highmannose.glycoct_xml');
%
% Example 2:
%  m6_glycan = glycanMLread('highmannose.glycoct_xml','glycoct_xml');  
%   
% Example 3: 
%  m6_glycan = glycanMLread('highmannose.linucs','linucs')
%  
%
% See also glycanMLwrite,glycanNetSBMLread,glycanNetSBMLwrite,glycanStrread, 
% glycanStrwrite.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.net.MalformedURLException;
import org.eurocarbdb.application.glycanbuilder.*;

% input number check
% if(~verLessThan('matlab','7.13'))
%     narginchk(1,2);
% else
    error(nargchk(1,2,nargin));
% end

if(nargin==1)
    glycoFileFormat = 'glycoct_xml';
elseif(nargin==2)
    glycoFileFormat  = varargin{1};
end

% input variable type check
isCharArg = ischar(glyFileName)&&ischar(glycoFileFormat) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

% check file existance
isFileExist = exist(glyFileName,'file');
if(~isFileExist)  
     errorReport(mfilename,'FileNotFound');
end
glyFullFileName = which(glyFileName);

% set up glycan document store
workspace = org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
glyDoc       = org.eurocarbdb.application.glycanbuilder.GlycanDocument(workspace);

% glyWorkSpace.getStructures();
try
    glyDoc.importFrom(glyFullFileName,glycoFileFormat);
catch exception
    rethrow(exception);
    errorReport(mfilename,'IncorrectStucture');
end

glycanFromFile = glyDoc.getFirstStructure;
if ~isempty(glycanFromFile)
    glycanMat = GlycanStruct(glycanFromFile);
else
    errorReport(mfilename,'IncorrectStucture');
end

end

