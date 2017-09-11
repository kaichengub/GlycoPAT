function [retTime,retUnit] = retrieveMS1RetT(obj,scannum)
% RetrieveMS1RetT: Read retention time from an mzXML object
%  
% Syntax: 
%        [retTime,retUnit] = mzXMLObj.retrieveMS1RetT(scannum)
%        [retTime,retUnit] = retrieveMS1RetT(mzXMLObj,scannum)
%
% Example 1: mzXMLobj  = mzXML('demofetuin.mzXML',0,'memsave');
%            [retime,retunit] = mzXMLobj.retrieveMS1RetT(11941);
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/03/15
    retTime   = -1;
    numscan   = obj.mzxmljava.getScanCount;
    ms1scannum = -1;
    for i = 1 : numscan
        if(obj.mzxmljava.rap(i).getNum==scannum)
           if(obj.mzxmljava.rap(i).getMsLevel==1)    
                retentionTime = char(obj.mzxmljava.rap(i).getRetentionTime);
                retention     = regexp(retentionTime,'(?<ret>\d+\.\d+)(?<unit>[a-z_A-Z]+)','names');
                if(~isempty(retention))
                     retTime = str2double(retention.ret);
                     retUnit = retention.unit;    
                else
                     retTime = -1;
                     retUnit = '';
                end
            return
           elseif(obj.mzxmljava.rap(i).getMsLevel==2)  
               ms1scannum = char(obj.mzxmljava.rap(i).getPrecursorScanNum);
               break
           end
        end
    end
    
    if(ms1scannum==-1)
        error('MATLAB:GlycoPAT:ERRORSCANNUM','MS SCAN NOT FOUND');
    end
       
    for i = 1 : numscan
       if(obj.mzxmljava.rap(i).getNum==ms1scannum)
           retentionTime = char(obj.mzxmljava.rap(i).getRetentionTime);
           retention     = regexp(retentionTime,'(?<ret>\d+\.\d+)(?<unit>[a-z_A-Z]+)','names');
           if(~isempty(retention))
                 retTime = str2double(retention.ret);
                 retUnit = retention.unit;    
           else
                 retTime = -1;
                 retUnit = '';
           end
           return;
       end
    end
end