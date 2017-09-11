function glycoctcond2Glyde(glycoctCondFileName, varargin)
%glycoctcond2Glyde read the sequence file of a glycan in GlycoCT-condensed
% format and return a file in GLYDE format
% 
% glycoctcond2Glyde(INFILENAME,OUTFILENAME) reads a file name in the string
%  input argument INFILENAME using a  GlycoCT-condensed format and outputs a
%  GLYDE file named as OUTFILENAME
%
% glycoctcond2Glyde(INFILENAME)  uses the default output file name
%  <INFILENAME>.glyde_xml
%
% Example 1:
%  glycoctcond2Glyde('highmannose.glycoctcond');
%
% Example 2:
%  glycoctcond2Glyde('highmannose.glycoctcond','highmannose.glyde_xml');  
%
% See also glycoctcond2Linucs,glycoctcond2Glycoct,glycoct2Linucs,
% glycoct2Glycoctcond,glycoct2Glyde,linucs2Glyde,linucs2Glycoct,
% linucs2Glycoctcond.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.awt.BorderLayout;
import java.net.MalformedURLException;
import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanCanvas;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% input check
if(~verLessThan('matlab','7.13'))
    narginchk(1,2);
else
    error(nargchk(1,2,nargin));
end

% input number check
if (nargin == 1)
    glydeFileName = regexprep(glycoctCondFileName,'.glycoctcond','.glyde_xml','ignorecase');
elseif(nargin==2)
    glydeFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoctCondFileName)&&ischar(glydeFileName) ;
if(~isCharArg)
     errorReport(mfilename,'NonStringInput');
end

% check file existance
glycoctCondFileName=which(glycoctCondFileName);
isFileExist = (exist(glycoctCondFileName,'file')==2);
if(~isFileExist)  
    errorReport(mfilename,'FileNotFound');
end

% set up workspace
glyWorkSpace = BuilderWorkspace;
glyWorkSpace.setAutoSave(true);

%set up glycan document store
glyDoc = glyWorkSpace.getStructures();
try
    glyDoc.importFrom(glycoctCondFileName,'glycoct_condensed');
catch exception
    rethrow(exception);
    errorReport(mfilename,'GlycanFileImportError');
end

% export 
if(glyDoc.isEmpty())
      errorReport(mfilename,'GlycanFileImportError');
else
      glyDoc.exportTo(glydeFileName,'glyde');
end

end

