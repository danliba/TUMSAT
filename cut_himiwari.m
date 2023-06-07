yrst=2017;
most=11;
moend=12;
yren=2019;
range=[115 180 15 55];

for iy=yrst:1:yren
    
    
    if iy>yrst
        most=1;
    end
       
    if iy==yren
        moend=8;
    else
        mo=moend;
    end
    
    for imo=most:1:moend
        
        
    path0=sprintf('/Volumes/ftp.ptree.jaxa.jp/pub/himawari/L3/CHL/010/%02d%02g/daily',iy,imo);
    
     hdir=dir(fullfile(path0,'*02401_02401.nc'));
        
       
        for ichl=1:1:size(hdir,1);
            
            
            fname=fullfile(path0,hdir(ichl).name);
            
 
            
            
            
lon=ncread(fname,'longitude');
la=ncread(fname,'latitude');
time=ncread(fname,'start_time');

la=double(la);
lon=double(lon);

indxlon=find(range(1)<=lon & lon<=range(2));
indxlat=find(range(3)<=la & la<=range(4));
[loni,lati]=meshgrid(indxlon,indxlat);
lon2=lon(indxlon);
lat2=la(indxlat);


% convert julian date of SSH to MATLAB julian date
 time=time+datenum(1858,11,17,0,0,0);
% get time vector with year, month, date, hour, minite, second
 [yr,mo,da,hr,mi,se]=datevec(time);
 daynum=datenum(yr,mo,da,0,0,0);
 
 chl=ncread(fname,'chlor_a',[indxlon(1) indxlat(1)],...
     [size(loni,2) size(lati,1)],[1 1]);
 
 chl=chl';
            
%             pcolor(lon2,lat2,chl);
%             shading flat;
%             colormap; colorbar;
%             hc=colorbar;
%             caxis(log10([0.5 8]));
%             colormap jet
%             set(hc,'ticks',log10([0.5 1 2 3 4 5 6 7 8]),...
%                 'ticklabels',[0.5 1 2 3 4 5 6 7 8],'TickDirection',('out'));
%             title(datestr(datenum(yr,mo,da,0,0,0)));
%             xlim([120 180]); ylim([15 50]);
%             hold on
%             %[c,h]=contour(loni,lati,chl,log10([5 8]),'k');
%             load coast
%             plot(long,lat,'w');

HWR='/Volumes/KINGSTON/himiwari data/CHL';
         mfile=fullfile(HWR,[datestr(datenum(yr,mo,da,0,0,0),'yyyymmdd')]);
         save(mfile,'time','lon2','lat2','chl');
         
        end
    end
end


         
       
   