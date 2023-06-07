fn='datanorthpacificdepth.nc';
lat=ncread(fn,'latitude');
lon=ncread(fn,'longitude');
depth=ncread(fn,'depth');
time=ncread(fn,'time')./24;

[loni,lati,depthi]=meshgrid(lon,lat,depth);


time=double(time);
lon=double(lon);
lat=double(lat);
depth=double(depth);


time=time+datenum(1950,1,1,0,0,0);
[yr,mo,da,hr,mi,se]=datevec(time);

% range0=[0 300];
% indxdep=find(range0(1)<=depth & depth<=range0(2));


figure
for i=1:1:12
    disp(['Month:' num2str(i)])
    indx01=find(mo==i);
    numrec=length(indx01);
% 
%  for   di=1:1:12
%        indepth=find(indxdep==di);
%        numdepth=length(indepth);
       
%     for idepth=1:1:numdepth
     for irec=1:1:numrec
        
        sss=ncread(fn,'so',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1]);
        sss=permute(sss,[2 1 3 4]);
        masknan=double(~isnan(sss));
        sss(isnan(sss))=0;
        
        if irec==1
            sssm=zeros(size(sss));
            numnonnan=zeros(size(sss));
            
        end
        
        sssm=sssm+sss;
        numnonnan=numnonnan+masknan;
     end
%     end
    
    sssm=sssm./numnonnan;
    
    ssss(:,:,:,i)=sssm;
    months(i,1)=i;
    
%     depths(di,1)=di;

    saliplot(:,:,i)= squeeze(ssss(:,260,:,i));
    latiplot = squeeze(lati(:,260,:));
    depthplot = squeeze(depthi(:,260,:));
       
    pcolor(latiplot',-depthplot',saliplot(:,:,i)');
    colorbar; caxis([33 36]);
    shading flat
    colormap jet
    hold on
    [c,h]=contour(latiplot',-depthplot',saliplot(:,:,i)','k');
  
    hold on
  
    pause(0.4)
    clf
end

 save('SSS1993_201811MontlyClim12label12','ssss','loni','lati','depthi','months');