fileinfo=dir('A*.nc');
%fileinfo=dir('2*.nc');
infns=[];
for i=1:1:size(fileinfo,1)
    fnnow=fileinfo(i).name;
    infns=[infns ' ' fnnow];
    
    time=ncread(fnnow,'time');
    
    [yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1900,1,1,0,0,0));
    for iy=yr(end,1:end)
        for im=mo(end,1:end)
            for id=da(end,1:end)
                
                daynum=datestr(datenum(iy,im,id,0,0,0));
                daynum2=daynum(end,1:end);
    
    if i==1
        outfn=['B' fnnow(2) '.nc'];
    elseif i==size(fileinfo,1)
        outfn=[outfn fnnow(2) daynum2(end,1:end) '.nc'];
    end
    
    eval(['!/opt/local/bin/ncks -O --mk_rec_dmn time  ' outfn ' ' outfn])
            end
        end
    end
   
end
