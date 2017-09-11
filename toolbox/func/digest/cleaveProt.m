function Prod = cleaveProt(Prot,Enzyme,MissedMax,MinPepLen,MaxPepLen)
%CLEAVEPROT: Digest single protein with enzyme regardless of type of 
%  modification
% 
% Syntax: 
%   Prod = cleaveProt(Prot,Enzyme,MissedMax,MinPepLen,MaxPepLen)
%  
% Input: 
%    Enzyme:    input string or cell array of strings
%    Prot:      input string containing protein sequence code
%    MissedMax: the number of missed cleavages
%    MinPepLen: minimum peptide length
%    MaxPepLen: maximum peptide length
% 
% Output: 
%    Prod: the MATLAB structure containing data on digestide peptide (in 
%     "pep" field) along with starting ("start") and ending positions ("fin") 
%     on that particular Prot. 
%
% Example:
% Prot   = peptideread('fetuin.txt');
% Enzyme='Trypsin';
% MissedMax=1;
% MinPepLen=4
% MaxPepLen=30
% Prod = cleaveProt(Prot.sequence,Enzyme,MissedMax,MinPepLen,MaxPepLen)
%
% See also digestSGP. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 08/03/14 Modified by Gang Liu

%% check if input of enzyme can be found in GlycoPAT local protease database
proteasedb    =  Protease.mklocaldb;
if(iscell(Enzyme))
    for k=1:length(Enzyme)
        if(~proteasedb.isKey(upper(Enzyme{k})))
            error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
        end
    end
else
    if(~proteasedb.isKey(upper(Enzyme)))
        error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
    end
end

%% cleavage peptide
CleavagePos  = [];
% cleave Prot now with the enzymes
if(iscell(Enzyme))
    for k=1:length(Enzyme)
        if(proteasedb.isKey(upper(Enzyme{k})))
            ezncleaveexpr =  proteasedb(upper(Enzyme{k}));            
            CleavagePos  = [CleavagePos,regexp(Prot, ezncleaveexpr)];   
        else
            error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
        end
    end
else
    if(proteasedb.isKey(upper(Enzyme)))
        ezncleaveexpr =  proteasedb(upper(Enzyme));
        CleavagePos  = [CleavagePos,regexp(Prot, ezncleaveexpr)];    
    else
        error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
    end
end
CleavagePos  = [0 CleavagePos length(Prot)];  % Adds the first and last aacidPoss in Prot
CleavagePos  = unique(CleavagePos);          % Removes duplicate in case first and last are also digestion points

Prod =[];
PepCount=1;                                % Digestion of peptide with given minimum length and allowed missed cleavage
for i=0:MissedMax
    cleaveposlength = length(CleavagePos);
    for j=1:(cleaveposlength-i-1);
        start=CleavagePos(j)+1;
        finish=CleavagePos(j+i+1);

        peptide_long=Prot(start:finish);
        modstart=[strfind(peptide_long,'<'),length(peptide_long)+1];
        modend=[0,strfind(peptide_long,'>')];
        peptide_short='';
        for k=1:length(modstart)
            peptide_short=[peptide_short,peptide_long(modend(k)+1:modstart(k)-1)];
        end
        
        if ((length(peptide_short)>=MinPepLen)&&(length(peptide_short)<=MaxPepLen))
            Prod.pep(PepCount)={Prot(start:finish)};  % convert digested peptide into cell
            Prod.short(PepCount)={peptide_short};
            Prod.start(PepCount)=start;
            Prod.fin(PepCount)=finish;
            PepCount=PepCount+1;
        end
    end
end

end
