classdef Protease
%PROTEASE: An object storing the properties of the protease
%   
%  Syntax: 
%         protrulelocaldb =  Protease.mklocaldb;   
%         protrule = protrulelocaldb(protshortname);
%         protrulelocaldb.keys
%
%  Input:  
%         protshortname: short name for the protease
%   
%  Output: 
%         protrulelocaldb: local database of protease cleavage rules 
%         protrule: cleavage rule for the protease
%  
%  Example:
%         protrulelocaldb =  Protease.mklocaldb;  % make local Protease db
%         protrulelocaldb.keys                    % view protshortname of available enzymes
%         protrule = protrulelocaldb('TRYPSIN')   % view cleavage rule (uses 'regular expression' format)
%        
%
%  Note:              Common Protease table 
%                      __________________
%                      Protease | Cleavage Expression Pattern
%                     __________________
%                      TRYPSIN  | [KR](?![P<])
%                        Lys-C  | [K](?![<])
%                 Glu-C(V8 DE)  | [DE](?!<)
%                  Glu-C(V8 E)  | [E](?!<)
%                         CNBR  | [M](?!<)
%            Chymotrypsin High  | ([FY](?=[^P<]))|(W(?=[^MP<]))
%             Chymotrypsin Low  | ([FLY](?=[^P<]))|(W(?=[^MP<]))|(M(?=[^PY<]))|(H(?=[^DMPW<]))                         
%                          _________________
%  The rules for other proteases follow the same rules as those in
%  Peptide_cutter tool. Type "edit Protease" to look up the rule table.
%  
%See also Chemele, Glycan, Chemformula, Modification, mzXML, Aminoacid.
    
 % Author: Gang Liu
 % Date Lastly Updated: 8/4/15
    
    properties
        shortname;
        fullname;
        cleaveexpr;
    end
    
    methods
        function obj=Protease(shortname,cleaveexpr,fullname)
            obj.shortname=shortname;
            obj.fullname=fullname;
            obj.cleaveexpr=cleaveexpr;
        end
    end
    
    methods(Static)
        function proteaselocaldb = mklocaldb
            proteaselocaldb = containers.Map;            
            proteasedb(1) = Protease('ARG-C','R','ARG-C PROTEINASE');
            proteasedb(2) = Protease('BNPS','W','BNPS-SKATOLE');
            proteasedb(3) = Protease('CASP1',  '(?<=[FWYL]\w[HAT])D(?=[^PEDQKR])',  'CASPASE 1');
            proteasedb(4)= Protease('CASP2',   '(?<=DVA)D(?=[^PEDQKR])',            'CASPASE 2');
            proteasedb(5) = Protease('CASP3',  '(?<=DMQ)D(?=[^PEDQKR])',            'CASPASE 3');
            proteasedb(6) = Protease('CASP4',  '(?<=LEV)D(?=[^PEDQKR])',            'CASPASE 4');
            proteasedb(7) = Protease('CASP5',   '(?<=[LW]EH)D',                      'CASPASE 5');
            proteasedb(8) = Protease('CASP6',   '(?<=VE[HI])D(?=[^PEDQKR])',         'CASPASE 6');
            proteasedb(9) = Protease('CASP7',   '(?<=DEV)D(?=[^PEDQKR])',            'CASPASE 7');
            proteasedb(10) = Protease('CASP8',  '(?<=[IL]ET)D(?=[^PEDQKR])',         'CASPASE 8');
            proteasedb(11)= Protease('CASP9',   '(?<=LEH)D',                         'CASPASE 9');
            proteasedb(12)= Protease('CASP10',  '(?<=IEA)D',                         'CASPASE 10');
            proteasedb(13) = Protease('CH-HI',   '([FY](?=[^P]))|(W(?=[^MP]))',       'CHYMOTRYPSIN-HIGH SPECIFICITY');
            proteasedb(14) = Protease('CH-LO',   '([FLY](?=[^P]))|(W(?=[^MP]))|(M(?=[^PY]))|(H(?=[^DMPW]))', 'CHYMOTRYPSIN-LOW SPECIFICITY');
            proteasedb(15) = Protease('CLOST',   'R',                        'CLOSTRIPAIN');
            proteasedb(16) = Protease('CNBR-o',    'M',                        'CNBR');
            proteasedb(17) = Protease('ENTKIN',  '(?<=[DN][DN][DN])K',       'ENTEROKINASE');
            proteasedb(18) = Protease('FACTXA',  '(?<=[AFGILTVM][DE]G)R',    'FACTOR XA');
            proteasedb(19) = Protease('FORMIC',  'D',                        'FORMIC ACID');
            proteasedb(20) = Protease('GluC',  'E',                        'GLUTAMYL ENDOPEPTIDASE');
            proteasedb(21) = Protease('GRANB',   '(?<=IEP)D',                'GRANZYME B');
            proteasedb(22)= Protease('HYDROX',  'N(?=G)',                   'HYDROXYLAMINE');
            proteasedb(23)= Protease('IODOB',   'W',                        'IODOSOBENZOIC ACID');
            proteasedb(24)= Protease('LYSC',    'K',                        'LYSC');
            proteasedb(25)= Protease('NTCB',   'C',                        'NTCB');
            proteasedb(26)= Protease('PEPS',   '((?<=[^HKR][^P])[^R](?=[FLWY][^P]))|((?<=[^HKR][^P])[FLWY](?=\w[^P]))',   'PEPSIN PH = 1.3');
            proteasedb(27)= Protease('PEPS2',   '((?<=[^HKR][^P])[^R](?=[FL][^P]))|((?<=[^HKR][^P])[FL](?=\w[^P]))',  'PEPSIN PH > 2');
            proteasedb(28) = Protease('PROEND', '(?<=[HKR])P(?=[^P])',      'PROLINE ENDOPEPTIDASE');
            proteasedb(29) = Protease('PROTK',   '[AEFILTVWY]',              'PROTEINASE K');
            proteasedb(30)= Protease('STAPHP',  '(?<=[^E])E',               'STAPHYLOCOCCAL PEPTIDASE I');
            proteasedb(31) = Protease('THERMO', '[^DE](?=[AFILMV])',        'THERMOLYSIN');
            proteasedb(32)= Protease('THROMB', '((?<=\w\wG)R(?=G))|((?<=[AFGILTVM][AFGILTVWA]P)R(?=[^DE][^DE]))', 'THROMBIN');
            proteasedb(33)= Protease('TRYP',  '((?<=\w)[KR](?=[^P]))|((?<=W)K(?=P))|((?<=M)R(?=P))', 'TRYPSIN');
            proteasedb(34)= Protease('ASP-N',  'D',                        'ASP-N ENDOPEPTIDASE');
            proteasedb(35)= Protease('Trypsin',  '[KR](?![P<])',                'TRYPSIN');
            proteasedb(36)= Protease('Lys-C',  '[K](?![P<])',                        'Lys-C');
            proteasedb(37)= Protease('Glu-C(V8 DE)',  '[DE](?!<)',                        'Glu-C V8 DE');
            proteasedb(38)= Protease('Glu-C(V8 E)',  '[E](?!<)',                        'Glu-C V8 E');
            proteasedb(39)= Protease('CNBR',  '[M](?!<)',                        'CNBR');
            proteasedb(40)= Protease('Chymotrypsin High',  '([FY](?=[^P<]))|(W(?=[^MP<]))',   'CHYMOTRYPSIN-HIGH SPECIFICITY');
            proteasedb(41)= Protease('Chymotrypsin Low',  '([FLY](?=[^P<]))|(W(?=[^MP<]))|(M(?=[^PY<]))|(H(?=[^DMPW<]))',   'CHYMOTRYPSIN-Low SPECIFICITY');
            
            numprot = length(proteasedb);
            for i = 1: numprot
                proteaselocaldb(upper(proteasedb(i).shortname))= proteasedb(i).cleaveexpr;
            end
        end
    end
    
    
end

