function setDataProcessInfo(obj)
% SETDATAPROCESSINFO: Set MS data processing information in an mzXML object
%
% Syntax: 
%         mzXMLobj.setDataProcessInfo
%         setDataProcessInfo(mzXMLobj)
%
% Example:
%        mzXMLobj = readmzXML('demofetuin.mzXML');
%        mzXMLobj.setDataProcessInfo;
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

mzxmljava           = obj.mzxmljava;
dataprocessingjava  = mzxmljava.getHeaderInfo.getDataProcessing;
if(~isempty(dataprocessingjava))
    obj.dataprocessinginfo.centroided   = dataprocessingjava.getCentroided;
    obj.dataprocessinginfo.deconvoluted = dataprocessingjava.getChargeDeconvoluted;
    obj.dataprocessinginfo.deisotoped   = dataprocessingjava.getDeisotoped;
    obj.dataprocessinginfo.intensitycufoff = dataprocessingjava.getIntensityCutoff;
    obj.dataprocessinginfo.softwareused =  char(dataprocessingjava.getSoftwareUsed.toString);
    obj.dataprocessinginfo.spotintegration = dataprocessingjava.getSpotIntegration;
else
    obj.dataprocessinginfo=[];
end
end