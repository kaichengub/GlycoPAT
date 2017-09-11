function xdot = UB1997Model(time, x_values)
% function UB1997Model.m takes
%
% either	1) no arguments
%       	    and returns a vector of the initial values
%
% or    	2) time - the elapsed time since the beginning of the reactions
%       	   x_values    - vector of the current values of the variables
%       	    and returns a vector of the rate of change of value of each of the variables
%
% UB1997Model.m can be used with MATLABs odeN functions as 
%
%	[t,x] = ode23(@UB1997Model.m, [0, t_end], UB1997Model.m)
%
%			where  t_end is the end time of the simulation
%
%The variables in this model are related to the output vectors with the following indices
%	Index	Variable name
%	  1  	  M9_cis
%	  2  	  M8_cis
%	  3  	  M7_cis
%	  4  	  M6_cis
%	  5  	  M5_cis
%	  6  	  M5Gn_cis
%	  7  	  M4Gn_cis
%	  8  	  M3Gn_cis
%	  9  	  M3Gn2_cis
%	  10  	  M3GnGnbG_cis
%	  11  	  M3GnGnb_cis
%	  12  	  M3GnG_cis
%	  13  	  M3Gn4GnbG_cis
%	  14  	  M3Gn4Gnb_cis
%	  15  	  M3Gn4G_cis
%	  16  	  M3Gn4_cis
%	  17  	  M3Gn3primeGnbG_cis
%	  18  	  M3Gn3primeGnb_cis
%	  19  	  M3Gn3primeG_cis
%	  20  	  M3Gn3prime_cis
%	  21  	  M3Gn3GnbG_cis
%	  22  	  M3Gn3Gnb_cis
%	  23  	  M3Gn3G_cis
%	  24  	  M3Gn3_cis
%	  25  	  M3Gn2GnbG_cis
%	  26  	  M3Gn2Gnb_cis
%	  27  	  M3Gn2G_cis
%	  28  	  M5GnGnbG_cis
%	  29  	  M5GnGnb_cis
%	  30  	  M5GnG_cis
%	  31  	  M4GnGnbG_cis
%	  32  	  M4GnGnb_cis
%	  33  	  M4GnG_cis
%	  34  	  M9_medial
%	  35  	  M8_medial
%	  36  	  M7_medial
%	  37  	  M6_medial
%	  38  	  M5_medial
%	  39  	  M5Gn_medial
%	  40  	  M4Gn_medial
%	  41  	  M3Gn_medial
%	  42  	  M3Gn2_medial
%	  43  	  M3GnGnbG_medial
%	  44  	  M3GnGnb_medial
%	  45  	  M3GnG_medial
%	  46  	  M3Gn4GnbG_medial
%	  47  	  M3Gn4Gnb_medial
%	  48  	  M3Gn4G_medial
%	  49  	  M3Gn4_medial
%	  50  	  M3Gn3primeGnbG_medial
%	  51  	  M3Gn3primeGnb_medial
%	  52  	  M3Gn3primeG_medial
%	  53  	  M3Gn3prime_medial
%	  54  	  M3Gn3GnbG_medial
%	  55  	  M3Gn3Gnb_medial
%	  56  	  M3Gn3G_medial
%	  57  	  M3Gn3_medial
%	  58  	  M3Gn2GnbG_medial
%	  59  	  M3Gn2Gnb_medial
%	  60  	  M3Gn2G_medial
%	  61  	  M5GnGnbG_medial
%	  62  	  M5GnGnb_medial
%	  63  	  M5GnG_medial
%	  64  	  M4GnGnbG_medial
%	  65  	  M4GnGnb_medial
%	  66  	  M4GnG_medial
%	  67  	  M9_trans
%	  68  	  M8_trans
%	  69  	  M7_trans
%	  70  	  M6_trans
%	  71  	  M5_trans
%	  72  	  M5Gn_trans
%	  73  	  M4Gn_trans
%	  74  	  M3Gn_trans
%	  75  	  M3Gn2_trans
%	  76  	  M3GnGnbG_trans
%	  77  	  M3GnGnb_trans
%	  78  	  M3GnG_trans
%	  79  	  M3Gn4GnbG_trans
%	  80  	  M3Gn4Gnb_trans
%	  81  	  M3Gn4G_trans
%	  82  	  M3Gn4_trans
%	  83  	  M3Gn3primeGnbG_trans
%	  84  	  M3Gn3primeGnb_trans
%	  85  	  M3Gn3primeG_trans
%	  86  	  M3Gn3prime_trans
%	  87  	  M3Gn3GnbG_trans
%	  88  	  M3Gn3Gnb_trans
%	  89  	  M3Gn3G_trans
%	  90  	  M3Gn3_trans
%	  91  	  M3Gn2GnbG_trans
%	  92  	  M3Gn2Gnb_trans
%	  93  	  M3Gn2G_trans
%	  94  	  M5GnGnbG_trans
%	  95  	  M5GnGnb_trans
%	  96  	  M5GnG_trans
%	  97  	  M4GnGnbG_trans
%	  98  	  M4GnGnb_trans
%	  99  	  M4GnG_trans
%	  100  	  M9_tgn
%	  101  	  M8_tgn
%	  102  	  M7_tgn
%	  103  	  M6_tgn
%	  104  	  M5_tgn
%	  105  	  M5Gn_tgn
%	  106  	  M4Gn_tgn
%	  107  	  M3Gn_tgn
%	  108  	  M3Gn2_tgn
%	  109  	  M3GnGnbG_tgn
%	  110  	  M3GnGnb_tgn
%	  111  	  M3GnG_tgn
%	  112  	  M3Gn4GnbG_tgn
%	  113  	  M3Gn4Gnb_tgn
%	  114  	  M3Gn4G_tgn
%	  115  	  M3Gn4_tgn
%	  116  	  M3Gn3primeGnbG_tgn
%	  117  	  M3Gn3primeGnb_tgn
%	  118  	  M3Gn3primeG_tgn
%	  119  	  M3Gn3prime_tgn
%	  120  	  M3Gn3GnbG_tgn
%	  121  	  M3Gn3Gnb_tgn
%	  122  	  M3Gn3G_tgn
%	  123  	  M3Gn3_tgn
%	  124  	  M3Gn2GnbG_tgn
%	  125  	  M3Gn2Gnb_tgn
%	  126  	  M3Gn2G_tgn
%	  127  	  M5GnGnbG_tgn
%	  128  	  M5GnGnb_tgn
%	  129  	  M5GnG_tgn
%	  130  	  M4GnGnbG_tgn
%	  131  	  M4GnGnb_tgn
%	  132  	  M4GnG_tgn
%
%--------------------------------------------------------
% output vector

xdot = zeros(132, 1);

%--------------------------------------------------------
% compartment values

Global_cis_medial_trans_tgn_4compts = 1;

%--------------------------------------------------------
% parameter values

kt = 1;
alpha = 0.5;
vm1 = 300;
vm2 = 300;
vm3 = 300;
vm4 = 300;
vm5 = 450;
vm6 = 300;
vm7 = 300;
vm8 = 140;
vm9 = 10;
vm10 = 10;
vm11 = 10;
vm12 = 10;
vm13 = 580;
vm14 = 580;
vm15 = 580;
vm16 = 580;
vm17 = 580;
vm18 = 580;
vm19 = 580;
vm20 = 0;
vm21 = 0;
vm22 = 0;
vm23 = 0;
vm24 = 0;
vm25 = 0;
vm26 = 0;
vm27 = 580;
vm28 = 580;
vm29 = 580;
vm30 = 580;
vm31 = 580;
vm32 = 580;
vm33 = 580;
km1 = 1e+08;
km2 = 1e+08;
km3 = 1e+08;
km4 = 1e+08;
km5 = 2.6e+08;
km6 = 2e+08;
km7 = 1e+08;
km8 = 1.9e+08;
km9 = 1.3e+08;
km10 = 3.4e+09;
km11 = 3.4e+09;
km12 = 9e+07;
km13 = 4e+09;
km14 = 4e+09;
km15 = 4e+09;
km16 = 1.3e+08;
km17 = 7e+07;
km18 = 5e+07;
km19 = 4e+07;
km20 = 4e+09;
km21 = 4e+09;
km22 = 4e+09;
km23 = 1.9e+08;
km24 = 1.9e+08;
km25 = 1.9e+08;
km27 = 4e+09;
km28 = 4e+09;
km29 = 4e+09;
km30 = 5e+08;
km31 = 2.2e+08;
km32 = 2e+08;
km33 = 1.4e+08;
ManI_cis = 0.15;
ManI_trans = 0.3;
ManI_medial = 0.45;
ManI_tgn = 0.1;
ManII_cis = 0.15;
ManII_trans = 0.3;
ManII_medial = 0.45;
ManII_tgn = 0.1;
GNT1_cis = 0.15;
GNT1_trans = 0.3;
GNT1_medial = 0.45;
GNT1_tgn = 0.1;
GNT2_cis = 0.15;
GNT2_trans = 0.3;
GNT2_medial = 0.45;
GNT2_tgn = 0.1;
GNT3_cis = 0.15;
GNT3_trans = 0.3;
GNT3_medial = 0.45;
GNT3_tgn = 0.1;
GNT4_cis = 0.15;
GNT4_trans = 0.3;
GNT4_medial = 0.45;
GNT4_tgn = 0.1;
GNT5_cis = 0.15;
GNT5_trans = 0.3;
GNT5_medial = 0.45;
GNT5_tgn = 0.1;
GALT_cis = 0;
GALT_trans = 0.2;
GALT_medial = 0.05;
GALT_tgn = 0.75;
km26 = 1.9e+08;
qp = 1;
kg = 259.2;
vg = 2.5e-09;

%--------------------------------------------------------
% initial values of variables - these may be overridden by assignment rules
% NOTE: any use of initialAssignments has been considered in calculating the initial values

if (nargin == 0)

	% initial time
	time = 0;

	% initial values
	M9_cis = 0.5/Global_cis_medial_trans_tgn_4compts;
	M8_cis = 0.5/Global_cis_medial_trans_tgn_4compts;
	M7_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M6_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M5_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M5Gn_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M4Gn_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4GnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4Gnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4G_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3prime_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3GnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3Gnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3G_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2GnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2Gnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2G_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnbG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnb_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnG_cis = 0/Global_cis_medial_trans_tgn_4compts;
	M9_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M8_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M7_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M6_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M5_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M5Gn_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M4Gn_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4GnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4Gnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4G_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3prime_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3GnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3Gnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3G_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2GnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2Gnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2G_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnbG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnb_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnG_medial = 0/Global_cis_medial_trans_tgn_4compts;
	M9_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M8_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M7_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M6_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M5_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M5Gn_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M4Gn_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4GnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4Gnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4G_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3prime_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3GnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3Gnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3G_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2GnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2Gnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2G_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnbG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnb_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnG_trans = 0/Global_cis_medial_trans_tgn_4compts;
	M9_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M8_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M7_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M6_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M5_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M5Gn_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M4Gn_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnGnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3GnG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4GnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4Gnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4G_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn4_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeGnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3primeG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3prime_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3GnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3Gnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3G_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn3_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2GnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2Gnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M3Gn2G_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnGnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M5GnG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnbG_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnGnb_tgn = 0/Global_cis_medial_trans_tgn_4compts;
	M4GnG_tgn = 0/Global_cis_medial_trans_tgn_4compts;

else
	% floating variable values
	M9_cis = x_values(1);
	M8_cis = x_values(2);
	M7_cis = x_values(3);
	M6_cis = x_values(4);
	M5_cis = x_values(5);
	M5Gn_cis = x_values(6);
	M4Gn_cis = x_values(7);
	M3Gn_cis = x_values(8);
	M3Gn2_cis = x_values(9);
	M3GnGnbG_cis = x_values(10);
	M3GnGnb_cis = x_values(11);
	M3GnG_cis = x_values(12);
	M3Gn4GnbG_cis = x_values(13);
	M3Gn4Gnb_cis = x_values(14);
	M3Gn4G_cis = x_values(15);
	M3Gn4_cis = x_values(16);
	M3Gn3primeGnbG_cis = x_values(17);
	M3Gn3primeGnb_cis = x_values(18);
	M3Gn3primeG_cis = x_values(19);
	M3Gn3prime_cis = x_values(20);
	M3Gn3GnbG_cis = x_values(21);
	M3Gn3Gnb_cis = x_values(22);
	M3Gn3G_cis = x_values(23);
	M3Gn3_cis = x_values(24);
	M3Gn2GnbG_cis = x_values(25);
	M3Gn2Gnb_cis = x_values(26);
	M3Gn2G_cis = x_values(27);
	M5GnGnbG_cis = x_values(28);
	M5GnGnb_cis = x_values(29);
	M5GnG_cis = x_values(30);
	M4GnGnbG_cis = x_values(31);
	M4GnGnb_cis = x_values(32);
	M4GnG_cis = x_values(33);
	M9_medial = x_values(34);
	M8_medial = x_values(35);
	M7_medial = x_values(36);
	M6_medial = x_values(37);
	M5_medial = x_values(38);
	M5Gn_medial = x_values(39);
	M4Gn_medial = x_values(40);
	M3Gn_medial = x_values(41);
	M3Gn2_medial = x_values(42);
	M3GnGnbG_medial = x_values(43);
	M3GnGnb_medial = x_values(44);
	M3GnG_medial = x_values(45);
	M3Gn4GnbG_medial = x_values(46);
	M3Gn4Gnb_medial = x_values(47);
	M3Gn4G_medial = x_values(48);
	M3Gn4_medial = x_values(49);
	M3Gn3primeGnbG_medial = x_values(50);
	M3Gn3primeGnb_medial = x_values(51);
	M3Gn3primeG_medial = x_values(52);
	M3Gn3prime_medial = x_values(53);
	M3Gn3GnbG_medial = x_values(54);
	M3Gn3Gnb_medial = x_values(55);
	M3Gn3G_medial = x_values(56);
	M3Gn3_medial = x_values(57);
	M3Gn2GnbG_medial = x_values(58);
	M3Gn2Gnb_medial = x_values(59);
	M3Gn2G_medial = x_values(60);
	M5GnGnbG_medial = x_values(61);
	M5GnGnb_medial = x_values(62);
	M5GnG_medial = x_values(63);
	M4GnGnbG_medial = x_values(64);
	M4GnGnb_medial = x_values(65);
	M4GnG_medial = x_values(66);
	M9_trans = x_values(67);
	M8_trans = x_values(68);
	M7_trans = x_values(69);
	M6_trans = x_values(70);
	M5_trans = x_values(71);
	M5Gn_trans = x_values(72);
	M4Gn_trans = x_values(73);
	M3Gn_trans = x_values(74);
	M3Gn2_trans = x_values(75);
	M3GnGnbG_trans = x_values(76);
	M3GnGnb_trans = x_values(77);
	M3GnG_trans = x_values(78);
	M3Gn4GnbG_trans = x_values(79);
	M3Gn4Gnb_trans = x_values(80);
	M3Gn4G_trans = x_values(81);
	M3Gn4_trans = x_values(82);
	M3Gn3primeGnbG_trans = x_values(83);
	M3Gn3primeGnb_trans = x_values(84);
	M3Gn3primeG_trans = x_values(85);
	M3Gn3prime_trans = x_values(86);
	M3Gn3GnbG_trans = x_values(87);
	M3Gn3Gnb_trans = x_values(88);
	M3Gn3G_trans = x_values(89);
	M3Gn3_trans = x_values(90);
	M3Gn2GnbG_trans = x_values(91);
	M3Gn2Gnb_trans = x_values(92);
	M3Gn2G_trans = x_values(93);
	M5GnGnbG_trans = x_values(94);
	M5GnGnb_trans = x_values(95);
	M5GnG_trans = x_values(96);
	M4GnGnbG_trans = x_values(97);
	M4GnGnb_trans = x_values(98);
	M4GnG_trans = x_values(99);
	M9_tgn = x_values(100);
	M8_tgn = x_values(101);
	M7_tgn = x_values(102);
	M6_tgn = x_values(103);
	M5_tgn = x_values(104);
	M5Gn_tgn = x_values(105);
	M4Gn_tgn = x_values(106);
	M3Gn_tgn = x_values(107);
	M3Gn2_tgn = x_values(108);
	M3GnGnbG_tgn = x_values(109);
	M3GnGnb_tgn = x_values(110);
	M3GnG_tgn = x_values(111);
	M3Gn4GnbG_tgn = x_values(112);
	M3Gn4Gnb_tgn = x_values(113);
	M3Gn4G_tgn = x_values(114);
	M3Gn4_tgn = x_values(115);
	M3Gn3primeGnbG_tgn = x_values(116);
	M3Gn3primeGnb_tgn = x_values(117);
	M3Gn3primeG_tgn = x_values(118);
	M3Gn3prime_tgn = x_values(119);
	M3Gn3GnbG_tgn = x_values(120);
	M3Gn3Gnb_tgn = x_values(121);
	M3Gn3G_tgn = x_values(122);
	M3Gn3_tgn = x_values(123);
	M3Gn2GnbG_tgn = x_values(124);
	M3Gn2Gnb_tgn = x_values(125);
	M3Gn2G_tgn = x_values(126);
	M5GnGnbG_tgn = x_values(127);
	M5GnGnb_tgn = x_values(128);
	M5GnG_tgn = x_values(129);
	M4GnGnbG_tgn = x_values(130);
	M4GnGnb_tgn = x_values(131);
	M4GnG_tgn = x_values(132);

end;

%--------------------------------------------------------
% assignment rules

%--------------------------------------------------------
% algebraic rules

%--------------------------------------------------------
% calculate concentration values

if (nargin == 0)

	% initial values
	xdot(1) = 0.5/Global_cis_medial_trans_tgn_4compts;
	xdot(2) = 0.5/Global_cis_medial_trans_tgn_4compts;
	xdot(3) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(4) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(5) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(6) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(7) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(8) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(9) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(10) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(11) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(12) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(13) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(14) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(15) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(16) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(17) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(18) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(19) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(20) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(21) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(22) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(23) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(24) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(25) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(26) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(27) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(28) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(29) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(30) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(31) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(32) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(33) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(34) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(35) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(36) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(37) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(38) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(39) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(40) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(41) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(42) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(43) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(44) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(45) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(46) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(47) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(48) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(49) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(50) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(51) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(52) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(53) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(54) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(55) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(56) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(57) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(58) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(59) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(60) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(61) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(62) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(63) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(64) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(65) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(66) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(67) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(68) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(69) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(70) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(71) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(72) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(73) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(74) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(75) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(76) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(77) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(78) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(79) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(80) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(81) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(82) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(83) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(84) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(85) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(86) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(87) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(88) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(89) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(90) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(91) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(92) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(93) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(94) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(95) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(96) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(97) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(98) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(99) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(100) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(101) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(102) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(103) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(104) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(105) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(106) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(107) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(108) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(109) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(110) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(111) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(112) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(113) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(114) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(115) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(116) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(117) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(118) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(119) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(120) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(121) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(122) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(123) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(124) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(125) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(126) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(127) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(128) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(129) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(130) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(131) = 0/Global_cis_medial_trans_tgn_4compts;
	xdot(132) = 0/Global_cis_medial_trans_tgn_4compts;

else

	% rate equations
	xdot(1) = ( - (vm1/qp*24*M9_cis*ManI_cis/km1/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) + (alpha) - (kt*M9_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(2) = ( + (vm1/qp*24*M9_cis*ManI_cis/km1/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) - (vm2/qp*24*M8_cis*ManI_cis/km2/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) + (1-alpha) - (kt*M8_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(3) = ( + (vm2/qp*24*M8_cis*ManI_cis/km2/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) - (vm3/qp*24*M7_cis/km3*ManI_cis/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) + (0) - (kt*M7_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(4) = ( + (vm3/qp*24*M7_cis/km3*ManI_cis/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) - (vm4/qp*24*M6_cis*ManI_cis/km4/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) + (0) - (kt*M6_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(5) = ( + (vm4/qp*24*M6_cis*ManI_cis/km4/(kg*vg/qp+M9_cis/km1+M8_cis/km2+M7_cis/km3+M6_cis/km4)) - (vm5/qp*24*GNT1_cis*M5_cis/km5/(kg*vg/qp+M5_cis/km5)) + (0) - (kt*M5_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(6) = ( + (vm5/qp*24*GNT1_cis*M5_cis/km5/(kg*vg/qp+M5_cis/km5)) - (vm6/qp*24*M5Gn_cis*ManII_cis/km6/(kg*vg/qp+M5Gn_cis/km6+M4Gn_cis/km7)) - (vm13/qp*24*M5Gn_cis*GALT_cis/km13/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm20/qp*24*M5Gn_cis*GNT3_cis/km20/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M5Gn_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(7) = ( + (vm6/qp*24*M5Gn_cis*ManII_cis/km6/(kg*vg/qp+M5Gn_cis/km6+M4Gn_cis/km7)) - (vm7/qp*24*M4Gn_cis*ManII_cis/km7/(kg*vg/qp+M5Gn_cis/km6+M4Gn_cis/km7)) - (vm14/qp*24*M4Gn_cis*GALT_cis/km14/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm21/qp*24*M4Gn_cis*GNT3_cis/km21/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M4Gn_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(8) = ( + (vm7/qp*24*M4Gn_cis*ManII_cis/km7/(kg*vg/qp+M5Gn_cis/km6+M4Gn_cis/km7)) - (vm8/qp*24*GNT2_cis*M3Gn_cis/km8/(kg*vg/qp+M3Gn_cis/km8)) - (vm15/qp*24*M3Gn_cis*GALT_cis/km15/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm22/qp*24*M3Gn_cis*GNT3_cis/km22/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M3Gn_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(9) = ( + (vm8/qp*24*GNT2_cis*M3Gn_cis/km8/(kg*vg/qp+M3Gn_cis/km8)) - (vm9/qp*24*M3Gn2_cis*GNT5_cis/km9/(kg*vg/qp+M3Gn2_cis/km9+M3Gn3_cis/km12)) - (vm10/qp*24*M3Gn2_cis*GNT4_cis/km10/(kg*vg/qp+M3Gn2_cis/km10+M3Gn3prime_cis/km11)) - (vm16/qp*24*M3Gn2_cis*GALT_cis/km16/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm23/qp*24*M3Gn2_cis*GNT3_cis/km23/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M3Gn2_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(10) = ( + (vm29/qp*24*M3GnGnb_cis*GALT_cis/km29/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3GnGnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(11) = ( + (vm22/qp*24*M3Gn_cis*GNT3_cis/km22/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm29/qp*24*M3GnGnb_cis*GALT_cis/km29/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3GnGnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(12) = ( + (vm15/qp*24*M3Gn_cis*GALT_cis/km15/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3GnG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(13) = ( + (vm33/qp*24*M3Gn4Gnb_cis*GALT_cis/km33/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn4GnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(14) = ( + (vm26/qp*24*M3Gn4_cis*GNT3_cis/km26/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm33/qp*24*M3Gn4Gnb_cis*GALT_cis/km33/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn4Gnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(15) = ( + (vm19/qp*24*M3Gn4_cis*GALT_cis/km19/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn4G_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(16) = ( + (vm11/qp*24*M3Gn3prime_cis*GNT4_cis/km11/(kg*vg/qp+M3Gn2_cis/km10+M3Gn3prime_cis/km11)) + (vm12/qp*24*M3Gn3_cis*GNT5_cis/km12/(kg*vg/qp+M3Gn2_cis/km9+M3Gn3_cis/km12)) - (vm19/qp*24*M3Gn4_cis*GALT_cis/km19/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm26/qp*24*M3Gn4_cis*GNT3_cis/km26/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M3Gn4_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(17) = ( + (vm31/qp*24*M3Gn3primeGnb_cis*GALT_cis/km31/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn3primeGnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(18) = ( + (vm24/qp*24*M3Gn3prime_cis*GNT3_cis/km24/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm31/qp*24*M3Gn3primeGnb_cis*GALT_cis/km31/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn3primeGnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(19) = ( + (vm17/qp*24*M3Gn3prime_cis*GALT_cis/km17/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn3primeG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(20) = ( + (vm9/qp*24*M3Gn2_cis*GNT5_cis/km9/(kg*vg/qp+M3Gn2_cis/km9+M3Gn3_cis/km12)) - (vm11/qp*24*M3Gn3prime_cis*GNT4_cis/km11/(kg*vg/qp+M3Gn2_cis/km10+M3Gn3prime_cis/km11)) - (vm17/qp*24*M3Gn3prime_cis*GALT_cis/km17/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm24/qp*24*M3Gn3prime_cis*GNT3_cis/km24/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M3Gn3prime_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(21) = ( + (vm32/qp*24*M3Gn3Gnb_cis*GALT_cis/km32/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn3GnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(22) = ( + (vm25/qp*24*M3Gn3_cis*GNT3_cis/km25/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm32/qp*24*M3Gn3Gnb_cis*GALT_cis/km32/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn3Gnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(23) = ( + (vm18/qp*24*M3Gn3_cis*GALT_cis/km18/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn3G_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(24) = ( + (vm10/qp*24*M3Gn2_cis*GNT4_cis/km10/(kg*vg/qp+M3Gn2_cis/km10+M3Gn3prime_cis/km11)) - (vm12/qp*24*M3Gn3_cis*GNT5_cis/km12/(kg*vg/qp+M3Gn2_cis/km9+M3Gn3_cis/km12)) - (vm18/qp*24*M3Gn3_cis*GALT_cis/km18/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) - (vm25/qp*24*M3Gn3_cis*GNT3_cis/km25/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) + (0) - (kt*M3Gn3_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(25) = ( + (vm30/qp*24*M3Gn2Gnb_cis*GALT_cis/km30/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn2GnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(26) = ( + (vm23/qp*24*M3Gn2_cis*GNT3_cis/km23/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm30/qp*24*M3Gn2Gnb_cis*GALT_cis/km30/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn2Gnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(27) = ( + (vm16/qp*24*M3Gn2_cis*GALT_cis/km16/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M3Gn2G_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(28) = ( + (vm27/qp*24*M5GnGnb_cis*GALT_cis/km27/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M5GnGnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(29) = ( + (vm20/qp*24*M5Gn_cis*GNT3_cis/km20/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm27/qp*24*M5GnGnb_cis*GALT_cis/km27/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M5GnGnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(30) = ( + (vm13/qp*24*M5Gn_cis*GALT_cis/km13/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M5GnG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(31) = ( + (vm28/qp*24*M4GnGnb_cis*GALT_cis/km28/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M4GnGnbG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(32) = ( + (vm21/qp*24*M4Gn_cis*GNT3_cis/km21/(kg*vg/qp+M5Gn_cis/km20+M4Gn_cis/km21+M3Gn_cis/km22+M3Gn2_cis/km23+M3Gn3prime_cis/km24+M3Gn3_cis/km25+M3Gn4_cis/km26)) - (vm28/qp*24*M4GnGnb_cis*GALT_cis/km28/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M4GnGnb_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(33) = ( + (vm14/qp*24*M4Gn_cis*GALT_cis/km14/(kg*vg/qp+M5Gn_cis/km13+M4Gn_cis/km14+M3Gn_cis/km15+M3Gn2_cis/km16+M3Gn3prime_cis/km17+M3Gn3_cis/km18+M3Gn4_cis/km19+M5GnGnb_cis/km27+M4GnGnb_cis/km28+M3GnGnb_cis/km29+M3Gn2Gnb_cis/km30+M3Gn3primeGnb_cis/km31+M3Gn3Gnb_cis/km32+M3Gn4Gnb_cis/km33)) + (0) - (kt*M4GnG_cis))/Global_cis_medial_trans_tgn_4compts;
	xdot(34) = ( - (vm1/qp*24*ManI_medial*M9_medial/km1/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) + (kt*M9_cis) - (kt*M9_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(35) = ( + (vm1/qp*24*ManI_medial*M9_medial/km1/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) - (vm2/qp*24*ManI_medial*M8_medial/km2/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) + (kt*M8_cis) - (kt*M8_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(36) = ( + (vm2/qp*24*ManI_medial*M8_medial/km2/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) - (vm3/qp*24*ManI_medial*M7_medial/km3/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) + (kt*M7_cis) - (kt*M7_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(37) = ( + (vm3/qp*24*ManI_medial*M7_medial/km3/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) - (vm4/qp*24*ManI_medial*M6_medial/km4/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) + (kt*M6_cis) - (kt*M6_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(38) = ( + (vm4/qp*24*ManI_medial*M6_medial/km4/(kg*vg/qp+M9_medial/km1+M8_medial/km2+M7_medial/km3+M6_medial/km4)) - (vm5/qp*24*GNT1_medial*M5_medial/km5/(kg*vg/qp+M5_medial/km5)) + (kt*M5_cis) - (kt*M5_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(39) = ( + (vm5/qp*24*GNT1_medial*M5_medial/km5/(kg*vg/qp+M5_medial/km5)) - (vm6/qp*24*M5Gn_medial*ManII_medial/km6/(kg*vg/qp+M5Gn_medial/km6+M4Gn_medial/km7)) - (vm13/qp*24*M5Gn_medial*GALT_medial/km13/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm20/qp*24*M5Gn_medial*GNT3_medial/km20/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M5Gn_cis) - (kt*M5Gn_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(40) = ( + (vm6/qp*24*M5Gn_medial*ManII_medial/km6/(kg*vg/qp+M5Gn_medial/km6+M4Gn_medial/km7)) - (vm7/qp*24*M4Gn_medial*ManII_medial/km7/(kg*vg/qp+M5Gn_medial/km6+M4Gn_medial/km7)) - (vm14/qp*24*M4Gn_medial*GALT_medial/km14/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm21/qp*24*M4Gn_medial*GNT3_medial/km21/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M4Gn_cis) - (kt*M4Gn_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(41) = ( + (vm7/qp*24*M4Gn_medial*ManII_medial/km7/(kg*vg/qp+M5Gn_medial/km6+M4Gn_medial/km7)) - (vm8/qp*24*GNT2_medial*M3Gn_medial/km8/(kg*vg/qp+M3Gn_medial/km8)) - (vm15/qp*24*M3Gn_medial*GALT_medial/km15/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm22/qp*24*M3Gn_medial*GNT3_medial/km22/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M3Gn_cis) - (kt*M3Gn_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(42) = ( + (vm8/qp*24*GNT2_medial*M3Gn_medial/km8/(kg*vg/qp+M3Gn_medial/km8)) - (vm9/qp*24*M3Gn2_medial*GNT5_medial/km9/(kg*vg/qp+M3Gn2_medial/km9+M3Gn3_medial/km12)) - (vm10/qp*24*M3Gn2_medial*GNT4_medial/km10/(kg*vg/qp+M3Gn2_medial/km10+M3Gn3prime_medial/km11)) - (vm16/qp*24*M3Gn2_medial*GALT_medial/km16/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm23/qp*24*M3Gn2_medial*GNT3_medial/km23/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M3Gn2_cis) - (kt*M3Gn2_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(43) = ( + (vm29/qp*24*M3GnGnb_medial*GALT_medial/km29/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3GnGnbG_cis) - (kt*M3GnGnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(44) = ( + (vm22/qp*24*M3Gn_medial*GNT3_medial/km22/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm29/qp*24*M3GnGnb_medial*GALT_medial/km29/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3GnGnb_cis) - (kt*M3GnGnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(45) = ( + (vm15/qp*24*M3Gn_medial*GALT_medial/km15/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3GnG_cis) - (kt*M3GnG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(46) = ( + (vm33/qp*24*M3Gn4Gnb_medial*GALT_medial/km33/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn4GnbG_cis) - (kt*M3Gn4GnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(47) = ( + (vm26/qp*24*M3Gn4_medial*GNT3_medial/km26/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm33/qp*24*M3Gn4Gnb_medial*GALT_medial/km33/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn4Gnb_cis) - (kt*M3Gn4Gnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(48) = ( + (vm19/qp*24*M3Gn4_medial*GALT_medial/km19/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn4G_cis) - (kt*M3Gn4G_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(49) = ( + (vm11/qp*24*M3Gn3prime_medial*GNT4_medial/km11/(kg*vg/qp+M3Gn2_medial/km10+M3Gn3prime_medial/km11)) + (vm12/qp*24*M3Gn3_medial*GNT5_medial/km12/(kg*vg/qp+M3Gn2_medial/km9+M3Gn3_medial/km12)) - (vm19/qp*24*M3Gn4_medial*GALT_medial/km19/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm26/qp*24*M3Gn4_medial*GNT3_medial/km26/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M3Gn4_cis) - (kt*M3Gn4_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(50) = ( + (vm31/qp*24*M3Gn3primeGnb_medial*GALT_medial/km31/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn3primeGnbG_cis) - (kt*M3Gn3primeGnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(51) = ( + (vm24/qp*24*M3Gn3prime_medial*GNT3_medial/km24/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm31/qp*24*M3Gn3primeGnb_medial*GALT_medial/km31/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn3primeGnb_cis) - (kt*M3Gn3primeGnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(52) = ( + (vm17/qp*24*M3Gn3prime_medial*GALT_medial/km17/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn3primeG_cis) - (kt*M3Gn3primeG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(53) = ( + (vm9/qp*24*M3Gn2_medial*GNT5_medial/km9/(kg*vg/qp+M3Gn2_medial/km9+M3Gn3_medial/km12)) - (vm11/qp*24*M3Gn3prime_medial*GNT4_medial/km11/(kg*vg/qp+M3Gn2_medial/km10+M3Gn3prime_medial/km11)) - (vm17/qp*24*M3Gn3prime_medial*GALT_medial/km17/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm24/qp*24*M3Gn3prime_medial*GNT3_medial/km24/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M3Gn3prime_cis) - (kt*M3Gn3prime_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(54) = ( + (vm32/qp*24*M3Gn3Gnb_medial*GALT_medial/km32/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn3GnbG_cis) - (kt*M3Gn3GnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(55) = ( + (vm25/qp*24*M3Gn3_medial*GNT3_medial/km25/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm32/qp*24*M3Gn3Gnb_medial*GALT_medial/km32/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn3Gnb_cis) - (kt*M3Gn3Gnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(56) = ( + (vm18/qp*24*M3Gn3_medial*GALT_medial/km18/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn3G_cis) - (kt*M3Gn3G_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(57) = ( + (vm10/qp*24*M3Gn2_medial*GNT4_medial/km10/(kg*vg/qp+M3Gn2_medial/km10+M3Gn3prime_medial/km11)) - (vm12/qp*24*M3Gn3_medial*GNT5_medial/km12/(kg*vg/qp+M3Gn2_medial/km9+M3Gn3_medial/km12)) - (vm18/qp*24*M3Gn3_medial*GALT_medial/km18/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) - (vm25/qp*24*M3Gn3_medial*GNT3_medial/km25/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) + (kt*M3Gn3_cis) - (kt*M3Gn3_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(58) = ( + (vm30/qp*24*M3Gn2Gnb_medial*GALT_medial/km30/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn2GnbG_cis) - (kt*M3Gn2GnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(59) = ( + (vm23/qp*24*M3Gn2_medial*GNT3_medial/km23/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm30/qp*24*M3Gn2Gnb_medial*GALT_medial/km30/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn2Gnb_cis) - (kt*M3Gn2Gnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(60) = ( + (vm16/qp*24*M3Gn2_medial*GALT_medial/km16/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M3Gn2G_cis) - (kt*M3Gn2G_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(61) = ( + (vm27/qp*24*M5GnGnb_medial*GALT_medial/km27/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M5GnGnbG_cis) - (kt*M5GnGnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(62) = ( + (vm20/qp*24*M5Gn_medial*GNT3_medial/km20/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm27/qp*24*M5GnGnb_medial*GALT_medial/km27/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M5GnGnb_cis) - (kt*M5GnGnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(63) = ( + (vm13/qp*24*M5Gn_medial*GALT_medial/km13/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M5GnG_cis) - (kt*M5GnG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(64) = ( + (vm28/qp*24*M4GnGnb_medial*GALT_medial/km28/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M4GnGnbG_cis) - (kt*M4GnGnbG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(65) = ( + (vm21/qp*24*M4Gn_medial*GNT3_medial/km21/(kg*vg/qp+M5Gn_medial/km20+M4Gn_medial/km21+M3Gn_medial/km22+M3Gn2_medial/km23+M3Gn3prime_medial/km24+M3Gn3_medial/km25+M3Gn4_medial/km26)) - (vm28/qp*24*M4GnGnb_medial*GALT_medial/km28/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M4GnGnb_cis) - (kt*M4GnGnb_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(66) = ( + (vm14/qp*24*M4Gn_medial*GALT_medial/km14/(kg*vg/qp+M5Gn_medial/km13+M4Gn_medial/km14+M3Gn_medial/km15+M3Gn2_medial/km16+M3Gn3prime_medial/km17+M3Gn3_medial/km18+M3Gn4_medial/km19+M5GnGnb_medial/km27+M4GnGnb_medial/km28+M3GnGnb_medial/km29+M3Gn2Gnb_medial/km30+M3Gn3primeGnb_medial/km31+M3Gn3Gnb_medial/km32+M3Gn4Gnb_medial/km33)) + (kt*M4GnG_cis) - (kt*M4GnG_medial))/Global_cis_medial_trans_tgn_4compts;
	xdot(67) = ( - (vm1/qp*24*M9_trans*ManI_trans/km1/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) + (kt*M9_medial) - (kt*M9_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(68) = ( + (vm1/qp*24*M9_trans*ManI_trans/km1/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) - (vm2/qp*24*M8_trans*ManI_trans/km2/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) + (kt*M8_medial) - (kt*M8_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(69) = ( + (vm2/qp*24*M8_trans*ManI_trans/km2/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) - (vm3/qp*24*M7_trans/km3*ManI_trans/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) + (kt*M7_medial) - (kt*M7_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(70) = ( + (vm3/qp*24*M7_trans/km3*ManI_trans/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) - (vm4/qp*24*M6_trans/km4*ManI_trans/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) + (kt*M6_medial) - (kt*M6_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(71) = ( + (vm4/qp*24*M6_trans/km4*ManI_trans/(kg*vg/qp+M9_trans/km1+M8_trans/km2+M7_trans/km3+M6_trans/km4)) - (vm5/qp*24*GNT1_trans*M5_trans/km5/(kg*vg/qp+M5_trans/km5)) + (kt*M5_medial) - (kt*M5_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(72) = ( + (vm5/qp*24*GNT1_trans*M5_trans/km5/(kg*vg/qp+M5_trans/km5)) - (vm6/qp*24*M5Gn_trans*ManII_trans/km6/(kg*vg/qp+M5Gn_trans/km6+M4Gn_trans/km7)) - (vm13/qp*24*M5Gn_trans*GALT_trans/km13/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm20/qp*24*M5Gn_trans*GNT3_trans/km20/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M5Gn_medial) - (kt*M5Gn_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(73) = ( + (vm6/qp*24*M5Gn_trans*ManII_trans/km6/(kg*vg/qp+M5Gn_trans/km6+M4Gn_trans/km7)) - (vm7/qp*24*M4Gn_trans*ManII_trans/km7/(kg*vg/qp+M5Gn_trans/km6+M4Gn_trans/km7)) - (vm14/qp*24*M4Gn_trans*GALT_trans/km14/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm21/qp*24*M4Gn_trans*GNT3_trans/km21/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M4Gn_medial) - (kt*M4Gn_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(74) = ( + (vm7/qp*24*M4Gn_trans*ManII_trans/km7/(kg*vg/qp+M5Gn_trans/km6+M4Gn_trans/km7)) - (vm8/qp*24*GNT2_trans*M3Gn_trans/km8/(kg*vg/qp+M3Gn_trans/km8)) - (vm15/qp*24*M3Gn_trans*GALT_trans/km15/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm22/qp*24*M3Gn_trans*GNT3_trans/km22/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M3Gn_medial) - (kt*M3Gn_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(75) = ( + (vm8/qp*24*GNT2_trans*M3Gn_trans/km8/(kg*vg/qp+M3Gn_trans/km8)) - (vm9/qp*24*M3Gn2_trans*GNT5_trans/km9/(kg*vg/qp+M3Gn2_trans/km9+M3Gn3_trans/km12)) - (vm10/qp*24*M3Gn2_trans*GNT4_trans/km10/(kg*vg/qp+M3Gn2_trans/km10+M3Gn3prime_trans/km11)) - (vm16/qp*24*M3Gn2_trans*GALT_trans/km16/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm23/qp*24*M3Gn2_trans*GNT3_trans/km23/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M3Gn2_medial) - (kt*M3Gn2_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(76) = ( + (vm29/qp*24*M3GnGnb_trans*GALT_trans/km29/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3GnGnbG_medial) - (kt*M3GnGnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(77) = ( + (vm22/qp*24*M3Gn_trans*GNT3_trans/km22/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm29/qp*24*M3GnGnb_trans*GALT_trans/km29/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3GnGnb_medial) - (kt*M3GnGnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(78) = ( + (vm15/qp*24*M3Gn_trans*GALT_trans/km15/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3GnG_medial) - (kt*M3GnG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(79) = ( + (vm33/qp*24*M3Gn4Gnb_trans*GALT_trans/km33/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn4GnbG_medial) - (kt*M3Gn4GnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(80) = ( + (vm26/qp*24*M3Gn4_trans*GNT3_trans/km26/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm33/qp*24*M3Gn4Gnb_trans*GALT_trans/km33/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn4Gnb_medial) - (kt*M3Gn4Gnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(81) = ( + (vm19/qp*24*M3Gn4_trans*GALT_trans/km19/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn4G_medial) - (kt*M3Gn4G_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(82) = ( + (vm11/qp*24*M3Gn3prime_trans*GNT4_trans/km11/(kg*vg/qp+M3Gn2_trans/km10+M3Gn3prime_trans/km11)) + (vm12/qp*24*M3Gn3_trans*GNT5_trans/km12/(kg*vg/qp+M3Gn2_trans/km9+M3Gn3_trans/km12)) - (vm19/qp*24*M3Gn4_trans*GALT_trans/km19/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm26/qp*24*M3Gn4_trans*GNT3_trans/km26/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M3Gn4_medial) - (kt*M3Gn4_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(83) = ( + (vm31/qp*24*M3Gn3primeGnb_trans*GALT_trans/km31/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn3primeGnbG_medial) - (kt*M3Gn3primeGnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(84) = ( + (vm24/qp*24*M3Gn3prime_trans*GNT3_trans/km24/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm31/qp*24*M3Gn3primeGnb_trans*GALT_trans/km31/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn3primeGnb_medial) - (kt*M3Gn3primeGnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(85) = ( + (vm17/qp*24*M3Gn3prime_trans*GALT_trans/km17/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn3primeG_medial) - (kt*M3Gn3primeG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(86) = ( + (vm9/qp*24*M3Gn2_trans*GNT5_trans/km9/(kg*vg/qp+M3Gn2_trans/km9+M3Gn3_trans/km12)) - (vm11/qp*24*M3Gn3prime_trans*GNT4_trans/km11/(kg*vg/qp+M3Gn2_trans/km10+M3Gn3prime_trans/km11)) - (vm17/qp*24*M3Gn3prime_trans*GALT_trans/km17/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm24/qp*24*M3Gn3prime_trans*GNT3_trans/km24/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M3Gn3prime_medial) - (kt*M3Gn3prime_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(87) = ( + (vm32/qp*24*M3Gn3Gnb_trans*GALT_trans/km32/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn3GnbG_medial) - (kt*M3Gn3GnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(88) = ( + (vm25/qp*24*M3Gn3_trans*GNT3_trans/km25/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm32/qp*24*M3Gn3Gnb_trans*GALT_trans/km32/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn3Gnb_medial) - (kt*M3Gn3Gnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(89) = ( + (vm18/qp*24*M3Gn3_trans*GALT_trans/km18/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn3G_medial) - (kt*M3Gn3G_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(90) = ( + (vm10/qp*24*M3Gn2_trans*GNT4_trans/km10/(kg*vg/qp+M3Gn2_trans/km10+M3Gn3prime_trans/km11)) - (vm12/qp*24*M3Gn3_trans*GNT5_trans/km12/(kg*vg/qp+M3Gn2_trans/km9+M3Gn3_trans/km12)) - (vm18/qp*24*M3Gn3_trans*GALT_trans/km18/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) - (vm25/qp*24*M3Gn3_trans*GNT3_trans/km25/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) + (kt*M3Gn3_medial) - (kt*M3Gn3_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(91) = ( + (vm30/qp*24*M3Gn2Gnb_trans*GALT_trans/km30/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn2GnbG_medial) - (kt*M3Gn2GnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(92) = ( + (vm23/qp*24*M3Gn2_trans*GNT3_trans/km23/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm30/qp*24*M3Gn2Gnb_trans*GALT_trans/km30/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn2Gnb_medial) - (kt*M3Gn2Gnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(93) = ( + (vm16/qp*24*M3Gn2_trans*GALT_trans/km16/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M3Gn2G_medial) - (kt*M3Gn2G_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(94) = ( + (vm27/qp*24*M5GnGnb_trans*GALT_trans/km27/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M5GnGnbG_medial) - (kt*M5GnGnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(95) = ( + (vm20/qp*24*M5Gn_trans*GNT3_trans/km20/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm27/qp*24*M5GnGnb_trans*GALT_trans/km27/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M5GnGnb_medial) - (kt*M5GnGnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(96) = ( + (vm13/qp*24*M5Gn_trans*GALT_trans/km13/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M5GnG_medial) - (kt*M5GnG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(97) = ( + (vm28/qp*24*M4GnGnb_trans*GALT_trans/km28/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M4GnGnbG_medial) - (kt*M4GnGnbG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(98) = ( + (vm21/qp*24*M4Gn_trans*GNT3_trans/km21/(kg*vg/qp+M5Gn_trans/km20+M4Gn_trans/km21+M3Gn_trans/km22+M3Gn2_trans/km23+M3Gn3prime_trans/km24+M3Gn3_trans/km25+M3Gn4_trans/km26)) - (vm28/qp*24*M4GnGnb_trans*GALT_trans/km28/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M4GnGnb_medial) - (kt*M4GnGnb_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(99) = ( + (vm14/qp*24*M4Gn_trans*GALT_trans/km14/(kg*vg/qp+M5Gn_trans/km13+M4Gn_trans/km14+M3Gn_trans/km15+M3Gn2_trans/km16+M3Gn3prime_trans/km17+M3Gn3_trans/km18+M3Gn4_trans/km19+M5GnGnb_trans/km27+M4GnGnb_trans/km28+M3GnGnb_trans/km29+M3Gn2Gnb_trans/km30+M3Gn3primeGnb_trans/km31+M3Gn3Gnb_trans/km32+M3Gn4Gnb_trans/km33)) + (kt*M4GnG_medial) - (kt*M4GnG_trans))/Global_cis_medial_trans_tgn_4compts;
	xdot(100) = ( - (vm1/qp*24*ManI_tgn*M9_tgn/km1/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) + (kt*M9_trans) - (kt*M9_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(101) = ( + (vm1/qp*24*ManI_tgn*M9_tgn/km1/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) - (vm2/qp*24*ManI_tgn*M8_tgn/km2/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) + (kt*M8_trans) - (kt*M8_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(102) = ( + (vm2/qp*24*ManI_tgn*M8_tgn/km2/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) - (vm3/qp*24*ManI_tgn*M7_tgn/km3/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) + (kt*M7_trans) - (kt*M7_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(103) = ( + (vm3/qp*24*ManI_tgn*M7_tgn/km3/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) - (vm4/qp*24*ManI_tgn*M6_tgn/km4/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) + (kt*M6_trans) - (kt*M6_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(104) = ( + (vm4/qp*24*ManI_tgn*M6_tgn/km4/(kg*vg/qp+M9_tgn/km1+M8_tgn/km2+M7_tgn/km3+M6_tgn/km4)) - (vm5/qp*24*GNT1_tgn*M5_tgn/km5/(kg*vg/qp+M5_tgn/km5)) + (kt*M5_trans) - (kt*M5_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(105) = ( + (vm5/qp*24*GNT1_tgn*M5_tgn/km5/(kg*vg/qp+M5_tgn/km5)) - (vm6/qp*24*M5Gn_tgn*ManII_tgn/km6/(kg*vg/qp+M5Gn_tgn/km6+M4Gn_tgn/km7)) - (vm13/qp*24*M5Gn_tgn*GALT_tgn/km13/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm20/qp*24*M5Gn_tgn*GNT3_tgn/km20/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M5Gn_trans) - (kt*M5Gn_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(106) = ( + (vm6/qp*24*M5Gn_tgn*ManII_tgn/km6/(kg*vg/qp+M5Gn_tgn/km6+M4Gn_tgn/km7)) - (vm7/qp*24*M4Gn_tgn*ManII_tgn/km7/(kg*vg/qp+M5Gn_tgn/km6+M4Gn_tgn/km7)) - (vm14/qp*24*M4Gn_tgn*GALT_tgn/km14/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm21/qp*24*M4Gn_tgn*GNT3_tgn/km21/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M4Gn_trans) - (kt*M4Gn_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(107) = ( + (vm7/qp*24*M4Gn_tgn*ManII_tgn/km7/(kg*vg/qp+M5Gn_tgn/km6+M4Gn_tgn/km7)) - (vm8/qp*24*GNT2_tgn*M3Gn_tgn/km8/(kg*vg/qp+M3Gn_tgn/km8)) - (vm15/qp*24*M3Gn_tgn*GALT_tgn/km15/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm22/qp*24*M3Gn_tgn*GNT3_tgn/km22/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M3Gn_trans) - (kt*M3Gn_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(108) = ( + (vm8/qp*24*GNT2_tgn*M3Gn_tgn/km8/(kg*vg/qp+M3Gn_tgn/km8)) - (vm9/qp*24*M3Gn2_tgn*GNT5_tgn/km9/(kg*vg/qp+M3Gn2_tgn/km9+M3Gn3_tgn/km12)) - (vm10/qp*24*M3Gn2_tgn*GNT4_tgn/km10/(kg*vg/qp+M3Gn2_tgn/km10+M3Gn3prime_tgn/km11)) - (vm16/qp*24*M3Gn2_tgn*GALT_tgn/km16/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm23/qp*24*M3Gn2_tgn*GNT3_tgn/km23/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M3Gn2_trans) - (kt*M3Gn2_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(109) = ( + (vm29/qp*24*M3GnGnb_tgn*GALT_tgn/km29/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3GnGnbG_trans) - (kt*M3GnGnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(110) = ( + (vm22/qp*24*M3Gn_tgn*GNT3_tgn/km22/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm29/qp*24*M3GnGnb_tgn*GALT_tgn/km29/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3GnGnb_trans) - (kt*M3GnGnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(111) = ( + (vm15/qp*24*M3Gn_tgn*GALT_tgn/km15/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3GnG_trans) - (kt*M3GnG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(112) = ( + (vm33/qp*24*M3Gn4Gnb_tgn*GALT_tgn/km33/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn4GnbG_trans) - (kt*M3Gn4GnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(113) = ( + (vm26/qp*24*M3Gn4_tgn*GNT3_tgn/km26/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm33/qp*24*M3Gn4Gnb_tgn*GALT_tgn/km33/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn4Gnb_trans) - (kt*M3Gn4Gnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(114) = ( + (vm19/qp*24*M3Gn4_tgn*GALT_tgn/km19/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn4G_trans) - (kt*M3Gn4G_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(115) = ( + (vm11/qp*24*M3Gn3prime_tgn*GNT4_tgn/km11/(kg*vg/qp+M3Gn2_tgn/km10+M3Gn3prime_tgn/km11)) + (vm12/qp*24*M3Gn3_tgn*GNT5_tgn/km12/(kg*vg/qp+M3Gn2_tgn/km9+M3Gn3_tgn/km12)) - (vm19/qp*24*M3Gn4_tgn*GALT_tgn/km19/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm26/qp*24*M3Gn4_tgn*GNT3_tgn/km26/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M3Gn4_trans) - (kt*M3Gn4_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(116) = ( + (vm31/qp*24*M3Gn3primeGnb_tgn*GALT_tgn/km31/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn3primeGnbG_trans) - (kt*M3Gn3primeGnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(117) = ( + (vm24/qp*24*M3Gn3prime_tgn*GNT3_tgn/km24/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm31/qp*24*M3Gn3primeGnb_tgn*GALT_tgn/km31/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn3primeGnb_trans) - (kt*M3Gn3primeGnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(118) = ( + (vm17/qp*24*M3Gn3prime_tgn*GALT_tgn/km17/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn3primeG_trans) - (kt*M3Gn3primeG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(119) = ( + (vm9/qp*24*M3Gn2_tgn*GNT5_tgn/km9/(kg*vg/qp+M3Gn2_tgn/km9+M3Gn3_tgn/km12)) - (vm11/qp*24*M3Gn3prime_tgn*GNT4_tgn/km11/(kg*vg/qp+M3Gn2_tgn/km10+M3Gn3prime_tgn/km11)) - (vm17/qp*24*M3Gn3prime_tgn*GALT_tgn/km17/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm24/qp*24*M3Gn3prime_tgn*GNT3_tgn/km24/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M3Gn3prime_trans) - (kt*M3Gn3prime_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(120) = ( + (vm32/qp*24*M3Gn3Gnb_tgn*GALT_tgn/km32/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn3GnbG_trans) - (kt*M3Gn3GnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(121) = ( + (vm25/qp*24*M3Gn3_tgn*GNT3_tgn/km25/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm32/qp*24*M3Gn3Gnb_tgn*GALT_tgn/km32/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn3Gnb_trans) - (kt*M3Gn3Gnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(122) = ( + (vm18/qp*24*M3Gn3_tgn*GALT_tgn/km18/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn3G_trans) - (kt*M3Gn3G_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(123) = ( + (vm10/qp*24*M3Gn2_tgn*GNT4_tgn/km10/(kg*vg/qp+M3Gn2_tgn/km10+M3Gn3prime_tgn/km11)) - (vm12/qp*24*M3Gn3_tgn*GNT5_tgn/km12/(kg*vg/qp+M3Gn2_tgn/km9+M3Gn3_tgn/km12)) - (vm18/qp*24*M3Gn3_tgn*GALT_tgn/km18/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) - (vm25/qp*24*M3Gn3_tgn*GNT3_tgn/km25/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) + (kt*M3Gn3_trans) - (kt*M3Gn3_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(124) = ( + (vm30/qp*24*M3Gn2Gnb_tgn*GALT_tgn/km30/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn2GnbG_trans) - (kt*M3Gn2GnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(125) = ( + (vm23/qp*24*M3Gn2_tgn*GNT3_tgn/km23/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm30/qp*24*M3Gn2Gnb_tgn*GALT_tgn/km30/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn2Gnb_trans) - (kt*M3Gn2Gnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(126) = ( + (vm16/qp*24*M3Gn2_tgn*GALT_tgn/km16/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M3Gn2G_trans) - (kt*M3Gn2G_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(127) = ( + (vm27/qp*24*M5GnGnb_tgn*GALT_tgn/km27/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M5GnGnbG_trans) - (kt*M5GnGnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(128) = ( + (vm20/qp*24*M5Gn_tgn*GNT3_tgn/km20/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm27/qp*24*M5GnGnb_tgn*GALT_tgn/km27/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M5GnGnb_trans) - (kt*M5GnGnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(129) = ( + (vm13/qp*24*M5Gn_tgn*GALT_tgn/km13/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M5GnG_trans) - (kt*M5GnG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(130) = ( + (vm28/qp*24*M4GnGnb_tgn*GALT_tgn/km28/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M4GnGnbG_trans) - (kt*M4GnGnbG_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(131) = ( + (vm21/qp*24*M4Gn_tgn*GNT3_tgn/km21/(kg*vg/qp+M5Gn_tgn/km20+M4Gn_tgn/km21+M3Gn_tgn/km22+M3Gn2_tgn/km23+M3Gn3prime_tgn/km24+M3Gn3_tgn/km25+M3Gn4_tgn/km26)) - (vm28/qp*24*M4GnGnb_tgn*GALT_tgn/km28/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M4GnGnb_trans) - (kt*M4GnGnb_tgn))/Global_cis_medial_trans_tgn_4compts;
	xdot(132) = ( + (vm14/qp*24*M4Gn_tgn*GALT_tgn/km14/(kg*vg/qp+M5Gn_tgn/km13+M4Gn_tgn/km14+M3Gn_tgn/km15+M3Gn2_tgn/km16+M3Gn3prime_tgn/km17+M3Gn3_tgn/km18+M3Gn4_tgn/km19+M5GnGnb_tgn/km27+M4GnGnb_tgn/km28+M3GnGnb_tgn/km29+M3Gn2Gnb_tgn/km30+M3Gn3primeGnb_tgn/km31+M3Gn3Gnb_tgn/km32+M3Gn4Gnb_tgn/km33)) + (kt*M4GnG_trans) - (kt*M4GnG_tgn))/Global_cis_medial_trans_tgn_4compts;

end;
