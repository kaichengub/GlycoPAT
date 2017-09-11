function linucs2Glycoctcond(linucsFileName, varargin)
%linucs2Glycoctcond read the sequence file of a glycan in the format 
% of LINUCS and return a file in the format of GlycoCT-condensed format.
%
% linucs2Glycoctcond(INFILENAME,OUTFILENAME) reads a file name in the 
%  string input argument INFILENAME using a LINUCS format and outputs 
%  a file named as OUTFILENAME in GlycoCT-condensed format. 
%
% linucs2Glycoctcond(INFILENAME) sets the default output file name
%  <INFILENAME>.glycoctcond
%
% Example 1:
%  linucs2Glycoctcond('highmannose.linucs');
%
% Example 2:
%  linucs2Glycoctcond('highmannose.linucs','highmannose.glycoctcond');  
%
% See also linucs2Glyde,linucs2Glycoct,glycoctcond2Linucs,glycoctcond2Glyde,
% glycoctcond2Glycoct,glycoct2Linucs,glycoct2Glyde,glycoct2Glycoctcond

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.awt.BorderLayout;
import java.net.MalformedURLException;

import javax.swing.JFrame;
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
    %add glycoctcond string
    glycoCTCONDFileName = regexprep(linucsFileName,'.linucs','.glycoctcond');
elseif(nargin==2)
    glycoCTCONDFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoCTCONDFileName)&&ischar(linucsFileName) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput'); 
    % error('GlycoToolbox:linucs2GlycoCT:NonStringInputs','non string input');
end

% check file existance
linucsFileName=which(linucsFileName);
isFileExist = (exist(linucsFileName,'file')==2);
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
      glyDoc.exportTo(glycoCTCONDFileName,'glycoct_condensed');
end    


end



