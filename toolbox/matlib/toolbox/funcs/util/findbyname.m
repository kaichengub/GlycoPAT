function nameindex = findbyname(fulllist, names)   
 nameindex=cell(1, length(names) );
  for i=1: length(names)    
          [ii jj value]=find(strcmpi(names{i},fulllist));
          nameindex{i} = ii;
  end
end