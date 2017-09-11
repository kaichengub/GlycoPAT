function mzXMLobj = readmzXML(varargin)
%READMZXML: Read mass spectrometry data from an mzxML file 
%
% Syntax: 
%     mzxmlobj = readmzXML(mzxmlfilefullname);
%     mzxmlobj = readmzXML(mzxmlfiledir, mzxmlfilename);
%   
% Input: 
%    mzxmlfilefullname: the full name for an mzXML file including its path 
%    mzxmlfiledir: the name of the file directory
%    filename: the name of an mzXML file 
%   (Note: if the file "demofetuin.mzxml" is stored in the folder
%      'c:/glycopat/toolbox/test/demo'
%      the "mzxmlfilefullname" is 'demofetuin.mzxml'
%      the  "mzxmlfiledir" is 'c:/glycopat/toolbox/test/demo'
%      the  "filename " is 'demofetuin.mzxml')
%    
% Output:
%   mzxmlobj: an object of mzXML class.
%   
% Examples:
%
%   Example 1. % replace the absolute path if necessary
%     mzxmlobj = readmzXML('c:/glycopat/toolbox/test/demo','demofetuin.mzXML');
%
%   Example 2. % replace the absolute path if necessary
%     mzxmlobj = readmzXML('c:/glycopat/toolbox/test/demo/demofetuin.mzXML');
%  
%   Example 3. 
%     mzxmlobj = readmzXML('demofetuin.mzXML') 
%    Note: The program will search for "demofetuin.mzXML" in the current 
%    path.If not found,it will look for the file in MATLAB search path.  
%
%See also readmzDTA,peptideread,varptmread,fixedptmread. 

% Author: Gang Liu
% Date Lastly Updated: 08/08/14

narginchk(1,2);

if(nargin==1)
     mzxmlfilename  = varargin{1};  
elseif(nargin==2)
     filepath = varargin{1};
     filename = varargin{2}; 
     mzxmlfilename = fullfile(filepath,filename);
end

fid = fopen(mzxmlfilename);
if(fid==-1) % if file not found
    mzxmlfilename = which(mzxmlfilename);
    if(isempty(mzxmlfilename))
        error('MATLAB:GlycoPAT:FILENOTFOUND','file is not found in the search path');
    end
end
fclose(fid);

import org.systemsbiology.jrap.*;
mzXMLobj = mzXML(mzxmlfilename,0,'memsave');

end