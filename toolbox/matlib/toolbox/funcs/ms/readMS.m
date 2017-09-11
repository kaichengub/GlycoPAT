function mzInt = readMS(msrawdatafilename,varargin)
%readMS convert MS raw peak data to a two-column 
%  matrix comprising of mz and intensity value. 
%
% mzInt = readMS(MSDFILENAME) reads MS data in msd file
%  format and returns a 2*1 matrix containing mz and 
%  intensity value.
% 
% Example: 
%       mzInt = readMS('testCHO.msd');
% 
%See also MSPROCESS.

% Author: Gang Liu
% Last Date Updated: 2/20/13 2:10 PM 

narginchk(1,2);

if(length(varargin)==1)
    fileformat=varargin{1};
else
   fileformat = 'msd'; 
end

if(isequal(fileformat,'msd'))
   mzInt= dlmread(msrawdatafilename, '\t', 2, 0); % Skip the first two lines of RAW Data file. 
else
   error('MATLAB:GNAT:NONSUPPORTEDFILETYPE','FILE TYPE NOT SUPPORTED');
end  
