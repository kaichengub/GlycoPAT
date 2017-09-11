function glycoctcond2Linucs(glycoctCondFileName, varargin)
%glycoctcond2Linucs read the sequence file of a glycan in GlycoCT-condensed 
% format and return a file in LINUCS format.
%  
% glycoctcond2Linucs(INFILENAME,OUTFILENAME) reads a file name in the string
%  input argument INFILENAME using a GlycoCT-condensed format and output a LINUCS
%  file named as OUTFILENAME
%
% glycoctcond2Linucs(INFILENAME) uses the default output file name
%  <INFILENAME>.linucs. 
%
% Example 1:
%  glycoctcond2Linucs('highmannose.glycoctcond');
%
% Example 2:
%  glycoctcond2Linucs('highmannose.glycoctcond','highmannose.linucs');
%
% See also glycoctcond2Glycoct,glycoctcond2Glyde,glycoct2Glyde,glycoct2Linucs
% glycoct2Glycoctcond,linucs2Glyde,linucs2Glycoct,linucs2Glycoctcond.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.awt.BorderLayout;
import java.net.MalformedURLException;
import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanCanvas;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

%input check
if(~verLessThan('matlab','7.13'))
    narginchk(1,2);
else
    error(nargchk(1,2,nargin));
end

% input number check
if (nargin==1)
    % change glycoctCond to linucs
    LinucsFileName = regexprep(glycoctCondFileName,'.glycoctcond','.linucs', 'ignorecase');    
elseif(nargin==2)
    LinucsFileName  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycoctCondFileName)&&ischar(LinucsFileName) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

% check file existance
glycoctCondFileName = which(glycoctCondFileName);
isFileExist = (exist(glycoctCondFileName,'file')==2);
if(~isFileExist)
    errorReport(mfilename,'FileNotFound');
end

% set up workspace
glycanWorkSpace = BuilderWorkspace;
glycanWorkSpace.setAutoSave(true);

%set up glycan document store
glycanDoc = glycanWorkSpace.getStructures();
try
    glycanDoc.importFrom(glycoctCondFileName,'glycoct_condensed');
catch exception
    rethrow(exception);
    errorReport(mfilename,'GlycanFileImportError');
end

% export
if(glycanDoc.isEmpty())
    errorReport(mfilename,'GlycanFileImportError');
else
    glycanDoc.exportTo(LinucsFileName,'linucs');
end

end

