function glycanString = glycanStrwrite(glycanStructObj,varargin)
%glycanStrwrite write the sequence of a glycan to a string 
% 
% GLYCANSTRING = glycanStrwrite(GLYCANSTRUCTOBJ, GLYCANFORMAT) writes the 
%  sequence of a glycan to a string named as the string output argument 
%  GLYCANSTRING using a sequence format specified with the
%  input argument GLYCANFORMAT
%
% GLYCANSTRING = glycanStrwrite(GLYCANSTRUCTOBJ) uses Glycoct format as 
%  default.
%  
% Example 1:
%  load  man6_glycan.mat;
%  glycanString_glycoct=glycanStrwrite(m6_glycan);
%
% Example 2:
%  load  man6_glycan.mat;
%  glycanString_glycoct=glycanStrwrite(m6_glycan,'glycoct_xml');
%
% Example 3:
%  load  man6_glycan.mat;
%  glycanString_linucs=glycanStrwrite(m6_glycan,'linucs')
%  
% Example 4:
%  load  man6_glycan.mat;
%  glycanString_glyde=glycanStrwrite(m6_glycan,'glyde'); 
%
% See also glycanStrread, glycanMLread, glycanMLwrite,
%  glycanNetSBMLread,glycanNetSBMLwrite.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

import java.net.MalformedURLException;
import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% input number check
if(~verLessThan('matlab','7.13'))
    narginchk(1,2);
else
    error(nargchk(1,2,nargin));
end

if (nargin<2)
    glyFileFormat = 'glycoct_xml';
elseif(nargin<3)
    glyFileFormat  = varargin{1};
end

% input variable type check
if ~(isa(glycanStructObj,'GlycanStruct'))
    errorReport(mfilename,'IncorrectInputType');
end

% input variable type check
isCharArg = ischar(glyFileFormat) ;
if(~isCharArg)
     errorReport(mfilename,'NonStringInput');
end

% set up glycan document store
glycoDoc = GlycanDocument(BuilderWorkspace);
glycoDoc.addStructure(structMat2Java(glycanStructObj))

% export to string
if(glycoDoc.isEmpty())
  errorReport(mfilename,'IncorrectStucture');
end

try
    glycanString=glycoDoc.toString(glyFileFormat);
catch exception
    rethrow(exception);
    errorReport(mfilename,'FileWritingError');
end

glycanString = char(glycanString);
      
end

