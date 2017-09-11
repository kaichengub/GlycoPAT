function writeSlurmFile(fullslurmfilename,jobname,ppn)
  fid = fopen(fullslurmfilename,'w');
  fprintf(fid,'#!/bin/sh\n');
  fprintf(fid,'#SBATCH --time=72:00:00\n');
  fprintf(fid,'#SBATCH --nodes=1\n');
  fprintf(fid,'#SBATCH --ntasks-per-node=%i\n',ppn);
  fprintf(fid,'#SBATCH --job-name="%s"\n',jobname);
  fprintf(fid,'#SBATCH --output=%s.out\n',jobname);
  fprintf(fid,'#SBATCH --error=%s.err\n',jobname);
  fprintf(fid,'#SBATCH --mail-user=gangliu@buffalo.edu\n');    
  fprintf(fid,'#SBATCH --mail-type=END\n');
  
  fprintf(fid,'echo "SLURM_JOBID=" $SLURM_JOBID\n');
  fprintf(fid,'echo "SLURM_JOB_NODELIST=" $SLURM_JOB_NODELIST\n');
  fprintf(fid,'echo "SLURM_NNODES= " $SLURM_NNODES\n');
  fprintf(fid,'echo "SLURMTMPDIR=" $SLURMTMPDIR\n');
  fprintf(fid,'echo "working directory =" $SLURM_SUBMIT_DIR\n');
  fprintf(fid,'cp /gpfs/projects/neel/Gang/matlab/startup.m startup.m\n');
  fprintf(fid,'cp /gpfs/projects/neel/Gang/matlab/java.opts java.opts\n');
 
  fprintf(fid,'module load matlab/R2013b\n'); 
  fprintf(fid,'module list\n');  
  fprintf(fid,'ulimit -s unlimited\n'); 
  
  fprintf(fid,'echo "Launch MATLAB job"\n');  
  fprintf(fid,'matlab -nodisplay < %s.m\n',jobname); 
  fprintf(fid,'echo "All Done!"\n');  
  fclose(fid);
end