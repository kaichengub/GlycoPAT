function writeCCRMfile(mfilename,pepfilefullname,xmlfilepath,mzxmlfilename,OutCSVname,maxlag,...
        fragMode,MS1tol,MS1tolUnit,MS2tol,MS2tolUnit,OutputDir,cutOffMed,fracMax,scorecommand)
  fid = fopen(mfilename,'w');
  [filepath,filenamewext,filext] = fileparts(mfilename);
  if(~strcmpi(filext,'.m'))
      error('MATLAB:GlycoPAT:ERRORINPUT','M FILE NAME IS NOT CORRECT');
  end
  fprintf(fid,'function [calchit,runtime]=%s()\n',filenamewext);
  fprintf(fid,'tic;\n'); 
  fprintf(fid,'Pepfile= ''%s'';\n',pepfilefullname);
  fprintf(fid,'xmlfilepath = ''%s'';\n',xmlfilepath);
  fprintf(fid,'mzxmlfilename = ''%s'';\n',mzxmlfilename);
  fprintf(fid,'fragMode = ''%s'';\n',fragMode);
  fprintf(fid,'MS1tol = %f;\n',MS1tol);
  fprintf(fid,'MS1tolUnit = ''%s'';\n',MS1tolUnit);
  fprintf(fid,'MS2tol = %f;\n',MS2tol);
  fprintf(fid,'MS2tolUnit = ''%s'';\n',MS2tolUnit);
  fprintf(fid,'OutputDir = ''%s'';\n',OutputDir);
  fprintf(fid,'OutCSVname = ''%s'';\n',OutCSVname);
  fprintf(fid,'maxlag = %i;\n',maxlag);
  fprintf(fid,'CutOffMed = %f;\n',cutOffMed); 
  fprintf(fid,'FracMax = %f;\n',fracMax);
  fprintf(fid,'nmFrag = 0;\n');
  fprintf(fid,'npFrag = 2;\n'); 
  fprintf(fid,'ngFrag = 0;\n');  
  fprintf(fid,'veryLabilePTM = {''<s>''};\n');
  fprintf(fid,'pseudoLabilePTM = {};\n');
  fprintf(fid,'selectPeak =[163.1,292.1,366,454.1,657.2];\n');  
  fprintf(fid,'calchit = %s(Pepfile,xmlfilepath,fragMode,MS1tol,MS1tolUnit,MS2tol,MS2tolUnit,...\n',scorecommand);  
  fprintf(fid,'OutputDir,OutCSVname,maxlag,CutOffMed,FracMax,nmFrag,npFrag,ngFrag,selectPeak,...\n');  
  fprintf(fid,'false,mzxmlfilename);\n');
  [~,OutCSVnamewoext,~] = fileparts(OutCSVname);
  fprintf(fid,'toc\n');
  fprintf(fid,'runtime = toc;\n');
  fprintf(fid,'save(''%s.mat'',''calchit'');\n',OutCSVnamewoext);
  fclose(fid);
end