function conn=dbLocalConnect(databasename,username,passwd)
%dbLocalConnect connect to a database running on a local server
%
% CONN = dbLocalConnect(DATABASENAME,USERNAME,PASSWORD) returns a
%  database connection object CONN. DATABASENAME is the local database name.
%  USERNAME is the user name. PASSWORD is the password string for access to
%  the database. Note that the GlycomeDB database is a PostGRES database.
%  Setup of such a server requires a user name and password.
%  
% Example: 
%  %%  when the database name is 'glycomedb', the user name is
%  %%  'postgres', and the password is 'furnas910', type the following commands
%  %%  to connect to the database. 
%
%  databasename = 'glycomedb'; username='postgres'; pwd='furnas910';
%  conn = dbLocalConnect(databasename,username,pwd);
%  
% See also dbExactStructSearch. 

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% check number of inputs
% if(~verLessThan('matlab','7.13'))
%     narginchk(3,3);
% else
    error(nargchk(3,3,nargin));
% end

url  = 'jdbc:postgresql://localhost:5432/';
driver = 'org.postgresql.Driver';

% input type check
isInputString = isa(databasename,'char') && isa(username,'char') ...
          && isa(passwd,'char') ;
if(~isInputString)
    errorReport(mfilename,'NonStringInput');
end

conn = database(databasename,username,passwd,driver,url);

if(~isconnection(conn))
    errorReport(mfilename,'DatabaseConnectFailed');
end