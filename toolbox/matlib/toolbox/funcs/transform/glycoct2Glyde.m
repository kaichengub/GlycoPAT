function glycoct2Glyde(glycoctFileName, varargin)
%glycoct2Glyde read the sequence file of a glycan in GlycoCT format and 
% return a file in GLYDE format.
% 
% glycoct2Glyde(INFILENAME,OUTFILENAME) reads a file name in the string
%  input argument FILENAME using a GlycoCT format and outputs a GLYDE
%  file named as OUTFILENAME
%
% glycoct2Glyde(INFILENAME) uses the default output file name 
%  <INFILENAME>.glyde_xml
%
% Example 1:
%  glycoct2Glyde('highmannose.glycoct_xml');
%
% Example 2:
%  glycoct2Glyde('highmannose.glycoct_xml','highmannose.glyde_xml');  
%
% See also glycoct2Linucs,glycoct2Glycoctcond,glycoctcond2Linucs,
%  glycoctcond2Glycoct,glycoctcond2Glyde,linucs2Glyde,linucs2Glycoct,
%  linucs2Glycoctcond.

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

% handle input arguments
if(nargin==1)
    % remove glycoct if exist
    glydeFileName = regexprep(glycoctFileName,'_glycoct','');
    glydeFileName = regexprep(glydeFileName,'glycoct_','');
    glydeFileName = regexprep(glydeFileName,'glycoct','');
    %add glyde string
    glydeFileName = regexprep(glydeFileName,'.xml','.glyde_xml');
elseif(nargin==2)
    glydeFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoctFileName)&&ischar(glydeFileName) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

% check file existance
glycoctFileName=which(glycoctFileName);
isFileExist = exist(glycoctFileName,'file');
if(~isFileExist)  
    errorReport(mfilename,'FileNotFound');
end    

% set up workspace
glyWorkSpace = BuilderWorkspace;
glyWorkSpace.setAutoSave(true);

%set up glycan document store
glyDoc = glyWorkSpace.getStructures();
try
    glyDoc.importFrom(glycoctFileName,'glycoct_xml');
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

