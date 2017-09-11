function queryStructRes = queryCFGDB(CFGDBid,varargin)
%queryCFGDB retrieve glycan structure information from CFG glycan structure
% database
% 
% CFGDBSTRUCT = queryCFGDB(CFGDBID) searches for the CFGDBID in the CFG 
%  glycan structure Database and returns a structure CFGDBSTRUCT 
%  containing glycan information.
%
% CFGDBSTRUCT contains four fields
%   1)summary:
%      This field includes the glycan family name, sub family name, 
%      last updated date, molecular weight and composition.
%   2)references:
%      literature references 
%   3)dbIDs:
%      If glycan structure was also reported in other databases,this field 
%      includes a list of IDs and their corresponding database names
%   4)glycanSeq:
%      This filed has two subfields including the IUPAC code and linear code
%                             
% Example:
%  queryResult = queryCFGDB('carbOlink_48280_D000');
%
% See also queryGlycomeDB,dbExactStructSearch.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% check if java jvm is installed
if ~usejava('jvm')
    error(message('queryGlycomeDB:NeedJVM', mfilename));
end

% check number of inputs
if(~verLessThan('matlab','7.13'))
    narginchk(1,1);       
else
    error(nargchk(1,1,nargin));
end

% check input variables
if(~isa(CFGDBid,'char'))
    errorReport(mfilename,'NonStringInput');
end


CFGDBurlFullName = 'http://www.functionalglycomics.org/glycomics/CarbohydrateServlet';
 
queryRes = urlread(CFGDBurlFullName,'get',{'pageType','view','view','view',...
        'operationType','view', 'carbId',CFGDBid});

[numTables,out_tables] = getTablesFromHTML(queryRes);

% assign generation information to summary field
genInfoID = getTableID(out_tables,'General Information');
summary.glycanFamily = out_tables{1,genInfoID}{1,2};
summary.subFamily = out_tables{1,genInfoID}{3,2};
summary.lastupdatedate = out_tables{1,genInfoID}{5,2};
summary.molweight = out_tables{1,genInfoID}{7,2};
summary.composition = out_tables{1,genInfoID}{11,2};

queryStructRes.summary = summary;

% assign database links to dbLinks field
carbBankIDIndex  = getTableID(out_tables,'Carb Bank Links');
dbIDs.carbBank = char(out_tables{1,carbBankIDIndex});
glycoScienceDBIDIndex  = getTableID(out_tables,'Glycosciences.DB Links');
dbIDs.glycoSci = char(out_tables{1,glycoScienceDBIDIndex});

queryStructRes.dbIDs = dbIDs;

% assign reference char to ref field
referIndex =  getTableID(out_tables,'References');
queryStructRes.ref =  char(out_tables{1,referIndex});

%  assing reference to  glycanSeq field
IUPACIndex = getTableID(out_tables,'IUPAC code');
glycanSeq.iupac = char(out_tables{1,IUPACIndex});

linearcodeIndex = getTableID(out_tables,'Linear Code');
glycanSeq.linearcode = char(out_tables{1,linearcodeIndex});

queryStructRes.glycanSeq = glycanSeq;


end
% assign general information to summary structure
function tableID = getTableID(out_tables, name)

tableFound = false;
i=0;
while ~tableFound
    i=i+1;
    table = out_tables{1,i};
    if(iscellstr(table))
       if(strcmpi(table,name)) 
         tableFound = true;
       end
    end
    
    if(i>length(out_tables)) 
        tableID =-1;
        return
    end
end

tableID = i+1;
end

