%% Low quality Climatology 

path0='F:\Modelo_sal_temp';
fn='equatorial_data.nc';
fns=fullfile(path0,fn);
 
lat=double(ncread(fns,'latitude'));
lon=double(ncread(fns,'longitude'));
time=double(ncread(fns,'time'))./24;
depth=double(ncread(fns,'depth'));
  
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
% 
[depi,loni]=meshgrid(depth,lon);
depi=depi';
loni=loni';
most=1;
moen=12;
 
iter=0;
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

for im=most:1:moen
    iter=iter+1;
    
    disp(['Month: ' num2str(im)])
        
        indx01=find(mo==im);
         numrec=length(indx01);
    
    for irec=1:1:numrec
        
        sst=mean(double(ncread(fn,'thetao',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1])),2);
        sst=permute(sst,[3 1 2]);
        salt=mean(double(ncread(fn,'so',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1])),2);
        salt=permute(salt,[3 1 2]);
        
        masknan=double(~isnan(sst));
        masknan=double(~isnan(salt));
        sst(isnan(sst))=0;
        salt(isnan(salt))=0;
        
        if irec==1
            sstm=zeros(size(sst));
            numnonnan1=zeros(size(sst));
            saltm=zeros(size(salt));
            numnonnan2=zeros(size(salt));
            
        end
        
        sstm=sstm+sst;
        numnonnan1=numnonnan1+masknan;
        saltm=saltm+salt;
        numnonnan2=numnonnan2+masknan;
    end
    
    sstm=sstm./numnonnan1;
    saltm=saltm./numnonnan2;
    
    SSTs(:,:,iter)=sstm;
    months(im,1)=im;
    
    SALTs(:,:,iter)=saltm;
 
    subplot(1,2,1)
    pcolor(loni,-depi,SSTs(:,:,iter));
    hold on
    [c,h]=contour(loni,-depi,SSTs(:,:,iter),[12:1:30],'k:');
    clabel(c,h);
    colorbar; caxis([12 30]);
    shading flat
    colormap jet
    title(num2str(im));
    
    subplot(1,2,2)
    [c,h]=contourf(loni,-depi,SALTs(:,:,iter),[33:0.1:36],'k:');
    colorbar; clabel(c,h);
    caxis([34 36]);
    shading flat;
    colormap parula
    title(num2str(im));
    
    pause(1)
    clf
    
end
%  save('Climatology1993_2019','SSTs','SALTs','loni','depi','months');
 