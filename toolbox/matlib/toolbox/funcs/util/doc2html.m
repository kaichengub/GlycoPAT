function doc2html(mfilestring,varargin);
% doc2html make a html file from doc command 
%
%
% See also help2html, doc

% Author: Gang Liu

narginchk(1,2);

dochtmlstr = help2html(mfilestring,'','-doc');

%doc2htmlstr=strrep(doc2htmlstr,'','');

% delete left header and right header
expr1='<td class="subheader-left">.*View code for \w*.\w*</a></td>';
expr2='<td class="subheader-right">.*Default Topics</a></td>';
dochtmlstr = regexprep(dochtmlstr,expr1,'');
dochtmlstr = regexprep(dochtmlstr,expr2,'');

% change reference link to html
dochtmlstr = regexprep(dochtmlstr,'<a href="matlab:doc (\w*)"','<a href="matlab:doc $1.html"');
dochtmlstr = regexprep(dochtmlstr,'matlab:doc ','');
dochtmlstr = regexprep(dochtmlstr,'"file:///C:/Program Files/MATLAB/R2011b/toolbox/matlab/helptools/private/helpwin.css"','"helpwin.css"');

if(nargin==2)
   htmlfilename =  varargin{1};
else
    htmlfilename = [strrep(mfilestring,'.m','') '.html'];
end
 fid = fopen(htmlfilename,'w');
 fprintf(fid,'%s',dochtmlstr);
  fclose(fid);
 
 
 
 
