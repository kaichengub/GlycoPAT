function AllFragIons=multiSGPFrag(varargin)
%MULTISGPFRAG: Calculate all fragment ions formed theoretically from a
% glycopeptide 
% 
% Syntax:
% AllFragIons = multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% 
% Input: 
%   SmallGlyPep; glycopeptide in SmallGlyPep format
%   npFrag, ngFrag, nmFrag: # of peptide, glycan, and ptm fragmentations 
%   z: charge state.
%   Note:  
%   This program will take a 'peptide' alone as input (no glycan), in 
%   which case only protProd and pep-ions are returned. The program can 
%   also take a 'glycan' alone in which case only glyBion and glyBion are
%   returned. Alternatively, it can take the entire glycopeptide as input.
%
% Output:
%   AllFragIons: Structure containing all fragment ion data, i.e. product structure, 
%   fragmentation type, ion type and m/z at charge state z etc. Note even
%   internal ions are generated in the case of multiple peptide fragmentation.
% 
% * Children function: joinGlyPep, glypepMW, glycanFrag, CompileFrags
% 
% Example 1 (glycan alone):
% >> SmallGlyPep ='{n{n{h{h{h{h}}{h{h{h}{h{h}}}}}}}}';
%    nmFrag=0;
%    npFrag=0;
%    ngFrag=1;
%    z=1;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x19 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%    >> AllFragIons(1)
%       ans = 
%               original: '{n{n{h{h{h{h}}{h{h{h}{h{h}}}}}}}}'
%               sgp: '{n{n{h{h{h{h}}{h{h{h}{h{h}}}}}}}}'
%               nmFrag: 0
%               npFrag: 0
%               ngFrag: 0
%               mz: 1883.6524646
%               type: 'none'
%               charge: 1
%
% Example 2: (peptide alone):
% >> SmallGlyPep='FNWYVDGVEVHNAK';
%    nmFrag=0;
%    npFrag=1;
%    ngFrag=0;
%    z=2;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x53 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
%    >> AllFragIons(2)
%       ans = 
%               original: 'FNWYVDGVEVHNAK'
%               sgp: 'F'
%               nmFrag: 0
%               npFrag: 1
%               ngFrag: 0
%               mz: 74.542032035
%               type: 'b1'
%               charge: 2
%
% Test case from Protein Prospector:
%     b	         b+2	    c	         c+2				     y	        y+2	         z	        z+2
%    ---	     ---	 165.1022	     ---	1	F	14	    ---	        ---	        ---	        ---
% 262.1186	     ---	 279.1452	     ---	2	N	13	 1530.7336	 765.8704	 1514.7148	 757.8611
% 448.1979	     ---	 465.2245	     ---	3	W	12	 1416.6906	 708.8490	 1400.6719	 700.8396
% 611.2613	     ---	 628.2878    	 ---	4	Y	11	 1230.6113	 615.8093	 1214.5926	 607.7999
% 710.3297     	 ---	 727.3562	     ---	5	V	10	 1067.5480	 534.2776	 1051.5293	 526.2683
% 825.3566	     ---	 842.3832    	 ---	6	D	9	 968.4796	 484.7434	 952.4609	 476.7341
% 882.3781	     ---	 899.4046	     ---	7	G	8	 853.4526	 427.2300	 837.4339	 419.2206
% 981.4465    	 ---	 998.4730    	 ---	8	V	7	 796.4312	 398.7192	 780.4125	 390.7099
% 1110.4891	     ---	 1127.5156	     ---	9	E	6	 697.3628	 349.1850	 681.3440	 341.1757
% 1209.5575	     ---	 1226.5840	     ---	10	V	5	 568.3202	 284.6637	 552.3014	 276.6544
% 1346.6164	 673.8118	 1363.6430	 682.3251	11	H	4	 469.2518	 235.1295	 453.2330	 227.1202
% 1460.6593	 730.8333	 1477.6859	 739.3466	12	N	3	 332.1928	    ---      316.1741	    ---
% 1531.6965	 766.3519	 1548.7230	 774.8651	13	A	2	 218.1499    	---      202.1312	    ---
%    ---	     ---	    ---	         ---	14	K	1	 147.1128	    ---      131.0941	    ---
%
% Example 3:
% Results for 3a and 3b are identical
% * 3a. (peptide with modification):
% >> SmallGlyPep='FNWY<s>VDGVEM<o>HNAK';
%    nmFrag=0;
%    npFrag=1;
%    ngFrag=0;
%    z=2;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x53 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
% Test case from Protein Prospector (FNWY(Sulfo)VDGVEM(Oxidation)HNAK):
%     b         b+2         c         c+2                           y	      y+2           z          z+2
%    ---        ---     165.1022	  ---	 1	F	        14	   ---        ---          ---         ---
% 262.1186      ---     279.1452	  ---	 2	N	        13	1658.6574	829.8323	1642.6386	821.823
% 448.1979      ---     465.2245	  ---	 3	W	        12	1544.6144	772.8109	1528.5957	764.8015
% 691.2181      ---     708.2446	  ---	 4	Y(Sulfo)	11	1358.5351	679.7712	1342.5164	671.7618
% 790.2865      ---     807.313       ---	 5	V	        10	1115.515	558.2611	1099.4963	550.2518
% 905.3134      ---     922.34        ---	 6	D	         9	1016.4466	508.7269	1000.4278	500.7176
% 962.3349      ---     979.3614	  ---	 7	G            8	901.4196	451.2135	885.4009	443.2041
% 1061.4033     ---     1078.4299	  ---	 8	V            7	844.3982	422.7027	828.3794	414.6934
% 1190.4459     ---     1207.4725	  ---	 9	E            6	745.3297	373.1685	729.311	    365.1592
% 1337.4813     ---     1354.5078	  ---	 10	M(Oxidation) 5	616.2872	308.6472	600.2684	300.6379
% 1474.5402   737.7737	1491.5668	746.287	 11	H            4	469.2518	235.1295	453.233	    227.1202
% 1588.5831	  794.7952	1605.6097	803.3085 12	N            3	332.1928	166.6001	316.1741	158.5907
% 1659.6203	  830.3138	1676.6468	838.827	 13	A            2	218.1499	109.5786	202.1312	101.5692
%    ---        ---        ---        ---	 14	K            1	147.1128	74.06       131.0941	66.0507
%
% * 3b. (peptide with custom modification);
% >> SmallGlyPep2='FNWY<79.9568>VDGVEM<15.99492>HNAK';
%    nmFrag=0;
%    npFrag=1;
%    ngFrag=0;
%    z=2;
%    [AllFragIons2]=multiSGPFrag(SmallGlyPep2,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons2 = 1x53 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
%   
%   >> AllFragIons.sgp      >> AllFragIons.mz   >> AllFragIons.type     >> AllFragIons2.sgp                 >> AllFragIons2.mz  >> AllFragIons2.type
%   FNWY<s>VDGVEM<o>HNAK    903.3670685         none                    FNWY<79.9568>VDGVEM<15.99492>HNAK   903.3670685         none
%   F                       74.54203204         b1                      F                                   74.54203204         b1
%   FN                      131.5634955         b2                      FN                                  131.5634955         b2
%   FNW                     224.603152          b3                      FNW                                 224.603152          b3
%   FNWY<s>                 346.113212          b4                      FNWY<79.9568>                       346.113212          b4
%   FNWY<s>V                395.647419          b5                      FNWY<79.9568>V                      395.647419          b5
%   FNWY<s>VD               453.1608905         b6                      FNWY<79.9568>VD                     453.1608905         b6
%   FNWY<s>VDG              481.6716225         b7                      FNWY<79.9568>VDG                    481.6716225         b7
%   FNWY<s>VDGV             531.2058295         b8                      FNWY<79.9568>VDGV                   531.2058295         b8
%   FNWY<s>VDGVE            595.727126          b9                      FNWY<79.9568>VDGVE                  595.727126          b9
%   FNWY<s>VDGVEM<o>        669.2448285         b10                     FNWY<79.9568>VDGVEM<15.99492>       669.2448285         b10
%   FNWY<s>VDGVEM<o>H       737.7742845         b11                     FNWY<79.9568>VDGVEM<15.99492>H      737.7742845         b11
%   FNWY<s>VDGVEM<o>HN      794.795748          b12                     FNWY<79.9568>VDGVEM<15.99492>HN     794.795748          b12
%   FNWY<s>VDGVEM<o>HNA     830.314305          b13                     FNWY<79.9568>VDGVEM<15.99492>HNA    830.314305          b13
%   F                       83.05530659         c1                      F                                   83.05530659         c1
%   FN                      140.0767701         c2                      FN                                  140.0767701         c2
%   FNW                     233.1164266         c3                      FNW                                 233.1164266         c3
%   FNWY<s>                 354.6264866         c4                      FNWY<79.9568>                       354.6264866         c4
%   FNWY<s>V                404.1606936         c5                      FNWY<79.9568>V                      404.1606936         c5
%   FNWY<s>VD               461.6741651         c6                      FNWY<79.9568>VD                     461.6741651         c6
%   FNWY<s>VDG              490.1848971         c7                      FNWY<79.9568>VDG                    490.1848971         c7
%   FNWY<s>VDGV             539.7191041         c8                      FNWY<79.9568>VDGV                   539.7191041         c8
%   FNWY<s>VDGVE            604.2404006         c9                      FNWY<79.9568>VDGVE                  604.2404006         c9
%   FNWY<s>VDGVEM<o>        677.7581031         c10                     FNWY<79.9568>VDGVEM<15.99492>       677.7581031         c10
%   FNWY<s>VDGVEM<o>H       746.2875591         c11                     FNWY<79.9568>VDGVEM<15.99492>H      746.2875591         c11
%   FNWY<s>VDGVEM<o>HN      803.3090226         c12                     FNWY<79.9568>VDGVEM<15.99492>HN     803.3090226         c12
%   FNWY<s>VDGVEM<o>HNA     838.8275796         c13                     FNWY<79.9568>VDGVEM<15.99492>HNA    838.8275796         c13
%   NWY<s>VDGVEM<o>HNAK     829.8328619         y13                     NWY<79.9568>VDGVEM<15.99492>HNAK    829.8328619         y13
%   WY<s>VDGVEM<o>HNAK      772.8113984         y12                     WY<79.9568>VDGVEM<15.99492>HNAK     772.8113984         y12
%   Y<s>VDGVEM<o>HNAK       679.7717419         y11                     Y<79.9568>VDGVEM<15.99492>HNAK      679.7717419         y11
%   VDGVEM<o>HNAK           558.2616819         y10                     VDGVEM<15.99492>HNAK                558.2616819         y10
%   DGVEM<o>HNAK            508.7274749         y9                      DGVEM<15.99492>HNAK                 508.7274749         y9
%   GVEM<o>HNAK             451.2140034         y8                      GVEM<15.99492>HNAK                  451.2140034         y8
%   VEM<o>HNAK              422.7032714         y7                      VEM<15.99492>HNAK                   422.7032714         y7
%   EM<o>HNAK               373.1690644         y6                      EM<15.99492>HNAK                    373.1690644         y6
%   M<o>HNAK                308.6477679         y5                      M<15.99492>HNAK                     308.6477679         y5
%   HNAK                    235.1300654         y4                      HNAK                                235.1300654         y4
%   NAK                     166.6006094         y3                      NAK                                 166.6006094         y3
%   AK                      109.5791459         y2                      AK                                  109.5791459         y2
%   K                       74.06058889         y1                      K                                   74.06058889         y1
%   NWY<s>VDGVEM<o>HNAK     821.8234999         z13                     NWY<79.9568>VDGVEM<15.99492>HNAK    821.8234999         z13
%   WY<s>VDGVEM<o>HNAK      764.8020364         z12                     WY<79.9568>VDGVEM<15.99492>HNAK     764.8020364         z12
%   Y<s>VDGVEM<o>HNAK       671.7623799         z11                     Y<79.9568>VDGVEM<15.99492>HNAK      671.7623799         z11
%   VDGVEM<o>HNAK           550.2523199         z10                     VDGVEM<15.99492>HNAK                550.2523199         z10
%   DGVEM<o>HNAK            500.7181129         z9                      DGVEM<15.99492>HNAK                 500.7181129         z9
%   GVEM<o>HNAK             443.2046414         z8                      GVEM<15.99492>HNAK                  443.2046414         z8
%   VEM<o>HNAK              414.6939094         z7                      VEM<15.99492>HNAK                   414.6939094         z7
%   EM<o>HNAK               365.1597024         z6                      EM<15.99492>HNAK                    365.1597024         z6
%   M<o>HNAK                300.6384059         z5                      M<15.99492>HNAK                     300.6384059         z5
%   HNAK                    227.1207034         z4                      HNAK                                227.1207034         z4
%   NAK                     158.5912474         z3                      NAK                                 158.5912474         z3
%   AK                      101.5697839         z2                      AK                                  101.5697839         z2
%   K                       66.05122685         z1                      K                                   66.05122685         z1
%
% Example 4:
% Results for 4a and 4b are identical
% Fig. 3A (Lo et al. JBC, 288:13974-87, 2013)
% * 4a. (glycopeptide with modifications):
% >> SmallGlyPep='T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D';
%    nmFrag=0;
%    npFrag=0;
%    ngFrag=1;
%    z=1;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x13 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
% * 4b. (glycopeptide with custom mass):
% >> SmallGlyPep2='T{n{h{s}}{n{f}{h{291.0954048}}}}EPPRAM<15.99492>M<o>D';
%    nmFrag=0;
%    npFrag=0;
%    ngFrag=1;
%    z=1;
%    [AllFragIons2]=multiSGPFrag(SmallGlyPep2,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons2 = 1x15 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
% 
%   >> AllFragIons.sgp                      >> AllFragIons.mz   >> AllFragIons.type         >> AllFragIons2.sgp                                     >> AllFragIons2.mz  >> AllFragIons2.type
%   T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D    2537.963239         none                        T{n{h{s}}{n{f}{h{291.0954048}}}}EPPRAM<15.99492>M<o>D   2537.963239         none
%   TEPPRAM<o>M<o>D                         1079.450168         -y-{n{h{s}}{n{f}{h{s}}}}    TEPPRAM<15.99492>M<o>D                                  1079.450168         -y-{n{h{s}}{n{f}{h{291.0954048}}}}
%   T{n{n{f}{h{s}}}}EPPRAM<o>M<o>D          2084.815018         -y-{h{s}}                   T{n{n{f}{h{291.0954048}}}}EPPRAM<15.99492>M<o>D         2084.815018         -y-{h{s}}
%   T{n{h}{n{f}{h{s}}}}EPPRAM<o>M<o>D       2246.867835         -y-{s}                      T{n{h}{n{f}{h{291.0954048}}}}EPPRAM<15.99492>M<o>D      2246.867835         -y-{s}
%   T{n{h{s}}}EPPRAM<o>M<o>D                1735.677752         -y-{n{f}{h{s}}}             T{n{h{s}}}EPPRAM<15.99492>M<o>D                         1735.677752         -y-{n{f}{h{291.0954048}}}
%   T{n{h{s}}{n{h{s}}}}EPPRAM<o>M<o>D       2391.905337         -y-{f}                      T{n{h{s}}{n{h{291.0954048}}}}EPPRAM<15.99492>M<o>D      2391.905337         -y-{f}
%   T{n{h{s}}{n{f}}}EPPRAM<o>M<o>D          2084.815018         -y-{h{s}}                   T{n{h{s}}{n{f}}}EPPRAM<15.99492>M<o>D                   2084.815018         -y-{h{291.0954048}}
%   T{n{h{s}}{n{f}{h}}}EPPRAM<o>M<o>D       2246.867835         -y-{s}                      T{n{h{s}}{n{f}{h}}}EPPRAM<15.99492>M<o>D                2246.867835         -y-{291.0954048}
%   {n{h{s}}{n{f}{h{s}}}}                   1459.520897         -b{n{h{s}}{n{f}{h{s}}}}     {n{h{s}}{n{f}{h{291.0954048}}}}                         1459.520897         -b{n{h{s}}{n{f}{h{291.0954048}}}}
%   {h{s}}                                  454.1560449         -b{h{s}}                    {h{s}}                                                  454.1560449         -b{h{s}}
%   {s}                                     292.1032284         -b{s}                       {s}                                                     292.1032284         -b{s} 
%   {n{f}{h{s}}}                            803.2933114         -b{n{f}{h{s}}}              {n{f}{h{291.0954048}}}                                  803.2933114         -b{n{f}{h{291.0954048}}}
%   {f}                                     147.065726          -b{f}                       {f}                                                     147.065726          -b{f}
%                                                                                           {h{291.0954048}}                                        454.1560449         -b{h{291.0954048}}
%                                                                                           {291.0954048}                                           292.1032284         -b{291.0954048}
%
% Example 5 (glycopeptide with modification):
% Fig. 3B (Lo et al. JBC, 288:13974-87, 2013)
% >> SmallGlyPep='FLPET{n{h{s}}{s}}EPPRPM<o>M<o>D';
%    nmFrag=0;
%    npFrag=1;
%    ngFrag=1;
%    z=2;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x152 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
% Example 6 (glycopeptide with 2 glycans):
% 6a. CID mode
% Fig 7a (Perdivara et al. J Proteome Res, 2009. 8(2): p. 631-42., masses given in Supplemental Mat.):
% >> SmallGlyPep='VPT{n{h}}T{n{h{s}}}AASTPDAVDK';
%    nmFrag=0;
%    npFrag=0;
%    ngFrag=2;
%    z=1;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x18 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
%   >> AllFragIons.sgp              >> AllFragIons.type     >> AllFragIons.mz   >> AllFragIons.mz   >> AllFragIons.mz
%                                                           z=1                 z=2                 z=3
%   VPT{n{h}}T{n{h{s}}}AASTPDAVDK   none                    2394.055765         1197.531795         798.6904712
%   VPTT{n{h{s}}}AASTPDAVDK         -y-{n{h}}               2028.923586         1014.965705         676.9797453
%   VPT{n}T{n{h{s}}}AASTPDAVDK      -y-{h}                  2232.002948         1116.505387         744.6728662
%   VPT{n{h}}TAASTPDAVDK            -y-{n{h{s}}}            1737.828181         869.418003          579.9479437
%   VPT{n{h}}T{n}AASTPDAVDK         -y-{h{s}}               1940.907544         970.9576843         647.6410646
%   VPT{n{h}}T{n{h}}AASTPDAVDK      -y-{s}                  2102.96036          1051.984093         701.6586701
%   VPT{n}T{n{h}}AASTPDAVDK         -y-{s}-{h}              1940.907544         970.9576843         647.6410646
%   VPT{n}T{n}AASTPDAVDK            -y-{h{s}}-{h}           1778.854727         889.9312761         593.6234591
%   VPT{n}TAASTPDAVDK               -y-{n{h{s}}}-{h}        1575.775364         788.3915947         525.9303382
%   VPTT{n{h}}AASTPDAVDK            -y-{s}-{n{h}}           1737.828181         869.418003          579.9479437
%   VPTT{n}AASTPDAVDK               -y-{h{s}}-{n{h}}        1575.775364         788.3915947         525.9303382
%   VPTTAASTPDAVDK                  -y-{n{h{s}}}-{n{h}}     1372.696002         686.8519134         458.2372173
%   {n{h}}                          -b{n{h}}                366.1400042         183.5739146         122.7185514
%   {h}                             -b{h}                   163.0606401         82.03423258         55.02543007
%   {n{h{s}}}                       -b{n{h{s}}}             657.235409          329.121617          219.750353
%   {h{s}}                          -b{h{s}}                454.1560449         227.581935          152.0572317
%   {s}                             -b{s}                   292.1032284         146.5555267         98.03962617
%   {n}                             -b{n}                   204.0871877         102.5475064         68.70094593 
%
% 6b. ETD mode
% Fig 7b:
% >> SmallGlyPep='VPT{n{h}}T{n{h{s}}}AASTPDAVDK';
%    nmFrag=0;
%    npFrag=1;
%    ngFrag=0;
%    z=1;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%       AllFragIons = 1x53 struct array with fields:
%                       original
%                       sgp
%                       nmFrag
%                       npFrag
%                       ngFrag
%                       mz
%                       type
%                       charge
%
%   >> AllFragIons.sgp              >> AllFragIons.type     >> AllFragIons.mz   >> AllFragIons.mz   >> AllFragIons.mz
%   VPT{n{h}}T{n{h{s}}}AASTPDAVDK   none                    2394.055765         2394.055765         2394.055765
%   V                               c1                      117.1027881         117.1027881         117.1027881
%   VP                              c2                      214.1555521         214.1555521         214.1555521
%   VPT{n{h}}                       c3                      680.3354103         680.3354103         680.3354103
%   VPT{n{h}}T{n{h{s}}}             c4                      1437.610673         1437.610673         1437.610673
%   VPT{n{h}}T{n{h{s}}}A            c5                      1508.647787         1508.647787         1508.647787
%   VPT{n{h}}T{n{h{s}}}AA           c6                      1579.684901         1579.684901         1579.684901
%   VPT{n{h}}T{n{h{s}}}AAS          c7                      1666.716929         1666.716929         1666.716929
%   VPT{n{h}}T{n{h{s}}}AAST         c8                      1767.764608         1767.764608         1767.764608
%   VPT{n{h}}T{n{h{s}}}AASTP        c9                      1864.817372         1864.817372         1864.817372
%   VPT{n{h}}T{n{h{s}}}AASTPD       c10                     1979.844315         1979.844315         1979.844315
%   VPT{n{h}}T{n{h{s}}}AASTPDA      c11                     2050.881429         2050.881429         2050.881429
%   VPT{n{h}}T{n{h{s}}}AASTPDAV     c12                     2149.949843         2149.949843         2149.949843
%   VPT{n{h}}T{n{h{s}}}AASTPDAVD    c13                     2264.976786         2264.976786         2264.976786
%   PT{n{h}}T{n{h{s}}}AASTPDAVDK    z13                     2278.968627         2278.968627         2278.968627
%   T{n{h}}T{n{h{s}}}AASTPDAVDK     z12                     2181.915863         2181.915863         2181.915863
%   T{n{h{s}}}AASTPDAVDK            z11                     1715.736005         1715.736005         1715.736005
%   AASTPDAVDK                      z10                     958.4607417         958.4607417         958.4607417
%   ASTPDAVDK                       z9                      887.4236277         887.4236277         887.4236277
%   STPDAVDK                        z8                      816.3865137         816.3865137         816.3865137
%   TPDAVDK                         z7                      729.3544857         729.3544857         729.3544857
%   PDAVDK                          z6                      628.3068067         628.3068067         628.3068067
%   DAVDK                           z5                      531.2540427         531.2540427         531.2540427
%   AVDK                            z4                      416.2270997         416.2270997         416.2270997
%   VDK                             z3                      345.1899857         345.1899857         345.1899857
%   DK                              z2                      246.1215717         246.1215717         246.1215717
%   K                               z1                      131.0946287         131.0946287         131.0946287
% 
%
%
% Example 4: Results verified with Fig. 3A (Lo et al. JBC, 288:13974-87, 2013)
% ngFrag=1
% z=1           z=2         protProd.sgp
% 2537.963223	1269.485524	T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D
% 1079.45015	540.2289873	TEPPRAM<o>M<o>D
% 2084.815002	1042.911413	T{n{n{f}{h{s}}}}EPPRAM<o>M<o>D
% 2246.867818	1123.937821	T{n{h}{n{f}{h{s}}}}EPPRAM<o>M<o>D
% 1735.677735	868.34278	T{n{h{s}}}EPPRAM<o>M<o>D
% 2391.905321	1196.456573	T{n{h{s}}{n{h{s}}}}EPPRAM<o>M<o>D
% 2084.815002	1042.911413	T{n{h{s}}{n{f}}}EPPRAM<o>M<o>D
% 2246.867818	1123.937821	T{n{h{s}}{n{f}{h}}}EPPRAM<o>M<o>D
%
% ngFrag=2
% z=1           z=2         protProd.sgp
% 2537.963223	1269.485524	T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D
% 1079.45015	540.2289873	TEPPRAM<o>M<o>D
% 2084.815002	1042.911413	T{n{n{f}{h{s}}}}EPPRAM<o>M<o>D
% 2246.867818	1123.937821	T{n{h}{n{f}{h{s}}}}EPPRAM<o>M<o>D
% 1735.677735	868.34278	T{n{h{s}}}EPPRAM<o>M<o>D
% 2391.905321	1196.456573	T{n{h{s}}{n{h{s}}}}EPPRAM<o>M<o>D
% 2084.815002	1042.911413	T{n{h{s}}{n{f}}}EPPRAM<o>M<o>D
% 2246.867818	1123.937821	T{n{h{s}}{n{f}{h}}}EPPRAM<o>M<o>D
% 1282.529514	641.7686693	T{n}EPPRAM<o>M<o>D
% 1938.757099	969.882462	T{n{n{h{s}}}}EPPRAM<o>M<o>D
% 1631.666781	816.3373026	T{n{n{f}}}EPPRAM<o>M<o>D
% 1793.719597	897.3637108	T{n{n{f}{h}}}EPPRAM<o>M<o>D
% 1444.582331	722.7950776	T{n{h}}EPPRAM<o>M<o>D
% 2100.809916	1050.90887	T{n{h}{n{h{s}}}}EPPRAM<o>M<o>D
% 1793.719597	897.3637108	T{n{h}{n{f}}}EPPRAM<o>M<o>D
% 1955.772414	978.3901191	T{n{h}{n{f}{h}}}EPPRAM<o>M<o>D
% 1938.757099	969.882462	T{n{h{s}}{n}}EPPRAM<o>M<o>D
% 2100.809916	1050.90887	T{n{h{s}}{n{h}}}EPPRAM<o>M<o>D
%
% ngFrag=2
% z=1           z=2             glyBion.sgp
% 1459.520898	730.2643612	    '{n{h{s}}{n{f}{h{s}}}}'
% 454.1560459	227.5819353	    '{h{s}}'
% 292.1032294	146.555527	    '{s}'
% 803.2933124	402.1505685	    '{n{f}{h{s}}}'
% 147.065727	74.0367758	    '{f}'
% 1006.372677	503.6902506	    '{n{n{f}{h{s}}}}'
% 1168.425493	584.7166588	    '{n{h}{n{f}{h{s}}}}'
% 657.23541     329.1216173	    '{n{h{s}}}'
% 1313.462995	657.23541	    '{n{h{s}}{n{h{s}}}}'
% 1006.372677	503.6902506	    '{n{h{s}}{n{f}}}'
% 1168.425493	584.7166588	    '{n{h{s}}{n{f}{h}}}'
% 163.0606411	82.03423285	    '{h}'
% 350.1450911	175.5764579	    '{n{f}}'
% 512.1979076	256.6028661	    '{n{f}{h}}'
%
% Example 5: Compared with masses from figure
% 
% >> SmallGlyPep='T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D';
%    nmFrag=0;
%    npFrag=0;
%    ngFrag=2;
%    z=2;
%    [AllFragIons]=multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,z)
% Answer:
%   >> AllFragIons.sgp                      >> AllFragIons.type         >> AllFragIons.mz
%   T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D    none                        1269.485532
%   TEPPRAM<o>M<o>D                         -y-{n{h{s}}{n{f}{h{s}}}}    540.2289964
%   T{n{n{f}{h{s}}}}EPPRAM<o>M<o>D          -y-{h{s}}                   1042.911422
%   T{n{h}{n{f}{h{s}}}}EPPRAM<o>M<o>D       -y-{s}                      1123.93783
%   T{n{h{s}}}EPPRAM<o>M<o>D                -y-{n{f}{h{s}}}             868.3427884
%   T{n{h{s}}{n{h{s}}}}EPPRAM<o>M<o>D       -y-{f}                      1196.456581
%   T{n{h{s}}{n{f}}}EPPRAM<o>M<o>D          -y-{h{s}}                   1042.911422
%   T{n{h{s}}{n{f}{h}}}EPPRAM<o>M<o>D       -y-{s}                      1123.93783
%   T{n}EPPRAM<o>M<o>D                      -y-{n{f}{h{s}}}-{h{s}}      641.7686777
%   T{n{n{h{s}}}}EPPRAM<o>M<o>D             -y-{f}-{h{s}}               969.8824704
%   T{n{n{f}}}EPPRAM<o>M<o>D                -y-{h{s}}-{h{s}}            816.337311
%   T{n{n{f}{h}}}EPPRAM<o>M<o>D             -y-{s}-{h{s}}               897.3637192
%   T{n{h}}EPPRAM<o>M<o>D                   -y-{n{f}{h{s}}}-{s}         722.795086
%   T{n{h}{n{h{s}}}}EPPRAM<o>M<o>D          -y-{f}-{s}                  1050.908879
%   T{n{h}{n{f}}}EPPRAM<o>M<o>D             -y-{h{s}}-{s}               897.3637192
%   T{n{h}{n{f}{h}}}EPPRAM<o>M<o>D          -y-{s}-{s}                  978.3901275
%   T{n{h{s}}{n}}EPPRAM<o>M<o>D             -y-{h{s}}-{f}               969.8824704
%   T{n{h{s}}{n{h}}}EPPRAM<o>M<o>D          -y-{s}-{f}                  1050.908879
%   {n{h{s}}{n{f}{h{s}}}}                   -b{n{h{s}}{n{f}{h{s}}}}     730.2643609
%   {h{s}}                                  -b{h{s}}                    227.581935
%   {s}                                     -b{s}                       146.5555267
%   {n{f}{h{s}}}                            -b{n{f}{h{s}}}              402.1505682
%   {f}                                     -b{f}                       74.03677553
%   {n{n{f}{h{s}}}}                         -b{n{n{f}{h{s}}}}           503.6902503
%   {n{h}{n{f}{h{s}}}}                      -b{n{h}{n{f}{h{s}}}}        584.7166585
%   {n{h{s}}}                               -b{n{h{s}}}                 329.121617
%   {n{h{s}}{n{h{s}}}}                      -b{n{h{s}}{n{h{s}}}}        657.2354097
%   {n{h{s}}{n{f}}}                         -b{n{h{s}}{n{f}}}           503.6902503
%   {n{h{s}}{n{f}{h}}}                      -b{n{h{s}}{n{f}{h}}}        584.7166585
%   {h}                                     -b{h}                       82.03423258
%   {n{f}}                                  -b{n{f}}                    175.5764576
%   {n{f}{h}}                               -b{n{f}{h}}                 256.6028658
%
%See also GLYCANFRAG, JOINGLYPEP, BREAKGLYPEP, UQFRAGION, COMPILEFRAGS.

% Author: Sriram Neelamegham
% Last updated 08/11/14 by Gang Liu

if(nargin==5)
    SmallGlyPep = varargin{1};
    nmFrag = varargin{2};
    npFrag = varargin{3};
    ngFrag = varargin{4};
    z = varargin{5};   
end

% initialize code
[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);
if ~isempty(glyMat)
    bondnum = length(strfind(glyMat(1).struct,'{'));
    for j=1:length(glyMat)
        bondnumtemp = length(strfind(glyMat(j).struct,'{'));
        if bondnumtemp <= bondnum
            bondnum = bondnumtemp;
        end
    end
    if bondnum < ngFrag
        ngFrag = bondnum;
    end
end
% if not(isempty(pepMat.pep))
protProd(1).original=SmallGlyPep;
protProd(1).sgp=SmallGlyPep;            % original glycopeptide is stored as first element
protProd(1).nmFrag=0;
protProd(1).npFrag=0;
protProd(1).ngFrag=0;
protProd(1).mz=(glypepMW(SmallGlyPep,'full',1)+z*1.0078246)/z;  % This is now m/z and it is included as a y-ion!!
protProd(1).type='none';                                        
protProd(1).charge=z;                                        
nprotProd=1;
% end

% First, do modification fragmentation
if ((~isempty(modMat))&&(nmFrag>0))     % only necesary if the peptide has modifications that need to be fragmented
    for i=1:nmFrag
        if (length(modMat)>=nmFrag)     % if number of modifications is less than nmFrag, there is no need to do anything
            modComb=combnk(1:length(modMat),i);
            sz=size(modComb);
            for j=1:sz(1)
                modMatTemp=modMat;
                for k=sz(2):-1:1
                    modMatTemp(modComb(j,k))=[];
                end
                nprotProd=nprotProd+1;
                protProd(nprotProd).original=SmallGlyPep;
                protProd(nprotProd).sgp=joinGlyPep(pepMat,glyMat,modMatTemp);
                protProd(nprotProd).nmFrag=sz(2);
                protProd(nprotProd).npFrag=0;
                protProd(nprotProd).ngFrag=0;
                protProd(nprotProd).mz=(glypepMW(protProd(nprotProd).sgp,'full',1)+z*1.0078246)/z;  % This is now m/z and it is included with y-ions
                protProd(nprotProd).type='ptm';
                protProd(nprotProd).charge=z;
            end
        end
    end
end

% Second, do glycan fragmentation
glyBion=[];                         % stores glycan B-ions that result from release of terminal or internal ions
glyYion=[];
if ((~isempty(glyMat))&&(ngFrag>0))     % fragmentation only necessary for peptides with glycan modifications
    NewGlyPep=[];
    temp=cell(0,1);
    tempGly=cell(0,1);
    for i=1:length(protProd)
        bonds = strfind(protProd(i).sgp,'{');  % find location of glycosidic bonds
        for j=1:ngFrag
            if (length(bonds)>=ngFrag)         % only necessary if number of glycosidic bonds exceed ngFrag
                modComb=combnk(bonds,j);
                for k=1:size(modComb,1)
                    [NGP.sgp,gBion]=glycanFrag(protProd(i).sgp,modComb(k,:));
                    NGP.original=SmallGlyPep;
                    NGP.nmFrag=protProd(i).nmFrag;
                    NGP.npFrag=protProd(i).npFrag;
                    NGP.ngFrag=j;
                    NGP.mz=glypepMW(NGP.sgp,'y',z);            % This is now m/z and it is a Y-ion
                    NGP.charge=z;
                    concat='';
                    for m=1:length(gBion)
                        glyBFrag.original=SmallGlyPep;
                        glyBFrag.nmFrag=protProd(i).nmFrag;
                        glyBFrag.npFrag=protProd(i).npFrag;
                        glyBFrag.ngFrag=j;
                        glyBFrag.sgp=char(gBion(m));
                        glyBFrag.mz=glypepMW(char(glyBFrag.sgp),'b',z);
                        glyBFrag.type=['-b',glyBFrag.sgp];
                        concat=[concat,'-',glyBFrag.sgp];
                        glyBFrag.charge=z;
                    end
                    NGP.type=['-y',concat];
                    if (not(any(strcmp(NGP.sgp,temp)))&&(~isempty(NGP.sgp)))  % make sure NGP is not duplicated
                        NewGlyPep=[NewGlyPep,NGP];
                    end
                    temp{end+1}=NGP.sgp;
                    if (not(any(strcmp(glyBFrag.sgp,tempGly)))&&(~isempty(glyBFrag.sgp)))  % make sure glyBion is not duplicated
                        glyBion=[glyBion,glyBFrag];
                    end
                    % tempGly = [tempGly,glyBFrag.sgp];  % glyFrag.sgp is already in cell structure
                    tempGly{end+1}=glyBFrag.sgp;
                end
            end
        end
    end
    if isempty(pepMat.pep)
        glyYion=[glyYion,NewGlyPep];    % add original SmallGlyPep and NewGlyPep as Y-ions
    else
        protProd=[protProd,NewGlyPep];
    end
end

% Third, do peptide fragmentation
pepBion=[];
pepYion=[];
pepIion=[];
pepCion=[];
pepZion=[];

if ((~isempty(pepMat))&&(npFrag>0))    % only necesary if the glycan has modifications that need to be fragmented
      tempB=cell(0,1);
      tempI=cell(0,1);
      tempY=cell(0,1);     
    for i=1:npFrag
        for j=1:length(protProd)
            [pepMat,~,~]=breakGlyPep(protProd(j).sgp);
            if ((length(pepMat.pep)-1)>=npFrag)  % only necessary if number of peptide bonds exceeds npFrag
                modComb=combnk(1:length(pepMat.pep)-1,i);
                sz=size(modComb);
                tempPep.sgp='';          % Template empty holder for new peptide fragment
                tempPep.original=SmallGlyPep;
                tempPep.nmFrag=protProd(j).nmFrag;
                tempPep.npFrag=i;
                tempPep.ngFrag=protProd(j).ngFrag;
                tempPep.charge=z;
                tempBPep=tempPep;
                tempCPep=tempPep;
                tempIPep=tempPep;
                tempYPep=tempPep;
                tempZPep=tempPep;
                for k=1:sz(1)
                    oldPos=0;
                    tempBPep.sgp=protProd(j).sgp(oldPos+1:pepMat.pos(modComb(k,1)+1)-1);   % first peptide is the B/C-ion
                    tempBPep.mz=glypepMW(tempBPep.sgp,'b',z);        % m/z for B-ion
                    tempBPep.type=['b',int2str(modComb(k,1))];
                    tempCPep.sgp=protProd(j).sgp(oldPos+1:pepMat.pos(modComb(k,1)+1)-1);   % same as for B-ion
                    tempCPep.mz=glypepMW(tempBPep.sgp,'c',z);       % m/z for C-ion -- input peptide is same as for B ion
                    tempCPep.type=['c',int2str(modComb(k,1))];
                    if not(any(strcmp(tempBPep.sgp,tempB)))         % check to ensure this is not duplicated-- same for B- and C-ions
                        pepBion=[pepBion,tempBPep];
                        pepCion=[pepCion,tempCPep];
                    end
                    tempB{end+1}=tempBPep.sgp;
                    oldPos=pepMat.pos(modComb(k,1)+1)-1;
                    
                    for m=2:sz(2)                                   % next several are internal ions (same as B-ion in CID mode)
                        tempIPep.sgp=protProd(j).sgp(oldPos+1:pepMat.pos(modComb(k,m)+1)-1);
                        tempIPep.mz=glypepMW(tempIPep.sgp,'b',z);    % internal ions resemble B-ions?
                        tempIPep.type=['i',int2str(modComb(k,1)),'-',...
                           int2str(modComb(k,m))];
                        if not(any(strcmp(tempIPep.sgp,tempI)))
                            pepIion=[pepIion,tempIPep];
                        end
                        tempI{end+1}=tempIPep.sgp;
                        oldPos=pepMat.pos(modComb(k,m)+1)-1;
                    end
                    
                    tempYPep.sgp=protProd(j).sgp(oldPos+1:end);       % last peptide is the Y/Z-ion
                    tempZPep.sgp=protProd(j).sgp(oldPos+1:end);       % same for Y and Z-ions
                    tempYPep.mz=glypepMW(tempYPep.sgp,'y',z);
                    yLength=length(pepMat.pep)-(modComb(k,sz(2)));
                    tempYPep.type=['y' int2str(yLength)];
                    tempZPep.mz=glypepMW(tempZPep.sgp,'z',z);
                    tempZPep.type= ['z' int2str(yLength)];
                    if not(any(strcmp(tempYPep.sgp,tempY)))
                        pepYion=[pepYion,tempYPep];
                        pepZion=[pepZion,tempZPep];
                    end
                    tempY{end+1}=tempYPep.sgp;
                end
            end
        end
    end   
end

AllFragIons=compileFrags(protProd,glyBion,glyYion,pepBion,pepCion,pepIion,pepYion,pepZion);

end