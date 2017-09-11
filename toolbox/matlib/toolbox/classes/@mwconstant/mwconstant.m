classdef mwconstant
      properties (Constant)
             %Hexose MW constant
             HexoseMonoUnde=162.0528;
             HexoseAvgUnde = 162.1424;
             HexoseMonoMethyl=204.0998;
             HexoseAvgMethyl = 204.2230;
             HexoseMonoAcetyl=288.0845;
             HexoseAvgAcetyl = 288.2542;
             
             %HexNAC MW constant
             HexNACMonoUnde=203.0794;
             HexNACAvgUnde = 203.1950;
             HexNACMonoMethyl=245.1263;
             HexNACAvgMethyl = 245.2756;
             HexNACMonoAcetyl=287.1005;
             HexNACAvgAcetyl =287.2695;
              
             %Deoxyhexose MW constant
             DeoHexMonoUnde=146.0579;
             DeoHexAvgUnde = 146.1430;
             DeoHexMonoMethyl=174.0892;
             DeoHexAvgMethyl = 174.1968 	;
             DeoHexMonoAcetyl=230.0790;
             DeoHexAvgAcetyl =230.2176;
             
             %Pentose MW constant
             PentoseMonoUnde=132.0423;
             PentoseAvgUnde = 132.1161;
             PentoseMonoMethyl=160.0736;
             PentoseAvgMethyl = 160.1699;
             PentoseMonoAcetyl=216.0634;
             PentoseAvgAcetyl =216.1907;
             
             %NeuAC MW constant
             NeuACMonoUnde=291.0954;
             NeuACAvgUnde =  	291.2579;
             NeuACMonoMethyl=361.1737;
             NeuACAvgMethyl = 361.3923 	;
             NeuACMonoAcetyl=417.1271;
             NeuACAvgAcetyl =417.3698; 
             
             %NeuGC MW constant
             NeuGCMonoUnde=307.0903;
             NeuGCAvgUnde =  	307.2573;
             NeuGCMonoMethyl = 391.1842;
             NeuGCAvgMethyl =391.4186;
             NeuGCMonoAcetyl=475.1326;
             NeuGCAvgAcetyl =475.4064; 
             
              %KDN MW constant
             KDNMonoUnde=250.0689;
             KDNAvgUnde =  	250.2053;
             KDNMonoMethyl = 320.1472;
             KDNAvgMethyl =320.3397;
             KDNMonoAcetyl=376.1006;
             KDNAvgAcetyl =376.3171; 
             
             %HEXA MW constant
             HexAMonoUnde   = 176.03209;
             HexAAvgUnde       = 176.1259 ;
             HexAMonoMethyl = 218.0790;
             HexAAvgMethyl     = 218.2066 ;
             HexAMonoAcetyl   =260.0532;
             HexAAvgAcetyl      =260.2005; 
              		 		 	
             %PHOS MW constant
             PhosMonoUnde    = 79.9663;
             PhosAvgUnde        = 79.9799 ;
             PhosMonoMethyl = 93.9820;
             PhosAvgMethyl     = 94.0068 	 ;
             PhosMonoAcetyl   =37.9558;
             PhosAvgAcetyl      = 37.9426; 
             
             %SULF MW constant
             SulfMonoUnde    =  79.9568;
             SulfAvgUnde        = 80.0642;
             SulfMonoMethyl =  65.9412;
             SulfAvgMethyl     = 66.0373;
             SulfMonoAcetyl   = 37.9463;
             SulfAvgAcetyl      = 38.0269; 
             
             % H 
             HionMono =1.00727 ;
             HionAvg =   1.00739;
             HMono =1.00783 ;
             HAvg =   1.00794;
             H2OMono = 18.01056;
             H2OAvg = 18.01524;
             
             % K,Na,TFA
             KionMono = 38.963707;
             KionAvg =39.0983;
             NaionMono =22.989768;
             NaionAvg = 22.998977;      
             TFAMono = 112.9850391;
             TFAAvg = 113.0160096;
             
             %redEnd
             redEnd =18.0105546;
             redEndMethyl = 46.0419;
             
             % HEX
             Hex             = struct('C',6,'H',10,'O',5,'N',0,'S',0,'P',0);
             HexNAC     = struct('C',8,'H',13,'O',5,'N',1,'S',0,'P',0);
             DeoHex      = struct('C',6,'H',10,'O',4,'N',0,'S',0,'P',0);
             NeuAC       = struct('C',11,'H',17,'O',9,'N',1,'S',0,'P',0);
             NeuGC       = struct('C',11,'H',19,'O',10,'N',1,'S',0,'P',0);        
             Pentose      = struct('C',5,'H',8,'O',4,'N',0,'S',0,'P',0);                           
             Sulf             = struct('C',0,'H',0,'O',3,'N',0,'S',1,'P',0);  
             Phos           = struct('C',0,'H',1,'O',3,'N',0,'S',0,'P',1);      
             HexA          = struct('C',6,'H',8,'O',6,'N',0,'S',0,'P',0);      
             KDN           = struct('C',9,'H',14,'O',8,'N',0,'S',0,'P',0); 
             
             redEndForm      = struct('C',0,'H',2,'O',1,'N',0,'S',0,'P',0); 
             redEndMethylForm      = struct('C',2,'H',6,'O',1,'N',0,'S',0,'P',0);  %+2(ch2)
             
             HexMethyl         = struct('C',9,'H',16,'O',5,'N',0,'S',0,'P',0)  ;             %   +3(CH2)  3C6H
             HexNACMethyl = struct('C',11,'H',19,'O',5,'N',1,'S',0,'P',0);     %   +3(CH2)  3C6H
             DeoHexMethyl  = struct('C',8,'H',14,'O',4,'N',0,'S',0,'P',0);    %  +2(CH2)  2C4H
             NeuACMethyl   = struct('C',16,'H',27,'O',8,'N',1,'S',0,'P',0);         %  +5(CH2)  5C10H
             
             % value below not correct leave
             NeuGCMethyl  = struct('C',16,'H',29,'O',9,'N',1,'S',0,'P',0);      
             PentoseMethyl = struct('C',16,'H',27,'O',8,'N',1,'S',0,'P',0);      
             SulfMethyl        = struct('C',16,'H',27,'O',8,'N',1,'S',0,'P',0);      
             PhosMethyl      = struct('C',16,'H',27,'O',8,'N',1,'S',0,'P',0);      
             KDNMethyl       = struct('C',16,'H',27,'O',8,'N',1,'S',0,'P',0);      
             HexAMethyl     =  struct('C',16,'H',27,'O',8,'N',1,'S',0,'P',0);      
      end
end