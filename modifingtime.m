fileinfo=dir('A*b.nc');
%fileinfo=dir('2*.nc');
infns=[];
for i=1:1:size(fileinfo,1)
    fnnow=fileinfo(i).name;
    infns=[infns ' ' fnnow];
    if i==1
        outfn=['A_' fnnow(2) 'b.nc'];
    elseif i==size(fileinfo,1)
        outfn=[outfn fnnow(2) '.nc'];
    end
    
end
 eval(['!/opt/local/bin/ncks -O --mk_rec_dmn time  ' outfn ' ' outfn])
%(2) stands for the position number of the digit 2%
