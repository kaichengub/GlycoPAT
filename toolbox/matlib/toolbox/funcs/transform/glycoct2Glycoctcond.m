function glycoct2Glycoctcond(glycoctFileName, varargin)
%glycoct2Glycoctcond read the sequence file of a glycan in GlycoCT format 
% and return a file in Glycoct-condensed format.
% 
% glycoct2Glycoctcond(INFILENAME,OUTFILENAME) reads a file name in 
%  the string input argument INFILENAME using a GlycoCT format and 
%  outputs a GlycoCT-condensed format file named as OUTFILENAME
%
% glycoct2Glycoctcond(INFILENAME) uses the default output file name
%  <INFILENAME>.glycoctCond
% 
%  Example 1:
%   glycoct2Glycoctcond('highmannose.glycoct_xml') 
%
%  Example 2:
%   glycoct2Glycoctcond('highmannose.glycoct_xml','highmannose.glycoctcond'); 
%
% See also glycoct2Glyde,glycoct2Linucs,glycoctcond2Glyde,glycoctcond2Linucs
%  glycoctcond2Glycoct,linucs2Glyde,linucs2Glycoct,linucs2Glycoctcond

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
    glycoctCondFileName = regexprep(glycoctFileName,'_glycoct','');
    glycoctCondFileName = regexprep(glycoctCondFileName,'glycoct_','');
    glycoctCondFileName = regexprep(glycoctCondFileName,'glycoct','');   
    %add glycoctCond file extension name
    glycoctCondFileName = regexprep(glycoctCondFileName,'.xml','.glycoctCond');
elseif(nargin==2)
    glycoctCondFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoctFileName)&&ischar(glycoctCondFileName) ;
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
glycoWorkSpace = BuilderWorkspace;
glycoWorkSpace.setAutoSave(true);

%set up glycan document store
glyDoc = glycoWorkSpace.getStructures();
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
       glyDoc.exportTo(glycoctCondFileName,'glycoct_condensed');
end

end

