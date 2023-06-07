%% low quality anomaly 

path0='E:\Modelo_sal_temp';
fn='Climatology1993_2019.mat';
fn1='equatorial_data.nc';
fns=fullfile(path0,fn1);

load(fn);
lat=double(ncread(fns,'latitude'));
lon=double(ncread(fns,'longitude'));
time=double(ncread(fns,'time'))./24;
depth=double(ncread(fns,'depth'));
  
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));

yrst=1993;
yren=2019;

most=1;
moen=10;
moen0=moen;

iter=0;
%aviobj = QTWriter('Low-resol-model-anom.mov','FrameRate',1);%aviobj.Quality = 100;
figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

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
        disp(datestr(datenum(iy,im,28,0,0,0)));
        indx01=find(yr==iy&mo==im);
        
        daynum=datestr(datenum(iy,im,28,0,0,0));
        
        iter=iter+1;
        numrec=length(indx01);
        for irec=1:1:numrec
           disp (['Proceess No.' num2str(irec) ' ... '])
           
            sst=mean(double(ncread(fn1,'thetao',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1])),2);
            sst=permute(sst,[3 1 2]);
            
            salt=mean(double(ncread(fn1,'so',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1])),2);
            salt=permute(salt,[3 1 2]);
            
            if irec==1
                
                sst2=zeros(size(sst));
                salt2=zeros(size(salt));
            end
            SSTanom=sst-SSTs(:,:,im);
            sst2=sst2+SSTanom./length(indx01);
            
            SALTanom=salt-SALTs(:,:,im);
            salt2=salt2+SALTanom./length(indx01);
            
            pr=0;
            pt = theta(salt,sst,depi,pr);
            sigma0=sigmat(pt,salt);

        end
    
        subplot(2,1,1)
        pcolor(loni,-depi,sst2);
        hold on
        [c,h]=contour(loni,-depi,sst2,[-6:1:6],'k:');
        clabel(c,h);
        colorbar; caxis([-6 6]);
        shading flat
        cmocean('balance');
        title(['SST anom ' daynum]);
        c=colorbar;
        c.Label.String='Temperature (ºC)';
        ylabel('Depth');
        set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);

        subplot(2,1,2)
        [c,h]=contourf(loni,sigma0,salt2,[-1:0.1:1],'k:');
        colorbar; clabel(c,h);
        caxis([-2 2]);
        shading flat;
        cmocean('balance');
        title(['SSS anom ' daynum]);
        c=colorbar;
        c.Label.String='Salinidad (ups)';
        set(gca, 'YDir','reverse');
        ylabel('Sigma theta');
        ylim([20.8 26.8]);
        set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);

        pause(0.1)
        
        %M1=getframe(gcf);
        %writeMovie(aviobj, M1);  
        clf
    
    
    
end 
end

%close(aviobj);