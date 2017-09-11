function glycoct2Linucs(glycoctFileName, varargin)
%glycoct2Linucs read the sequence file of a glycan in the format of GlycoCT
% and return a file in the format of LINUCS.
% 
% glycoct2Linucs(INFILENAME,OUTFILENAME) reads a file name in the string
%  input argument INFILENAME using a GlycoCT format and outputs a LINUCS
%  file named as OUTFILENAME
%
% glycoct2Linucs(INFILENAME) uses the default output file name
%  <INFILENAME>.linucs
% 
% Example 1:
%  glycoct2Linucs('highmannose.glycoct_xml') 
%
% Example 2:
%  glycoct2Linucs('highmannose.glycoct_xml','highmannose.linucs'); 
%
% See also glycoct2Glyde,glycoct2Glycoctcond,glycoctcond2Linucs,
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

% input number check
if (nargin==1)
     % remove glycoct if exist
    LinucsFileName = regexprep(glycoctFileName,'glycoct_','');
    LinucsFileName = regexprep(LinucsFileName,'_glycoct','');
    LinucsFileName = regexprep(LinucsFileName,'glycoct','');
    
    %add linucs label
    LinucsFileName = regexprep(LinucsFileName,'.xml','.linucs');
elseif(nargin==2)
    LinucsFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoctFileName)&&ischar(LinucsFileName) ;
if(~isCharArg)
     errorReport(mfilename,'NonStringInput');
end

% check file existance
glycoctFileName=which(glycoctFileName);
isFileExist = exist(glycoctFileName,'file');
if(isFileExist~=2)  
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
       glyDoc.exportTo(LinucsFileName,'linucs');
end

end

