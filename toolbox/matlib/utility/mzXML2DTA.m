function numDTAFiles = mzXML2DTA(varargin)
%mzXML2DTA: convert mzXML file to DTA file format
%
% Syntax:
%     numDTAFiles = mzXML2DTA(mzXMLfilenmae,dtafiledir);
%     numDTAFiles = mzXML2DTA(mzXMLfilenmae,dtafiledir,'mslevel',mslevel);
%     numDTAFiles = mzXML2DTA(mzXMLObj,dtafiledir,dtafilenameprefix);
%     numDTAFiles = mzXML2DTA(mzXMLObj,dtafiledir,dtafilenameprefix,'mslevel',mslevel);
%     
% Input:
%     mzXMLfilenmae: the file name of an mxXML file
%     mzXMLObj: an mzXML object
%     dtafiledir: the directory where the dta files are stored
%     mslevel: MS level
%
% Output:
%    a number of DTA files outputed
%
% Example:
%   Example 1:
%      totalMSfile = mzXML2DTA('demofetuin.mzXML','c:/dta/fetuintest1');
%      disp(totalMSfile);
%       
%      Answer: 501
%
%   Example 2:
%      totalms2file = mzXML2DTA('demofetuin.mzXML','c:/dta/fetuintest2','mslevel',2);
%      disp(totalms2file);
%       
%      Answer: 448

%
%   Example 3:
%      mzXMLObj = readmzXML('demofetuin.mzXML');
%      totalMSfile = mzXML2DTA(mzXMLObj,'c:/dta/fetuintest3','fetuintest3'); 
%      disp(totalMSfile);
%       
%      Answer: 501
%
%   Example 4:
%      mzXMLObj = readmzXML('demofetuin.mzXML');
%      totalms1file = mzXML2DTA(mzXMLObj,'c:/dta/fetuintest4','fetuintest4','mslevel',1)%
%      disp(totalms1file);
%       
%      Answer: 48
%
%See also writemzDTA,readmzXML,readPeptide,readVarPtm,readFixedPtm.

% Author: Gang Liu 
% Date Lastly Updated: 12/20/14

if(nargin==2)
    mzXMLObj = readmzXML(varargin{1});
    dtafiledir = varargin{2};
    [~,dtafilenameprefix,~]=fileparts(varargin{1});
    mslevel = 0;
elseif(nargin==3)
    mzXMLObj   = varargin{1};
    dtafiledir = varargin{2};
    dtafilenameprefix=varargin{3};
    mslevel = 0;
elseif(nargin==4)
    mzXMLObj   = readmzXML(varargin{1});
    dtafiledir = varargin{2};
    [~,dtafilenameprefix,~]=fileparts(varargin{1}); 
    if(~ischar(varargin{3}) ||(~strcmpi(varargin{3},'mslevel')))
        error('MATLAB:GLYCOPAT:WROINGINPUTSTRING','INCORRECT INPUT NUMBER'); 
    end    
    mslevel = varargin{4}; 
elseif(nargin==5)
    mzXMLObj = varargin{1};
    dtafiledir = varargin{2};
    dtafilenameprefix = varargin{3};
    if(~ischar(varargin{4}) ||(~strcmpi(varargin{4},'mslevel')))
        error('MATLAB:GLYCOPAT:WROINGINPUTSTRING','INCORRECT INPUT NUMBER'); 
    end    
    mslevel = varargin{5};    
else
    error('MATLAB:GLYCOPAT:WROINGINPUTNUM','INCORRECT INPUT NUMBER');
end

numDTAFiles = 0;
numscan = mzXMLObj.mzxmljava.getScanCount;
for i = 1: numscan
     if(mslevel==0)
         writemzDTA(mzXMLObj,dtafiledir,dtafilenameprefix,i);
         numDTAFiles = numDTAFiles+1;
     else
        spectraObj = Spectra(mzXMLObj,i);
        if(mslevel==spectraObj.msLevel) && strcmpi(mzXMLObj.retrieveActMethod(i),'CID')
           writemzDTA(spectraObj,dtafiledir,dtafilenameprefix);
           numDTAFiles = numDTAFiles+1;
        end
     end    
end

