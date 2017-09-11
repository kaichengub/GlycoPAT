function spectraummary = retrieveSpectraSummary(mzxmlobj)
% RETRIEVESPECTRASUMMARY: Retrieve spectra summary from an mzXML object
%  
% Syntax: 
%    spectraummary =  retrieveSpectraSummary(mzXMLObj); 
% 
% Example: 
%      mzXMLobj  = readmzXML('demofetuin.mzXML');
%      summary   = retrieveSpectraSummary(mzXMLobj);
%
% See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

spectraummary.numscan    = mzxmlobj.mzxmljava.getScanCount;
spectraummary.numscanms1 =  0;
spectraummary.numscanms2 =  0;
spectraummary.numetdms2  =  0;
spectraummary.numcidms2  =  0;
spectraummary.numhcdms2  =  0;

for i = 1 : spectraummary.numscan
    if(~isempty(mzxmlobj.mzxmljava.rap(i)))
        if(mzxmlobj.mzxmljava.rap(i).getMsLevel==1)
            spectraummary.numscanms1 = spectraummary.numscanms1 + 1;
        elseif(mzxmlobj.mzxmljava.rap(i).getMsLevel==2)
            spectraummary.numscanms2 = spectraummary.numscanms2+1;
            actmethod          = upper(mzxmlobj.retrieveActMethod(i));
            if(~isempty(strfind(actmethod,'ETD')))        
               spectraummary.numetdms2 = spectraummary.numetdms2 + 1; 
            elseif(~isempty(strfind(actmethod,'CID')))
                spectraummary.numcidms2 = spectraummary.numcidms2 +1;
            elseif(~isempty(strfind(actmethod,'HCD')))
                spectraummary.numhcdms2 = spectraummary.numhcdms2 +1;        
            end
        end
    end
end

end