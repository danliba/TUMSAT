yrst=1993;
most=1;
moen=1;
moen0=moen;
yren=1993;

%range longitude
range1=[140 180 -180 -80];
%range latitude for SST and Salt
range2=[-0.5 0.5];
%range latitude for SSH
range3=[-5 5];
%range depth
range0=[0 600];

for iy=yrst:1:yren
    
    if iy>yrst
        most=1;
    end
    
    if iy==yren
        moen=moen0;
    else
        moen=12;
    end
    
    for im=most:1:moen
        
    path0=sprintf('F:\\%02d\\%02g',iy,im);
    
    hdir=dir(fullfile(path0,sprintf('mercatorglorys12v1_gl12_mean_%02d%02g*.nc',iy,im)));
    
    for imodel=1:1:size(hdir,1);
        
        fns=fullfile(path0,hdir(imodel).name);
        
        
        lat=double(ncread(fns,'latitude'));
        lon=double(ncread(fns,'longitude'));
        time=double(ncread(fns,'time'))./24;
        depth=double(ncread(fns,'depth'));
        [yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
        
        timemodel=datenum(yr,mo,da,0,0,0);

        indxlon=find(range1(1)<=lon & lon<=range1(2));
        indxlon2=find(range1(3)<=lon & lon<=range1(4));
        indxlat=find(range2(1)<=lat & lat<=range2(2));
        indxlatssh=find(range3(1)<=lat & lat<=range3(2));
        indxdep=find(range0(1)<=depth & depth<=range0(2));
        
        %longitude
        lonA=lon(indxlon);
        lonB=lon(indxlon2);
        %latitude
        lat2=lat(indxlat);
        latssh=lat(indxlatssh);
        %depth
        depth2=depth(indxdep);

       %Temperature
        sstA=nanmean(double(ncread(fns,'thetao',[indxlon(1) indxlat(1) indxdep(1) 1],...
         [length(lonA) length(lat2) length(depth2) 1],[1 1 1 1])),2);

        sstB=nanmean(double(ncread(fns,'thetao',[indxlon2(1) indxlat(1) indxdep(1) 1],...
         [length(lonB) length(lat2) length(depth2) 1],[1 1 1 1])),2);
     
         %%Catting data
        SST=cat(1,sstA,sstB);
        SST=permute(SST,[3 1 2]);
        
            %meshgrid
        [depi,loni]=meshgrid(depth2,longitude);
        [latissh,lonissh]=meshgrid(latssh,longitude);
     %flipping
        loni=loni';
        depi=depi';
        lonissh=lonissh';
        latissh=latissh';
        
        
      MD='D:\CIO\Modelo';
                 mfile=fullfile(MD,[datestr(datenum(yr,mo,da,0,0,0),'yyyymmdd')]);
                 save(mfile,'timemodel','loni','depi','SST');
    
    end
    end
end
        