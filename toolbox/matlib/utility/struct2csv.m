function struct2csv(structvar,FID,varargin)
% STRUCT2CSV(structvar,filehandle,showheader)
%
% Output a structure to a comma delimited file with column headers
%
%       s : any structure composed of one or more matrices and cell arrays
%      fn : file name
%
%      Given s:
%
%          s.Alpha = { 'First', 'Second';
%                      'Third', 'Fourth'};
%
%          s.Beta  = [[      1,       2;
%                            3,       4]];
%
%          s.Gamma = {       1,       2;
%                            3,       4};
%
%          s.Epsln = [     abc;
%                          def;
%                          ghi];
%
%      STRUCT2CSV(s,'any.csv') will produce a file 'any.csv' containing:
%
%         "Alpha",        , "Beta",   ,"Gamma",   , "Epsln",
%         "First","Second",      1,  2,      1,  2,   "abc",
%         "Third","Fourth",      3,  4,      3,  4,   "def",
%                ,        ,       ,   ,       ,   ,   "ghi",
%
%      v.0.9 - Rewrote most of the code, now accommodates a wider variety
%              of structure children
%
% Written by James Slegers, james.slegers_at_gmail.com
% Covered by the BSD License
%
%
%See also

if(length(varargin)==1 && isnumeric(varargin{1}))
    showheader = varargin{1};
else
    showheader = 1;
end

headers = fieldnames(structvar);
m = length(headers);
sz = zeros(m,2);

structlength = length(structvar);
done=false;
for rr = 1 : structlength
    
    l = '';
    for ii = 1:m
        sz(ii,:) = size(structvar(rr).(headers{ii}));
        if ischar(structvar(rr).(headers{ii}))
            sz(ii,2) = 1;
        end
        l = [l,'"',headers{ii},'",',repmat(',',1,sz(ii,2)-1)];
    end
    
    l = [l,'\n'];
    if(showheader==1)
        if ~done
            fprintf(FID,l);
            done=true;
        end
    end
    %     l = '';
    %     for ii = 1:m
    %         sz(ii,:) = size(structvar(rr).(headers{ii}));
    %         if ischar(structvar(rr).(headers{ii}))
    %             sz(ii,2) = 1;
    %         end
    %         if(showheader==1)
    %             l = [l,'"',headers{ii},'",',repmat(',',1,sz(ii,2)-1)];
    %         end
    %     end
    %     if (showheader==1)
    %         l = [l,'\n'];
    %     end
    % end
    % if (showheader==1)
    %     fprintf(FID,l);
    % end
    n = max(sz(:,1));
    
    for ii = 1:n
        l = '';
        for jj = 1:m
            c = structvar(rr).(headers{jj});
            str = '';
            
            if sz(jj,1)<ii
                str = repmat(',',1,sz(jj,2));
            else
                if isnumeric(c)
                    for kk = 1:sz(jj,2)
                        str = [str,num2str(c(ii,kk)),','];
                    end
                elseif islogical(c)
                    for kk = 1:sz(jj,2)
                        str = [str,num2str(double(c(ii,kk))),','];
                    end
                elseif ischar(c)
                    str = ['"',c(ii,:),'",'];
                elseif iscell(c)
                    if isnumeric(c{1,1})
                        for kk = 1:sz(jj,2)
                            str = [str,num2str(c{ii,kk}),','];
                        end
                    elseif islogical(c{1,1})
                        for kk = 1:sz(jj,2)
                            str = [str,num2str(double(c{ii,kk})),','];
                        end
                    elseif ischar(c{1,1})
                        for kk = 1:sz(jj,2)
                            str = [str,'"',c{ii,kk},'",'];
                        end
                    end
                end
            end
            l = [l,str];
        end
        l = [l,'\n'];
        fprintf(FID,l);
    end
end