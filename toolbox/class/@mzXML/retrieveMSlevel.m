function mslevel = retrieveMSlevel(obj,varargin)
% RetrieveMSlevel: Read MS level from an mzXML object
%   
% Syntax: 
%         mslevel = retrieveMSlevel(mzXMLObj,scanindex);
%         mslevel = retrieveMSlevel(mzXMLObj,'scannum',scannum);
%
% Example 1: mzXMLobj  = mzXML('demofetuin.mzXML',0,'memsave');
%            mslevel   = mzXMLobj.retrieveMSlevel(200);
%
% Example 2: mzXMLobj  = mzXML('demofetuin.mzXML',0,'memsave');
%            mslevel = mzXMLobj.retrieveMSlevel('scannum',11941);
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/03/15

mslevel = -1;

if(nargin==2)
    % read all scan data in mzXML format
    mslevel = double(obj.extmzxmljava.rap(varargin{1}).getMsLevel);
elseif(nargin==3)
    numscan   = obj.mzxmljava.getScanCount;
    if(strcmpi(varargin{1},'scannum')...
            && isnumeric(varargin{2}))   
       scannum = varargin{2};
       if(scannum<numscan &&obj.mzxmljava.rap(scannum).getNum==scannum)
           mslevel = double(obj.extmzxmljava.rap(scannum).getMsLevel);
           return
       end
       
       for i = 1 : numscan
         if(obj.mzxmljava.rap(i).getNum==scannum)
            mslevel =double(obj.extmzxmljava.rap(i).getMsLevel); 
            return
         end         
       end
       error('MATLAB:GlycoPAT:INCORRESCANNUM','SCAN NUMBER IS NOT FOUND IN MZXML');
    else
       error('MATLAB:GlycoPAT:INCORRECTINPUT','INCORRECT INPUT TYPE');
    end
else
    error('MATLAB:GlycoPAT:INCORRECTINPUT','INCORRECT INPUT TYPE');
end

end