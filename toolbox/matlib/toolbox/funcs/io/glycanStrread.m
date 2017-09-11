function glycanMat = glycanStrread(glycanString, varargin)
%glycanStrread read the sequence string of a glycan and return an object of
% GlycanStruct class.  
% 
% GLYCANMAT = glycanStrread(GLYCANSTRING, FILEFORMAT) reads a string 
%  in the string input argument GLYCANSTRING using a  sequence format
%  specified with the input argument FILEFORMAT. The function returns
%  an object of GLYCANSTRUCT class.
%
% GLYCANMAT = glycanStrread(GLYCANSTRING) uses GlycoCT as default
%  file format.
%
% Example 1:
%  load  man6_glycan.mat;
%  m6_glycan = glycanStrread(m6glycanString_glycoct);
%
% Example 2:
%  load  man6_glycan.mat;
%  m6_glycan = glycanStrread(m6glycanString_glycoct,'glycoct_xml'); 
% 
% Example 3:
%  load  man6_glycan.mat;
%  m6_glycan = glycanStrread(m6glycanString_linucs,'linucs'); 
%     
% See also glycanStrwrite,glycanMLread, glycanMLwrite,
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
    glycanFileFormat = 'glycoct_xml';
elseif(nargin<3)
    glycanFileFormat  = varargin{1};
end

% input variable type check
isCharArg = ischar(glycanString)&&ischar(glycanFileFormat) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

glycanMat =  GlycanStruct(strtrim(glycanString),glycanFileFormat);

end

