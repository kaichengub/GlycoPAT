clc;
clear;
pathname = pwd;
pepfilefullnamearray_gluc{1} = '/ifs/projects/neel/msdata/fusionprotmix/digestedpeptide/digested4pro_gluc_2miss50maxpep1maxmod.txt';
pepfilefullnamearray_gluc{2} = '/ifs/projects/neel/msdata/fusionprotmix/digestedpeptide/digested4pro_gluc_2miss50maxpep2maxmod.txt';

pepfilefullnamearray_tryp{1} = '/ifs/projects/neel/msdata/fusionprotmix/digestedpeptide/digested4pro_tryp_2miss50maxpep1maxmod.txt';
pepfilefullnamearray_tryp{2} = '/ifs/projects/neel/msdata/fusionprotmix/digestedpeptide/digested4pro_tryp_2miss50maxpep2maxmod.txt';

mzxmlfilefullname1_tryp_cid  = '/ifs/projects/neel/msdata/fusionprotmix/B01_01_140615_Sri_Try_CID_IT.mzXML';
mzxmlfilefullname2_gluc_cid  = '/ifs/projects/neel/msdata/fusionprotmix/B01_02_140615_Sri_GluC_CID_IT.mzXML';

mzxmlfilefullname3_tryp_hcd  = '/ifs/projects/neel/msdata/fusionprotmix/B01_03_140615_Sri_Try_HCD_IT.mzXML';
mzxmlfilefullname4_gluc_hcd  = '/ifs/projects/neel/msdata/fusionprotmix/B01_04_140615_Sri_GluC_HCD_IT.mzXML';

mzxmlfilefullname7_tryp_cid  = '/ifs/projects/neel/msdata/fusionprotmix/B01_07_140615_Sri_Try_CID_IT.mzXML';
mzxmlfilefullname8_gluc_cid  = '/ifs/projects/neel/msdata/fusionprotmix/B01_08_140615_Sri_GluC_CID_IT.mzXML';

mzxmlfilefullname9_tryp_cid  = '/ifs/projects/neel/msdata/fusionprotmix/B01_09_140615_Sri_Try_HCD_IT.mzXML';
mzxmlfilefullname10_gluc_cid = '/ifs/projects/neel/msdata/fusionprotmix/B01_10_140615_Sri_GluC_HCD_IT.mzXML';

jobstartid              = 19;
joboristartid = jobstartid;
curdatevec              = datevec(date);
arrayjob1=createArrayCCRJob(pathname,pepfilefullnamearray_gluc,mzxmlfilefullname2_gluc_cid,jobstartid,curdatevec,2);
jobendid = jobstartid+2;
jobstartid = jobendid;
arrayjob2=createArrayCCRJob(pathname,pepfilefullnamearray_gluc,mzxmlfilefullname4_gluc_hcd,jobstartid,curdatevec,2);
jobendid = jobstartid+2;
jobstartid = jobendid;
% arrayjob3=createArrayCCRJob(pathname,pepfilefullnamearray_gluc,mzxmlfilefullname8_gluc_cid,jobstartid+4,curdatevec,2);
% arrayjob4=createArrayCCRJob(pathname,pepfilefullnamearray_gluc,mzxmlfilefullname10_gluc_cid,jobstartid+6,curdatevec,2);
% 
% arrayjob5=createArrayCCRJob(pathname,pepfilefullnamearray_tryp,mzxmlfilefullname1_tryp_cid,jobstartid+8,curdatevec,2);
% arrayjob6=createArrayCCRJob(pathname,pepfilefullnamearray_tryp,mzxmlfilefullname3_tryp_hcd,jobstartid+10,curdatevec,2);
% arrayjob7=createArrayCCRJob(pathname,pepfilefullnamearray_tryp,mzxmlfilefullname7_tryp_cid,jobstartid+12,curdatevec,2);
% arrayjob8=createArrayCCRJob(pathname,pepfilefullnamearray_tryp,mzxmlfilefullname9_tryp_cid,jobstartid+14,curdatevec,2);

arrayjobs=[arrayjob1';arrayjob2'];

monthstr = sprintf('%02i',curdatevec(2));
datestr  = sprintf('%02i',curdatevec(3));

jobarrayfile = ['jobarray_',int2str(joboristartid),'_',int2str(jobendid),'_',monthstr,'_',datestr,'.csv'];
fid=fopen(jobarrayfile,'w');
struct2csv(arrayjobs,fid);