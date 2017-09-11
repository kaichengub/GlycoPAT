function zcharge= retrievezCharge(obj,varargin)
%RETRIEVEZCHARGE: Retrieve precursor charge state from an mzXML object
%
%  Syntax:
%       zCharge = retrievezCharge(mzXML,scanindex)
%       zCharge = retrievezCharge(mzXML,'scannum',scanindex)
%
%  Example:
%    Exmaple 1:
%             mzXMLobj = readmzXML('demofetuin.mzXML');
%             zcharge = mzXMLobj.retrievezCharge(50);
%    Example 2:
%             mzXMLobj = readmzXML('demofetuin.mzXML');
%             zcharge = mzXMLobj.retrievezCharge('scannum',11949);
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

zcharge =[];
if(nargin==1)
    numscan =  obj.mzxmljava.getScanCount;
    zcharge=zeros(numscan,1);
    for i = 1 :numscan
        if(~isempty(obj.mzxmljava.rap(i)))
            zcharge(i)=double(obj.mzxmljava.rap(i).getPrecursorCharge);
        end
    end
elseif(nargin==2)
    zcharge=double(obj.mzxmljava.rap(varargin{1}).getPrecursorCharge);
elseif(nargin==3)
    if(strcmpi(varargin{1},'scannum')&&isnumeric(varargin{2}))
        numscan = obj.mzxmljava.getScanCount;
        if(varargin{2}<numscan && ...
                obj.mzxmljava.rap(varargin{2}).getNum==varargin{2})
            zcharge =double(obj.mzxmljava.rap(varargin{2}).getPrecursorCharge);
            return
        else
            for i = 1 : numscan
                if(obj.mzxmljava.rap(i).getNum==varargin{2})
                    zcharge=double(obj.mzxmljava.rap(i).getPrecursorCharge);
                    return
                end
            end
        end
    else
        error('MATLAB:GlycoPAT:ERRORINPUT','WRONG INPUT');
    end
else
    error('MATLAB:GlycoPAT:ERRORINPUT','WRONG INPUT');
end