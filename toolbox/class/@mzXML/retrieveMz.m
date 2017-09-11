function [mz]= retrieveMz(obj,varargin)
% RETRIEVEMZ: Read MZ value from an mzXML object
%
%  Syntax:
%     mz = retrieveMz(mzXMLobj,'scannum',scannum)
%
%  Example:
%     mzXMLobj  = readmzXML('demofetuin_cidetd.mzXML');
%     mz = mzXMLobj.retrieveMz('scannum',3500);
%
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

mz =[];
if(nargin==1)
    numscan =  obj.mzxmljava.getScanCount;
    mz=zeros(numscan,1);
    for i = 1 :numscan
        if ~isempty(obj.mzxmljava.rap(i))
            mz(i)=double(obj.mzxmljava.rap(i).getPrecursorMz);
        end
    end
elseif(nargin==2)
    mz=double(obj.mzxmljava.rap(varargin{1}).getPrecursorMz);
elseif(nargin==3)
    if(strcmpi(varargin{1},'scannum'))
        numscan = obj.mzxmljava.getScanCount;
        if(varargin{2}<numscan && ...
                obj.mzxmljava.rap(varargin{2}).getNum==varargin{2})
            mz =double(obj.mzxmljava.rap(varargin{2}).getPrecursorMz);
            return
        else
            for i = 1 : numscan
                if(obj.mzxmljava.rap(i).getNum==varargin{2})
                    mz=double(obj.mzxmljava.rap(i).getPrecursorMz);
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