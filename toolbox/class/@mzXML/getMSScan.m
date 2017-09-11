function msdata = getMSScan(obj,varargin)
% GETMSScan: Read MS Scan Data from an mzXML object
%
% Syntax: 
%       scandata = mzXMLobj.getMSScan(scanindex)
%       scandata = mzXMLobj.getMSScan('mslevel',mslevel)
%       scandata = mzXMLobj.getMSScan('scannum',scannum)
%
% Example 1: mzXMLobj = mzXML('demofetuin.mzXML');
%            scandata = mzXMLobj.getMSScan(1);
%
% Example 2: mzXMLobj = mzXML('demofetuin.mzxml');
%            scandata = mzXMLobj.getMSScan('mslevel',1);
%
% Example 3: mzXMLobj = mzXML('demofetuin.mzxml');
%            scandata = mzXMLobj.getMSScan('scannum',11924);
% 
% Please Note: To apply "getMSScan" method, use "mzXML(mzxmlfilename)" to 
%  create mzXML object.
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

narginchk(2,3);

msdata = [];
if(nargin==2)
    % read all scan data in mzXML format
    msdata    = obj.scandata{varargin{1}};
elseif(nargin==3)
    numscan   = obj.mzxmljava.getScanCount;
    if(strcmpi(varargin{1},'mslevel')...
            && isnumeric(varargin{2}))
       mslevel = varargin{2};
       count=0;
       for i = 1 : numscan
         if(obj.scandata{i}.msLevel==mslevel)
            count = count +1;
            msdata{count} = obj.scandata{i}; 
         end
       end
    elseif(strcmp(varargin{1},'scannum')...
            && isnumeric(varargin{2}))   
       scannum = varargin{2};
       count=0;
       for i = 1 : numscan
         if(obj.scandata{i}.scannum==scannum)
            count = count +1;
            msdata{count} = obj.scandata{i}; 
         end
       end
    else
       msdata = [];
       return;
    end
end

% if(length(msdata)==1)
%     msdata=msdata{:};
% end
end