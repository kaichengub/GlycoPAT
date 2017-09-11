function glycanMLwrite(glycoObj, glyFullFileName,varargin )
%glycanMLwrite write the sequence of a glycan to a file 
%
% glycanMLwrite(GLYCANOBJ,FILENAME,FILEFORMAT) writes the 
%  sequence of a glycan to a file named as the string input argument 
%  FILENAME using a sequence format specified with the
%  input argument FILEFORMAT
%
% glycanMLwrite(GLYCANOBJ,FILENAME) uses GlycoCT as default
%  file format
%  
% Example 1:
%  load man6_glycan.mat;
%  glycanMLwrite(m6_glycan,'m6_glycan.xml');
%
% Example 2:
%  load man6_glycan.mat;
%  glycanMLwrite(m6_glycan,'m6_glycan.glycoct_xml','glycoct_xml');  
%  
% Example 3:
%  load man6_glycan.mat;
%  glycanMLwrite(m6_glycan,'m6_glycan.linucs','linucs');
% 
% Example 4:
%  load man6_glycan.mat;
%  glycanMLwrite(m6_glycan,'m6_glycan.glyde_xml','glyde'); 
%
% See also glycanMLread,glycanNetSBMLread,glycanNetSBMLwrite,
%  glycanStrread,glycanStrwrite.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.net.MalformedURLException;
import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% input number check
if(~verLessThan('matlab','7.13'))
    narginchk(2,3);
else
    error(nargchk(2,3,nargin));
end

if (nargin<3)
    glyFileFormat = 'glycoct_xml';
elseif(nargin<4)
    glyFileFormat  = varargin{1};
end

% input variable type check
if ~(isa(glycoObj,'GlycanStruct'))
    errorReport(mfilename,'IncorrectInputType');
end

% input variable type check
isCharArg = ischar(glyFullFileName)&&ischar(glyFileFormat) ;
if(~isCharArg)
     errorReport(mfilename,'NonStringInput');
end

% set up glycan document store
glycoDoc = GlycanDocument(BuilderWorkspace);
glycoDoc.addStructure(structMat2Java(glycoObj))

% export to file
if(glycoDoc.isEmpty())
  errorReport(mfilename,'IncorrectStucture');
end

try
    glycoDoc.exportTo(glyFullFileName,glyFileFormat);
catch exception
    rethrow(exception);
    errorReport(mfilename,'FileWritingError');
end
      
end

