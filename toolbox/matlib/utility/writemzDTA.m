function iswritten = writemzDTA(varargin)
%WRITEMZDTA: Write mass spectrometry data in DTA file format
%
% Syntax:
%     iswritten = writemzDTA(mzXMLfilenmae,dtafiledir,spectrumindex);
%     iswritten = writemzDTA(mzXMLfilenmae,dtafiledir,'scannum',scannum);
%     iswritten = writemzDTA(mzXMLObj,dtafiledir,dtafilenameprefix,spectrumindex);
%     iswritten = writemzDTA(mzXMLObj,dtafiledir,dtafilenameprefix,'scannum',scannum);
%     iswritten = writemzDTA(spectraObj,dtafiledir,dtafilenameprefix);
%     iswritten = writemzDTA(spectraIntensitylist,scannum,precursorMH,precursorZ,dtafiledir,dtafilenameprefix,mslevel);
%
% Input:
%     mzXMLfilenmae: the file name of an mxXML file
%     mzXMLObj: an mzXML object
%     dtafiledir: the directory where the dta files are stored
%     spectrumindex: the spectrum index in the mzXML file
%     scannum: scan number
%     dtafilenameprefix:  file name prefix
%     spectraIntensitylist: spectra intensity list
%     precursorMH: precursor M+H
%     precursorZ:  precursor Charge
%
% Output:
%    a DTA file
%
% Example:
%    Example 1: 
%       iswritten = writemzDTA('demofetuin.mzXML','c:\dta',1);
%   
%    Example 2: 
%       iswritten = writemzDTA('demofetuin.mzXML','c:\dta','scannum',11919);
%
%    Example 3: 
%       mzXMLObj  = readmzXML('demofetuin.mzXML');
%       iswritten = writemzDTA(mzXMLObj,'c:\dta','testfetuin',2);
%   
%    Example 4: 
%       mzXMLObj  = readmzXML('demofetuin.mzXML');
%       iswritten = writemzDTA(mzXMLObj,'c:\dta','testfetuin','scannum',11920);
%         
%    Example 5: 
%       mzXMLObj  = readmzXML('demofetuin.mzXML');
%       spectraObj = Spectra(mzXMLObj,33);
%       iswritten = writemzDTA(spectraObj,'c:\dta','testfetuin');
%   
%    Example 6: 
%       mzXMLObj  = readmzXML('demofetuin.mzXML');
%       spectraObj = Spectra(mzXMLObj,35); 
%       spectraIntensitylist = spectraObj.msintensitylist;
%       scannum              = spectraObj.scanNum;
%       precursorMZ          = spectraObj.precursorMz;
%       precursorCharge      = spectraObj.precursorCharge;
%       precursorMH          = precursorMZ*precursorCharge-(precursorCharge-1)*1.0078246;
%       mslevel              = spectraObj.msLevel;       
%       iswritten = writemzDTA(spectraIntensitylist,scannum,precursorMH,precursorCharge,'c:\dta','testfetuin',mslevel);
%   
%
%
%See also readmzXML,readPeptide,readVarPtm,readFixedPtm.

% Author: Gang Liu 
% Date Lastly Updated: 12/20/14

HMass = 1.0078246;
if(nargin==7)
    spectraIntensitylist=varargin{1};
    scannum=varargin{2};
    precursorMH=varargin{3};
    precursorCharge=varargin{4};
    dtafiledir=varargin{5};
    dtafilenameprefix=varargin{6};
    mslevel = varargin{7};
elseif(nargin==3)
    if(ischar(varargin{1}))
        mzXMLfilename = varargin{1};
        spectrumindex = varargin{3};
        mzXMLObj    = readmzXML(mzXMLfilename);
        spectraObj  = Spectra(mzXMLObj,spectrumindex);              
        [~,dtafilenameprefix,~]=fileparts(mzXMLfilename);        
    elseif(isa(varargin{1},'Spectra'))
        spectraObj=varargin{1};
        dtafilenameprefix=varargin{3};        
    else
        error('MATLAB:GLYCOPAT:ERRORINPUTTYPE','INCORRECT INPUT TYPE');
    end    
    
    dtafiledir           = varargin{2};  
    spectraIntensitylist = spectraObj.msintensitylist;
    scannum              = spectraObj.scanNum;
    precursorMZ          = spectraObj.precursorMz;
    precursorCharge      = spectraObj.precursorCharge;
    precursorMH          = precursorMZ*precursorCharge-(precursorCharge-1)*HMass;
    mslevel              = spectraObj.msLevel;    
elseif(nargin==4)
     if(ischar(varargin{1}))
        mzXMLfilename = varargin{1}; 
        mzXMLObj    = readmzXML(mzXMLfilename);
        spectraObj  = Spectra(mzXMLObj,varargin{3},varargin{4});              
        [~,dtafilenameprefix,~]=fileparts(mzXMLfilename);
    elseif(isa(varargin{1},'mzXML'))
        mzXMLObj             = varargin{1};
        dtafilenameprefix    = varargin{3};
        spectrumindex        = varargin{4};
        spectraObj           = Spectra(mzXMLObj,spectrumindex);
     else         
         error('MATLAB:GLYCOPAT:ERRORINPUTTYPE','INCORRECT INPUT TYPE');
     end    
    dtafiledir           = varargin{2};  
    spectraIntensitylist = spectraObj.msintensitylist;
    scannum              = spectraObj.scanNum;
    precursorMZ          = spectraObj.precursorMz;
    precursorCharge      = spectraObj.precursorCharge;
    precursorMH          = precursorMZ*precursorCharge-(precursorCharge-1)*HMass;
    mslevel              = spectraObj.msLevel;
elseif(nargin==5)   
    % (mzXMLObj,dtafiledir,dtafilenameprefix,'scannum',scannum);
    mzXMLObj             = varargin{1}; 
    dtafiledir           = varargin{2};  
    dtafilenameprefix    = varargin{3};
    spectraObj  = Spectra(mzXMLObj,varargin{4},varargin{5});    
    spectraIntensitylist = spectraObj.msintensitylist;
    scannum              = spectraObj.scanNum;
    precursorMZ          = spectraObj.precursorMz;
    precursorCharge      = spectraObj.precursorCharge;
    precursorMH          = precursorMZ*precursorCharge-(precursorCharge-1)*HMass;
    mslevel              = spectraObj.msLevel;    
else
     error('MATLAB:GLYCOPAT:ERRORINPUTNUM','INCORRECT INPUT NUMBER');
end

if(exist(dtafiledir,'dir')~=7)
    [success,message,messageid]=mkdir(dtafiledir);
    if(~success)
        error(message);
    end
end

dtafilename = [dtafilenameprefix,'.',int2str(scannum),...
    '.',int2str(scannum),'.',...
    int2str(precursorCharge),'.dta'];
dtafullfilename = fullfile(dtafiledir,dtafilename);
fid = fopen(dtafullfilename,'Wb');
if(fid~=-1)
 dtafilestr = '';
 dtafilestr=[dtafilestr,sprintf('%9.4f %12i\n',precursorMH,precursorCharge)]; 
 for i = 1:size(spectraIntensitylist,1)
     dtafilestr=[dtafilestr,sprintf('%9.4f %12.4f\n',spectraIntensitylist(i,1),spectraIntensitylist(i,2))];
 end
 fprintf(fid,'%s',dtafilestr); 
 fclose(fid);
 iswritten = 1;
else
 iswritten = 0;  
end

end
