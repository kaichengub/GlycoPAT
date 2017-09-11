function scan= retrieveScanNum(obj,varargin)
%retrieveScanNum: Read scan number from an mzXML object
%
% Syntax:
%           scannumlist = mzXMLobj.retrieveScanNum
%           scannum = mzXMLobj.retrieveScanNum(scanindex)
%
%  Examples:
%    Exmaple 1:
%             mzXMLobj = readmzXML('demofetuin.mzXML');
%             scannumlist = mzXMLobj.retrieveScanNum;
%    Example 2:
%             mzXMLobj = mzXML('demofetuin.mzXML',0,'memsave');
%             scannum = mzXMLobj.retrieveScanNum(50);
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

scan =[];
if(nargin==1)
    numscan =  obj.mzxmljava.getScanCount;
    scan=zeros(numscan,1);
    for i = 1 :numscan
        if(~isempty(obj.mzxmljava.rap(i)))
            scan(i)=double(obj.mzxmljava.rap(i).getNum);
        end
    end
elseif(nargin==2)
    scan=double(obj.mzxmljava.rap(varargin{1}).getNum);
else
    error('MATLAB:GlycoPAT:INCORRECTINPUT','INCORRECT INPUT TYPE');
end

end