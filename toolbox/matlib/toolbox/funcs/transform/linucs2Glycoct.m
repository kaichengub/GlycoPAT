function linucs2Glycoct(linucsFileName, varargin)
%linucs2Glycoct read the sequence file of a glycan in the format of LINUCS and return a file in the format of GlycoCT .
% 
% linucs2Glycoct(INFILENAME,OUTFILENAME) reads a file name in the string
%  input argument INFILENAME using a LIINUCS format and outputs a GlycoCT
%  file named as OUTFILENAME
%
% linucs2Glycoct(INFILENAME) uses the default output file name
% <INFILENAME>.glycoct_xml.
%
% Example 1:
%  linucs2Glycoct('highmannose.linucs');
%
% Example 2:
%  linucs2Glycoct('highmannose.linucs','highmannose.glycoct_xml');  
%
% See also linucs2Glyde,linucs2Glycoctcond,glycoctcond2Glycoct,glycoctcond2Glyde,
% glycoctcond2Linucs,glycoct2Glyde,glycoct2Linucs,glycoct2Glycoctcond.

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
    %add glycoct_xml string
    glycoCTFileName = regexprep(linucsFileName,'.linucs','.glycoct_xml');
elseif(nargin==2)
    glycoCTFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoCTFileName)&&ischar(linucsFileName) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

% check file existance
linucsFileName=which(linucsFileName);
isFileExist = exist(linucsFileName,'file')==2;
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
       glyDoc.exportTo(glycoCTFileName,'glycoct');
end    


end



