function stat = webGlycomicsDB(resource,dbID)
%webGlycomicsDB open a web browser and search glycan structure information
% from Glycomics databases
% 
% STAT = webGlycomicsDB(RESOURCE,DBID) searches for the database ID (DBID)
%  in the Glycomics database in system browser. Current resources include
%  GlycomeDB and CFG. It returns the status of the web browser execution.
%  (0: successful execution; 1: browser not found; 2: browser not launched)
%                             
% Example 1:
%  webGlycomicsDB('GlycomeDB','123');
%
% Example 2:
%  webGlycomicsDB('CFG','carbOlink_48280_D000');
%
% See also queryCFGDB, queryGlycomeDB.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% check number of inputs
if(~verLessThan('matlab','7.13'))
    narginchk(2,2);
else
    error(nargchk(2,2,nargin));
end

% check input variables
if  ~(isa(resource,'char')&&isa(dbID,'char'))
    errorReport(mfilename,'NonStringInput');
end

% check resource name
if(strcmpi(resource,'glycomedb'))   %GLYCOMEDB
    glycomeDBurl = 'http://www.glycome-db.org/';
    actionName = 'database/showStructure.action';
    glycomicsURL = [glycomeDBurl actionName '?glycomeId=',dbID];    
    
elseif(strcmpi(resource,'cfg'))     % CFG Glycan Structure
    CFGDBurlFullName =[ 'http://www.functionalglycomics.org/glycomics/CarbohydrateServlet?',....
        'pageType=view&view=view&operationType=view&'];
    glycomicsURL = [CFGDBurlFullName 'carbId=',dbID];     
else 
    errorReport(mfilename,'NotSupportedResource');
end

stat = web(glycomicsURL,'-browser');

end