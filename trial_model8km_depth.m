%% Trial model-high-resol-Lon-depth-view

%range longitude
range1=[140 180 -180 -80];
%range latitude for SST and Salt
range2=[-0.5 0.5];
%range latitude for SSH
range3=[-5 5];
%range depth
range0=[0 600];

path1='D:\descargas';
fn='mercatorglorys12v1_gl12_mean_19930101_R19930106.nc';
fns=fullfile(path1,fn);

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

%[lati,loni2]=meshgrid(lat2,lonA);

%Temperature
  sstA=nanmean(double(ncread(fns,'thetao',[indxlon(1) indxlat(1) indxdep(1) 1],...
     [length(lonA) length(lat2) length(depth2) 1],[1 1 1 1])),2);
 
  sstB=nanmean(double(ncread(fns,'thetao',[indxlon2(1) indxlat(1) indxdep(1) 1],...
     [length(lonB) length(lat2) length(depth2) 1],[1 1 1 1])),2);
 
 %Salinity
  saltA=nanmean(double(ncread(fns,'so',[indxlon(1) indxlat(1) indxdep(1) 1],...
     [length(lonA) length(lat2) length(depth2) 1],[1 1 1 1])),2);
 
  saltB=nanmean(double(ncread(fns,'so',[indxlon2(1) indxlat(1) indxdep(1) 1],...
     [length(lonB) length(lat2) length(depth2) 1],[1 1 1 1])),2);
 
%%SSH
  sshA=double(ncread(fns,'zos',[indxlon(1) indxlatssh(1) 1],...
     [length(lonA) length(latssh) 1],[1 1 1]));
 
  sshB=double(ncread(fns,'zos',[indxlon2(1) indxlatssh(1) 1],...
     [length(lonB) length(latssh) 1],[1 1 1]));

 
 %%Catting data
 SST=cat(1,sstA,sstB);
 SST=permute(SST,[3 1 2]);
 
 SSS=cat(1,saltA,saltB);
 SSS=permute(SSS,[3 1 2]);
 
 SSH=cat(1,sshA,sshB);
 SSH=SSH';
  
 longitude=cat(1,lonA,lonB+360);
 
 %meshgrid
 [depi,loni]=meshgrid(depth2,longitude);
 [latissh,lonissh]=meshgrid(latssh,longitude);
 %flipping
  loni=loni';
  depi=depi';
  lonissh=lonissh';
  latissh=latissh';


% pcolor(lonissh,latissh,SSH); shading flat
% set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);

%Plot
subplot(2,1,1)
pcolor(loni,-depi,SST);
shading flat;
colormap parula;
colorbar;
hold on
set(gca,'xtick',[140:10:280],'xticklabel',[[140:10:180] [-170:10:-80]],'xlim',[140 280]);
[c,h]=contour(loni,-depi,SST,[10:2:30],'k:');
clabel(c,h);
caxis([8 30]);

subplot(2,1,2)
pcolor(loni,-depi,SSS);
shading flat;
colormap parula;
colorbar;
hold on
set(gca,'xtick',[140:10:280],'xticklabel',[[140:10:180] [-170:10:-80]],'xlim',[140 280]);
[c,h]=contour(loni,-depi,SSS,[33:0.2:36],'k:');
clabel(c,h);
caxis([33 36]);
pause(1)
clf

MD='D:\CIO\Modelo';
         mfile=fullfile(MD,[datestr(datenum(yr,mo,da,0,0,0),'yyyymmdd')]);
         save(mfile,'timemodel','loni','latissh','depi','lonissh','SST','SSS','SSH');


%%create nc




