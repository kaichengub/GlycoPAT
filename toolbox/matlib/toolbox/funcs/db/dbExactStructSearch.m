function glycomedbID=dbExactStructSearch(databaseconn,glycanStruct,varargin)
%dbExactStructSearch search a local GlycomeDB database for the glycan 
% structure and return its corresponding ID in the database
% 
% GLYCOMEDBID = dbExactStructSearch(DATABASECONN,GLYCANSTRUCT) searches a
%  database connection object DATABASECONN and looks for the glycan with 
%  exact structure as a GlycanStruct object. The function returns its 
%  corresponding ID used in GlycomeDB database. If this structure is not
%  found in the database, the value returned is -1. 
%
% GLYCOMEDBID = dbExactStructSearch(DATABASECONN,GLYCANSTRUCTSTR,GLYCANFORMAT)
%  searches the DATABASECONN and look for the glycan with exact structure 
%  as GLYCANSTRUCTSTR in the format of string input argument GLYCANFORMAT. 
%  GLYCANSTRUCTSTR can be either MATLAB char or Java string. GLYCANFORMAT is 
%  in either GlycoCT('glycoct_xml') or GlycoCT-condensed('glycoct_condensed')
%  format.
%  
% Example: 
%  glycanFileName   = 'highmannose.glycoct_xml';
%  glycanFileFormat = 'glycoct';  
%  M5_glycan        =  glycanMLread(glycanFileName,glycanFileFormat); 
%  glycanString     =  glycanStrwrite(M5_glycan,'glycoct_condensed');
%  % database, username, password are use-defined  
%  conn        = dbLocalConnect('GLYCOME','postgres','furnas910');   
%  glycomedbID = dbExactStructSearch(conn,glycanString,'glycoct_condensed')
%  
% See also dbLocalConnect,database,close.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% import glycans
import java.net.MalformedURLException;
import org.eurocarbdb.application.glycanbuilder.*;

selfFileName = 'dbExactStructSearch';

%input number control
% check number of inputs
if(~verLessThan('matlab','7.13'))
    narginchk(2,3);
else
    error(nargchk(2,3,nargin));
end

if(isa(glycanStruct,'GlycanStruct'))
     glycanJava = glycanStruct.structMat2Java;
     glycoDoc = GlycanDocument(org.eurocarbdb.application.glycanbuilder.BuilderWorkspace());
     glycoDoc.addStructure(glycanJava);
     glycanFormat = 'glycoct_xml';
     glycanString= char(glycoDoc.toString(glycanFormat));
     %glycanString=strtrim(glycanString);
elseif(isa(glycanStruct,'string'))
     glycanString = glycanStruct;
     glycanFormat = varargin{1};
elseif(isa(glycanStruct,'char'))
     glycanString = glycanStruct; 
     glycanFormat = varargin{1};
else
    errorReport(selfFileName,'WrongInputType');
end

% set up schema name and 
schemaName = 'core';
if(strcmpi(glycanFormat,'glycoct_xml'))
    structureTableName = 'structure_glycoct_xml';    
    whereStringStatement = [' where xml= ''' glycanString ''''];
elseif(strcmpi(glycanFormat,'glycoct_condensed'))
    structureTableName = 'structure';
    whereStringStatement = [' where glyco_ct= ''' glycanString ''''];
else
    errorReport(selfFileName,'WrongGlycanFormat');
end

% SQL select statement to search glycan 
sqlSelectQuery = ['select structure_id from ' schemaName '.' structureTableName ' ' whereStringStatement];
structureDB = fetch(databaseconn,sqlSelectQuery);

% return glycomedbID
if(length(structureDB)==1) 
    glycomedbID = cell2mat(structureDB);
else
    glycomedbID = -1;
end