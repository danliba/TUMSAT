%% Trial model-high-resol-Lon-Lat-view

range1=[120 180 -180 -60];
range2=[-20 20];
range0=[0 600];

path1='D:\descargas';
fn='mercatorglorys12v1_gl12_mean_19930101_R19930106.nc';
fns=fullfile(path1,fn);

lat=double(ncread(fns,'latitude'));
lon=double(ncread(fns,'longitude'));
time=double(ncread(fns,'time'))./24;
depth=double(ncread(fns,'depth'));
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));

indxlon=find(range1(1)<=lon & lon<=range1(2));
indxlon2=find(range1(3)<=lon & lon<=range1(4));
indxlat=find(range2(1)<=lat & lat<=range2(2));
indxdep=find(range0(1)<=depth & depth<=range0(2));

lonA=lon(indxlon);
lonB=lon(indxlon2);
lat2=lat(indxlat);
depth2=depth(indxdep);

% [depi,loni]=meshgrid(depth2,lon2);
% loni=loni';
% depi=depi';

%[lati,loni2]=meshgrid(lat2,lonA);


%  sst=nanmean(double(ncread(fns,'thetao',[indxlon(1) indxlat(1) indxdep(1) 1],...
%     [length(lon2) length(lat2) length(depth2) 1],[1 1 1 1])),2);
%  sst=permute(sst,[3 1 2]);


  sstA=double(ncread(fns,'thetao',[indxlon(1) indxlat(1) indxdep(1) 1],...
     [length(lonA) length(lat2) length(depth2) 1],[1 1 1 1]));
 
  sstB=double(ncread(fns,'thetao',[indxlon2(1) indxlat(1) indxdep(1) 1],...
     [length(lonB) length(lat2) length(depth2) 1],[1 1 1 1]));
 
 SST=cat(1,sstA,sstB);
 SST=permute(SST,[2 1 3]);
 
 longitude=cat(1,lonA,lonB+360);
 [lati,loni]=meshgrid(lat2,longitude);
 lati=lati';
 loni=loni';

 
pcolor(loni,lati,SST(:,:,1));
shading flat
colorbar
set(gca,'xtick',[120:5:300],'xticklabel',[[120:5:180] [-175:5:-60]],'xlim',[120 300]);

