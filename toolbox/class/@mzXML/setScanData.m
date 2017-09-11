function setScanData(obj,varargin)
% SETSCANDATA: Set scan data in an mzXMLObj object
%
% Syntax:
%        setScanData(mzXMLObj)
%        mzXMLObj.setScanData
%
% Example:
%        mzXMLobj = readmzXML('demofetuin.mzXML');
%        mzXMLobj.setScanData;
%
%See Also mzXML.

% Author: Gang Liu
% Date Lastly Updated: 08/05/15

% read all scan data in mzXML format
numscan   = obj.mzxmljava.getScanCount;
scandata  = cell(numscan,1);

if(length(varargin)>=1)
    showprog = varargin{1};
else
    showprog = 0;
end

if(length(varargin)==2)
    quickloading = varargin{2};
else
    quickloading = 0;
end

if(~isnumeric(showprog))
    showprog = 0;
end


if(showprog)
    h = waitbar(0,'Loading mzXML file...Please wait...');
end

for i = 1 : numscan
    i
    if(~isempty(obj.mzxmljava.rap(i)))
        if(showprog)
            waitbar(i/numscan,h)
        end
        
        if(quickloading)
            ithscandata.scannum = obj.mzxmljava.rap(i).getNum;
            ithscandata.msintensitylist = (obj.mzxmljava.rap(i).getMassIntensityList)';
            ithscandata.actmethod = char(obj.extmzxmljava.rap(i).getActivationMethod);
        else
            ithscandata.scannum = obj.mzxmljava.rap(i).getNum;
            ithscandata.msLevel = obj.mzxmljava.rap(i).getMsLevel;
            ithscandata.peaksCount = obj.mzxmljava.rap(i).getPeaksCount;
            ithscandata.polarity = char(obj.mzxmljava.rap(i).getPolarity);
            ithscandata.scanType = char(obj.mzxmljava.rap(i).getScanType);
            ithscandata.centroided = obj.mzxmljava.rap(i).getCentroided;
            ithscandata.deisotoped = obj.mzxmljava.rap(i).getDeisotoped;
            ithscandata.chargeDeconvoluted = obj.mzxmljava.rap(i).getChargeDeconvoluted;
            retentionTime = char(obj.mzxmljava.rap(i).getRetentionTime);
            retention     = regexp(retentionTime,'(?<ret>\d+\.\d+)(?<unit>[a-z_A-Z]+)','names');
            if(~isempty(retention))
                ithscandata.retentionTime  = str2double(retention.ret);
                ithscandata.retentionTimeUnit = retention.unit;
            else
                ithscandata.retentionTime = -1;
                ithscandata.retentionTimeUnit = '';
            end
            ithscandata.startMz = obj.mzxmljava.rap(i).getStartMz;
            ithscandata.endMz = obj.mzxmljava.rap(i).getEndMz;
            ithscandata.lowMz = obj.mzxmljava.rap(i).getLowMz;
            ithscandata.highMz = obj.mzxmljava.rap(i).getHighMz;
            ithscandata.basePeakMz = obj.mzxmljava.rap(i).getBasePeakMz;
            ithscandata.basePeakIntensity = obj.mzxmljava.rap(i).getBasePeakIntensity;
            ithscandata.totIonCurrent = obj.mzxmljava.rap(i).getTotIonCurrent;
            ithscandata.precursorMz = obj.mzxmljava.rap(i).getPrecursorMz;
            ithscandata.precursorScanNum = obj.mzxmljava.rap(i).getPrecursorScanNum;
            ithscandata.precursorCharge = obj.mzxmljava.rap(i).getPrecursorCharge;
            ithscandata.collisionEnergy = obj.mzxmljava.rap(i).getCollisionEnergy;
            ithscandata.ionisationEnergy = obj.mzxmljava.rap(i).getIonisationEnergy;
            ithscandata.precision = obj.mzxmljava.rap(i).getPrecision;
            ithscandata.header = char(obj.mzxmljava.rap(i).getHeader);
            ithscandata.msintensitylist = (obj.mzxmljava.rap(i).getMassIntensityList)';
            ithscandata.actmethod = char(obj.extmzxmljava.rap(i).getActivationMethod);
        end
    end
    scandata{i,1} = ithscandata;
end
if(showprog)
    close(h);
end
obj.scandata = scandata;
end