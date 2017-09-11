function actmethod = retrieveActMethod(obj,varargin)
%RETRIEVEACTMETHOD: Read MS activation method from an mzXML object
%  
% Syntax:
%   actmethod = retrieveActMethod(mzXMLObj,ithscan)
%   actmethod = retrieveActMethod(mzXMLObj,'scannum',scannum) 
%  
% Example: 
%   
%   Example 1:
%     mzXMLobj  = readmzXML('demofetuin_cidetd.mzXML');
%     actmethod = mzXMLobj.retrieveActMethod(34);
%     disp(actmethod)
%     Answer: 
%       'ETD+SA'
%
%  Example 2:  
%     mzXMLobj  = readmzXML('demofetuin_cidetd.mzXML');
%     actmethod = mzXMLobj.retrieveActMethod('scannum',3500);
%   
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated:08/05/15

actmethod = [];
if(nargin==2)
    actmethod = char(obj.extmzxmljava.rap(varargin{1}).getActivationMethod);
elseif(nargin==3)
    if(strcmpi(varargin{1},'scannum')...
            && isnumeric(varargin{2}))
      numscan   = obj.mzxmljava.getScanCount;   
     if(varargin{2}<numscan && obj.extmzxmljava.rap(varargin{2}).getNum==varargin{2})
       actmethod = char(obj.extmzxmljava.rap(varargin{2}).getActivationMethod);
       return
     else      
       for i = 1 : numscan
         if(obj.extmzxmljava.rap(i).getNum==varargin{2})
            actmethod =char(obj.extmzxmljava.rap(i).getActivationMethod);
            return
         end
       end
      end       
    else
       error('MATLAB:GLYCOPAT:INCORRECTINPUT','INCORRECT INPUT TYPE');
    end
end

end