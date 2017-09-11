function glycanNetFileViewer(glycanNetFileName, varargin)
%glycanNetFileViewer read an SBML file of a glycosylation network and return a graphical 
% representation
%
% glycanNetFileViewer(FILENAME, GLYCANFORMAT) reads a file name in the string
%  input argument FILENAME using a  sequence format specified with the
%  input argument GLYCANFORMAT. The function returns a graphics showing the 
%  glycosylation reaction network.
%
% glycanNetFileViewer(FILENAME, GLYCANFORMAT,OPTIONS) uses the options
%  which can be set up using displayset. See DISPLAYSET for details. 
%
% glycanNetFileViewer(FILENAME) uses Glycoct as default glycan sequence format
%   
% Example 1:
%  glycanNetFileViewer('OlinkedModel_wtannot.xml'); 
%
% Example 2:
%  glycanNetFileViewer('NlinkedModel_wtannot.xml','glycoct_xml');  
%
% Example 3       
%  % Set GUI display options
%  options=displayset('showRedEnd',false,'showLinkage',false,'netlayout','Circle');
%  % Allow linkage between displayed glycan structures and GlycomeDB database
%  % using the local server
%  options=displayset(options,'dbname','GLYCOME','dbusername','postgres');
%  options=displayset(options,'dbpassword','furnas910');
%  glycanNetFileViewer('NlinkedModel_wtannot.xml','glycoct_xml',options)
%
% See also glycanNetViewer,glycanFileViewer,glycanViewer,displayset,displayget.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% input check
if(~verLessThan('matlab','7.13'))
    narginchk(1,3);
else
    error(nargchk(1,3,nargin));
end

% set up default display options

% input number check
if  (nargin==1)
    glycanFileFormat = 'glycoct_xml';
    dispOptions =displayset;
elseif(nargin==2)
    glycanFileFormat  = varargin{1};
    dispOptions = displayset;
elseif(nargin==3)
    glycanFileFormat  = varargin{1};
    dispOptions   =  varargin{2};
end

% input variable type check
isCharArg = ischar(glycanNetFileName)&&ischar(glycanFileFormat) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

% check file existance
glycanNetFullFileName = which(glycanNetFileName);
isFileExist = exist(glycanNetFullFileName,'file');
if(~isFileExist)
    errorReport(mfilename,'FileNotFound');
end

optionfieldnames = char( 'showMass        ',   'showLinkage      ',    'showRedEnd     ',   ...
    'Isotope                 ',        'Derivatization   ',   'IonCloudCharge' ,   'NetLayout         ',   ...
    'NetFrameHeight ',        'NetFrameWidth',    'NetFitToFrame   ','dbname',...
    'dbusername','dbpassword');

% check option fields
names = fieldnames(dispOptions);

for i=1:length(names)
   if(~any(strcmpi(names(i,1),cellstr(optionfieldnames))))
       errorReport(mfilename,'wrongfieldname');
   end    
end

%set up display options with molecular weight and linkage
if(isempty(dispOptions))
    dispOptions = displayset;
end

% get all glycans
theglycanModel = glycanNetSBMLread(glycanNetFullFileName);
glycanNetViewer(theglycanModel,dispOptions);


end



