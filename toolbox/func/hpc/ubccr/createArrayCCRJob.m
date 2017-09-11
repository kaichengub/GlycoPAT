function jobarray=createArrayCCRJob(pathname,pepfilefullnamearray,mzxmlfilefullname,...
				    jobstartid,curdatevec,usePar,ppn,numworkers,MS1tol,MS2tol,MS2tolUnit)
monthstr = sprintf('%02i',curdatevec(2));
datestr  = sprintf('%02i',curdatevec(3));
%MS1tol     = 10;
%MS2tol     = 1;
%MS2tolUnit = 'Da';

slurmmatlabfilearray = cell(length(pepfilefullnamearray),1);
for i = 1 : length(pepfilefullnamearray)
    pepfilefullname = pepfilefullnamearray{i};
    jobindex = jobstartid + i - 1;
    jobname{i}  = ['j',int2str(jobindex),'_',monthstr,datestr];
    [slurmfilename,slurmmatlabfilearray{i}] = createSingleCCRJob(pathname,jobname{i},...
        pepfilefullname,mzxmlfilefullname,...
        MS1tol,MS2tol,MS2tolUnit,usePar,ppn,numworkers);
end

if((usePar==2)|| (usePar==1))
    ishpc = 1;
else
    ishpc = 0;
end

% exceute matlab slurm file
for i=1: length(pepfilefullnamearray)
    slurmmatlabfilename = slurmmatlabfilearray{i};
    [slurmpath,slurmfilenamewoext,ext]=fileparts(slurmmatlabfilename);

    % enter the directory
    if(ishpc)
        cddircmd = sprintf('cd %s',slurmpath);    
        eval(cddircmd);

        % run the function
        slurmfunhandle = str2func(slurmfilenamewoext);
        ithjob = feval(slurmfunhandle);
        jobarray(i).jobname           = ithjob.ID;  
        jobarray(i).slurmmfilename    = slurmfilenamewoext;
        
        % leaving the directory
        cdupperdircmd = sprintf('cd ..');    
        eval(cdupperdircmd);
    else
        jobarray(i).jobname           = jobname{i};
        jobarray(i).slurmmfilename    = slurmfilenamewoext;
    end
    
    jobarray(i).slurmpath         = slurmpath;
    jobarray(i).mzxmlfile         = mzxmlfilefullname;
    jobarray(i).glycopepfile      = pepfilefullnamearray{i};
end

    
end
