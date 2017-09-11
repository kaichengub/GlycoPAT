function writeSlurmMatlabFile(fullmatlabslurmfilename,jobname,ppn,totalworkers)
  fid = fopen(fullmatlabslurmfilename,'w');
  [path,filenamewoext,ext]=fileparts(fullmatlabslurmfilename);
  fprintf(fid,'function f=%s()\n',filenamewoext);
  fprintf(fid,'startupSlurm;\n');
  fprintf(fid,'StorageLocation=''/gpfs/scratch/gangliu/matlab'';\n');
  fprintf(fid,'ppn=%i;\n',ppn);
  fprintf(fid,'time=''72:00:00'';\n');
  fprintf(fid,'email=''gangliu@buffalo.edu'';\n');
  fprintf(fid,'set(u2,''JobStorageLocation'',StorageLocation,''CommunicatingSubmitFcn'',...\n');
  fprintf(fid,'{@communicatingSubmitFcnSlurm,ppn,time,email});\n');    
  fprintf(fid,'pjob = createCommunicatingJob(u2);\n');
  
  fprintf(fid,'pjob.NumWorkersRange = [1 %i];\n',totalworkers);
  fprintf(fid,'set(pjob, ''AttachedFiles'',{''%s.m''})\n',jobname);
  fprintf(fid,'createTask(pjob,@%s,2,{});\n',jobname);
  fprintf(fid,'submit(pjob);\n');
  fprintf(fid,'f=pjob;\n');
  fclose(fid);
end