fn='SSHdayli2018to20191131.nc';
lat=ncread(fn,'latitude');
lon=ncread(fn,'longitude');
time=ncread(fn,'time');
adts=ncread(fn,'adt');



[loni,lati]=meshgrid(lon,lat);


time=double(time);
lon=double(lon);
lat=double(lat);
adts=double(adts);

time=time+datenum(1950,1,1,0,0,0);
[yr,mo,da,hr,mi,se]=datevec(time);

yrst=2018
most=1;
dast=1;
yren=2019
moen=10;
moen0=moen;
daen=30;
daen0=daen;

load('SSS1993_20191DayliClim.mat');

iter=0;



for iy=yrst:1:yren
    % if iy is greater than yrst, then let most is 1
    if iy>yrst
        most=1;
    end
    
    if iy==2019
        moen=moen0;
    else % otherwise, moen is 12
        moen=12;
    end
    
    for im=most:1:moen

        if im>=most
        dast=1;
        end
        
        if im==2
           daen=28;
        else 
           daen=30;
        
        end   
        
        for id=dast:1:daen
            
        iter=iter+1;
         
      
        disp(datestr(datenum(iy,im,id,0,0,0)));
        indx=find(yr==iy & mo==im & da==id);
             
        if length(indx)>1
            disp('index has more than two entries')
            datestr(time(indx))
        elseif isempty(indx)==1
            error('there is no ssh data')
        end  

        
        SSH=ncread(fn,'adt',[1 1 indx(1)],...
                 [length(lon) length(lat) 1],[1 1 1]);
        SSH=SSH';
        
        SSHanom=SSH-adtmm(:,:,id);
        
        SSHanomplot=mean(SSHanom,1);
        
        SSHanomplots(:,iter)=SSHanomplot;
        timeisplot(:,iter)=repmat(datenum(iy,im,id,0,0,0),[size(SSHanomplot) 1]);
        lons(:,iter)=lon;
       
         end  
    end
end



figure

P=get(gcf,'position');
P(3)=P(3)*1.5;
P(4)=P(4)*3;
set(gcf,'position',P)
set(gcf,'PaperPositionMode','auto');

pcolor(lons,timeisplot,SSHanomplots.*100);
 
shading flat

cmocean('balance')
 
colorbar; caxis([-20 20])

 
      hold on
      [c,h]=contour(lons,timeisplot,SSHanomplots.*100,[-20:05:20],'k');
      clabel(c,h);
      
      
       
      colorbar; 
      
        
      hold on 

      set(gca,'xtick',[150:10:280],'xticklabel',[[150:10:180] [-170:10:-70]],'xlim',[150 280]);
      datetick('y','YY/mm');
      set(gca, 'YDir', 'reverse')
      xlabel('Longitud'); ylabel('Tiempo (YY/mm)');
      
 print('SSH.png','-dpng','-r500')   
      
 
      