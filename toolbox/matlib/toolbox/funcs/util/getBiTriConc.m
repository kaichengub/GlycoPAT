function[sumbiconc sumtriconc]=getBiTriConc(data,biindex, triindex)
    x =data(:,cell2mat(biindex));
    conc_bi.conc=x(size(x,1),:);
    sumbiconc = sum(conc_bi.conc);

   x =data(:,cell2mat(triindex));  
   conc_tri.conc=x(size(x,1),:);
  sumtriconc=sum(conc_tri.conc);
 %disp('end');
end
