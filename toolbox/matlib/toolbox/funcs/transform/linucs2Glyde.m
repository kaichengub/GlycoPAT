function linucs2Glyde(linucsFileName, varargin)
%linucs2Glyde read the sequence file of a glycan in the format of LINUCS 
% and return a file in the format of GLYDE
%
% linucs2Glyde(INFILENAME,OUTFILENAME) reads a file name in the string
%  input argument INFILENAME using a LINUCS format and outputs a GLYDE
%  file named as OUTFILENAME
%
% linucs2Glyde(INFILENAME) uses the default output file name as 
%  <INFILENAME>.glyde_xml
%
% Example 1:
%  linucs2Glyde('highmannose.linucs');
%
% Example 2:
%  linucs2Glyde('highmannose.linucs','highmannose.glyde_xml');
%
% See also linucs2Glycoctcond,linucs2Glycoct,glycoctcond2Linucs,glycoct2Glyde,
% glycoctcond2Glycoct,glycoct2Linucs,glycoct2Glyde,glycoct2Glycoctcond.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.awt.BorderLayout;
import java.net.MalformedURLException;
import javax.swing.JScrollPane;
import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanCanvas;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% input check
if(~verLessThan('matlab','7.13'))
    narginchk(1,2);
else
    error(nargchk(1,2,nargin));
end

% handle input arguments
if(nargin==1)
    %add glyde string
    GlydeFileName = regexprep(linucsFileName,'.linucs','.glyde_xml');
elseif(nargin==2)
    GlydeFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar( linucsFileName)&&ischar(GlydeFileName) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInputs');
end

% check file existance
linucsFileName=which(linucsFileName);
isFileExist = exist(linucsFileName,'file');
if(~isFileExist)
    errorReport(mfilename,'FileNotFound'); 
end

% set up workspace
glyWorkSpace = BuilderWorkspace;
glyWorkSpace.setAutoSave(true);

%set up glycan document store
glyDoc = glyWorkSpace.getStructures();
try
    glyDoc.importFrom(linucsFileName,'linucs');
catch exception
    rethrow(exception);
    errorReport(mfilename,'GlycanFileImportError');
end

% export
if(glyDoc.isEmpty())
    errorReport(mfilename,'GlycanFileImportError');
else
    glyDoc.exportTo(GlydeFileName,'glyde');
end


end

