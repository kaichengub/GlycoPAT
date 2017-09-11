function [MH,z,Spectra]=GetData(fname)  

% Code reads the .dta corresponding to the scan
% number and captures mass, z and Spectra data from this file
% usage example1 : [mass, z, Spectra]=GetData(13176);
% [mass, z, Spectra]=GetData('I:\crash\MATLAB_programs\test\',1031); 
% Don't forget the '\' after the directory name

%files=dir(directory);      % reads directory and puts it in a matlab structure
%filename={files(~[files.isdir]).name}';  % reads filename from structure and puts in cell, excluding directory elements
%filestring=char(filename);   % converts cell array to string array
%scan_str=num2str(scan);       % convert scan number to string
%for i=1:length(filename)
%  if (isempty(findstr(scan_str,filestring(i,:)))==0)    % searches string array for scan number
%      xfile=strcat(directory,filename);
      %Data=load(filestring(i,:));   % load data from file
      Data=load(fname);
      MH=Data(1,1);      % .dta generated M+H is located at (1,1)
      z=Data(1,2);       % .dta generated charge is at (1,2)
      disp(sprintf('Precursor Mass=%f,   z=%u',MH,z));
      Spectra=Data(2:end,:); % the rest is MSn Spetra data. Note: MATLAB is case sensitive
%  end
end