classdef Aminoacid
    % AMINOACID: An Object storing the properties of amino acids
    %   
    %   Syntax:
    %        aa3letlist = Aminoacid.aa3let;
    %        aa1letlist = Aminoacid.aa1let;
    %        aaformula = Aminoacid.formulaMap(aa1let);
    %   
    %   Input:
    %        aa1let: single-letter code representing single amino acid
    %
    %   Output:
    %        aa1letlist: single-letter code for all amino acids
    %        aa3letlist: 3-letter code for all amino acids
    %        aaformula: chemical formula for single amino acid
    %   
    %   Example:
    %       Example 1:
    %          aa3letlist = Aminoacid.aa3let
    %    
    %       Example 2:
    %          aa1letlist = Aminoacid.aa1let
    %  
    %       Example 3:
    %          alaformula = Aminoacid.formulaMap('A');
    %
    %   Note:                    Amino Acid table:
    %                          __________________
    %                            code | type
    %                          __________________
    %                              A  |  Ala
    %                              R  |  Arg
    %                              N  |  Asn
    %                              D  |  Asp
    %                              C  |  Cys
    %                              Q  |  Gln
    %                              E  |  Glu
    %                              G  |  Gly
    %                              H  |  His
    %                              I  |  Ile
    %                              L  |  Leu
    %                              K  |  Lys
    %                              M  |  Met
    %                              F  |  Phe
    %                              P  |  Pro
    %                              S  |  Ser
    %                              T  |  Thr
    %                              W  |  Trp
    %                              Y  |  Tyr
    %                              V  |  Val
    %                              B  |  Asx
    %                              Z  |  Glx
    %                              X  |  Unk
    %                          _________________
    %
    %See also Chemele, Glycan, Chemformula, Protease, Modification, mzXML 
    %
    % Author: Gang Liu
    % Date: 1/19/2015
    
    properties (Constant)
        aa3let = {'Ala','Arg','Asn','Asp','Cys','Gln','Glu','Gly','His',...
            'Ile','Leu','Lys','Met','Phe','Pro','Ser','Thr','Trp',...
            'Tyr','Val','Asx','Glx','Unk'};
        aa1let = {'A','R','N','D','C','Q','E','G','H','I','L','K','M','F','P','S',...
            'T','W','Y','V','B','Z','X'};
        aaformula = {struct('C',3,'H',7,'N',1,'O',2),struct('C',6,'H',14,'N',4,'O',2),...
            struct('C',4,'H',8,'N',2,'O',3),struct('C',4,'H',7,'N',1,'O',4),...
            struct('C',3,'H',7,'N',1,'O',2,'S',1),struct('C',5,'H',10,'N',2,'O',3),...
            struct('C',5,'H',9,'N',1,'O',4),struct('C',2,'H',5,'N',1,'O',2),...
            struct('C',6,'H',9,'N',3,'O',2),struct('C',6,'H',13,'N',1,'O',2),...
            struct('C',6,'H',13,'N',1,'O',2),struct('C',6,'H',14,'N',2,'O',2),...
            struct('C',5,'H',11,'N',1,'O',2,'S',1),struct('C',9,'H',11,'N',1,'O',2),...
            struct('C',5,'H',9,'N',1,'O',2),struct('C',3,'H',7,'N',1,'O',3),...
            struct('C',4,'H',9,'N',1,'O',3),struct('C',11,'H',12,'N',2,'O',2),...
            struct('C',9,'H',11,'N',1,'O',3),struct('C',5,'H',11,'N',1,'O',2),...
            [],[],...
            []};
        
         formulaMap = containers.Map({'A','R','N','D','C','Q','E','G','H',...
            'I','L','K','M','F','P','S',...
            'T','W','Y','V','B','Z','X'},...
            {struct('C',3,'H',7,'N',1,'O',2),struct('C',6,'H',14,'N',4,'O',2),...
            struct('C',4,'H',8,'N',2,'O',3),struct('C',4,'H',7,'N',1,'O',4),...
            struct('C',3,'H',7,'N',1,'O',2,'S',1),struct('C',5,'H',10,'N',2,'O',3),...
            struct('C',5,'H',9,'N',1,'O',4),struct('C',2,'H',5,'N',1,'O',2),...
            struct('C',6,'H',9,'N',3,'O',2),struct('C',6,'H',13,'N',1,'O',2),...
            struct('C',6,'H',13,'N',1,'O',2),struct('C',6,'H',14,'N',2,'O',2),...
            struct('C',5,'H',11,'N',1,'O',2,'S',1),struct('C',9,'H',11,'N',1,'O',2),...
            struct('C',5,'H',9,'N',1,'O',2),struct('C',3,'H',7,'N',1,'O',3),...
            struct('C',4,'H',9,'N',1,'O',3),struct('C',11,'H',12,'N',2,'O',2),...
            struct('C',9,'H',11,'N',1,'O',3),struct('C',5,'H',11,'N',1,'O',2),...
            [],[],...
            []});            
    end
    
    methods(Static)
        function aachar = getaachar
            aachar = char(Aminoacid.aa1let)';
        end
        
        function aaexpr = getaacharexpr
            aaexpr =['[^' Aminoacid.getaachar];
            aaexpr =[aaexpr ']'];
        end
        
%         function aaexpr = getaa1letcharexpr
%             aaexpr =['[' Aminoacid.getaachar];
%             aaexpr =[aaexpr ']'];
%         end
        
        function aaexpr = getaa1letcharexpr
            aaexpr ='[ARNDCQEGHILKMFPSTWYV]';
        end
        
        function isaachar = isaastring(stringinput)
            findnonaachar = regexp(stringinput,Aminoacid.getaacharexpr, 'once');
            isaachar      = isempty(findnonaachar);
        end
    end
end

