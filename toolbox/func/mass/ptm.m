function ptmmass = ptm(mod)
%PTM: Calculate PTM modification mass
%
%  Syntax:
%       pmass = ptm(modletter)
%
%  Input:
%       modletter: modification by letter
%
%  Output:
%       pmass: modification mass (monoisotopic)
%
% Note: Common PTMs included in program: Mass Differences (Mono, Avg)
% (a) Acetylation     N-term, K   42.01057, 42.037
% (b) Biotinylation   N-term, K   226.07760, 226.293
% (c) Carboxymethyl iodoacetic acid C 58.00548, 58.037
% (e) Pyro-glu   E at N-term   -18.01057, -18.015
% (f) Formylation   N-term 27.99492, 28.010
% (i) Carbamidomethyl iodoacetamide C 57.03404, 57.072
% (n) Sodiation   C-term, D, E 21.98194, 21.982
% (o) Oxidation   H, M, W 15.99492, 15.999
% (p) Phosphorylation   S, T, Y 79.96633, 79.980
% (q) Pyro-glu   Q at N-term   -17.02655, -17.030
% (s) Sulfation     Y           79.9568
%
% Example 1 (for oxidation):
% >> ptm('o')
% Ans: 15.99492
%
% See also: glyMW,pepMW,glypepMW,ptmformula.

% Author: Sriram Neelamegham
% Date Last updated: 08/10/2014 by Gang Liu

% Future work:
% Other modifications that can be added using custom modifications:
% Carbamyl cyanate from alkaline decomp. of urea N-term 43.00581, 43.025
% Methyl ester   C-term, D, E 14.01565, 14.027
% NIPCAM n-isopropyl iodoacetamide C 99.06842, 99.132
% Propionamide acrylamide C 71.03712, 71.079
% S-pyridylethyl 4-vinyl-pyridine C 105.05785, 105.139
% SMA N-Succinimidyl(3-morpholine)acetate N-term, K 127.06333, 127.143
% Sulphone   M 31.98983, 31.999

ptmmass=0;
if (mod=='o')         % oxidation, e.g. Met
    ptmmass=15.99492;
elseif (mod=='s')     % Tyrosine sulfation
    ptmmass=79.9568;
elseif (mod=='i')     % Cys carbamidomethyl modification by iodoacetamide
    ptmmass=57.0214617;
elseif (mod=='c')     % Cys carboxymethyl iodoacetic acid
    ptmmass=58.00548;
elseif (mod=='p')     % Phosphorylation
    ptmmass=79.96633;
elseif (mod=='a')     % N-terminal acetylation
    ptmmass=42.01057;
elseif (mod=='b')     % biotinylation
    ptmmass=226.07760;
elseif (mod=='q')     % Pyro-glu Q at N-term
    ptmmass=-17.02655;
elseif (mod=='e')     % Pyro-glu E at N-term
    ptmmass=-18.01057;
elseif (mod=='f')     % Formylation at N-term
    ptmmass=27.99492;
elseif (mod=='n')     % Sodiation   C-term, D, E
    ptmmass=21.98194;
elseif (mod=='d')     % Deamidation for N, Q 
    ptmmass=0.98438;
end

end