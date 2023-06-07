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

yrst=2019
most=10;
dast=15;
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
        moen=1;
    end
    
    for im=most:1:moen

        if im>=most
        dast=15;
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
        masknan=double(~isnan(SSH));
        SSH(isnan(SSH))=0;
        
        SSHanom=SSH-adtmm(:,:,id);
        SSHanomx=zeros(size(SSHanom));
        numnonnan=zeros(size(SSH));
        
        SSHanomx=SSHanomx+SSHanom;
        numnonnan=numnonnan+masknan;

        end  
        
        SSHanomx=SSHanomx./numnonnan; 
    end
end

latiplot=squeeze(lati(1:40,:));
loniplot=squeeze(loni(1:40,:));

SSHanomxx=detrend(SSHanomx)


figure

P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P)
set(gcf,'PaperPositionMode','auto');
 pcolor(loniplot',latiplot',SSHanomx'.*100);
 
 
 cmocean('balance')
 
 shading flat
 
 colorbar; caxis([-20 20])

 title('Anomalias de la altura del nivel del mar sobre el geoide de la tierra del 15 al 31 de Octubre del 2019')
 
      hold on
      [c,h]=contour(loniplot',latiplot',SSHanomx'.*100,[-20:5:20],'k');
      clabel(c,h);
      
      hold on 

      set(gca,'xtick',[150:10:280],'xticklabel',[[150:10:180] [-170:10:-70]],'xlim',[150 280]);
%       set(gca,'xtick',[-5:1:5],'xlim',[-5 5]);
      xlabel('Longitud'); ylabel('Latitud');
      
   print('SSHwithlat.png','-dpng','-r500')   
   
   
   figure

P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P)
set(gcf,'PaperPositionMode','auto');
 pcolor(loniplot',latiplot',SSHanomxx'.*100);
 
 
 cmocean('balance')
 
 shading flat
 
 colorbar; caxis([-20 20])
 
 title('Picos de anomalias de la altura del nivel del mar sobre el geoide de la tierra del 15 al 31 de Octubre del 2019')


      hold on
      [c,h]=contour(loniplot',latiplot',SSHanomxx'.*100,[-20:5:20],'k');
      clabel(c,h);
      
      hold on 

      set(gca,'xtick',[150:10:280],'xticklabel',[[150:10:180] [-170:10:-70]],'xlim',[150 280]);
%       set(gca,'xtick',[-5:1:5],'xlim',[-5 5]);
      xlabel('Longitud'); ylabel('Latitud');
      
   print('SSHwithlatpeaks.png','-dpng','-r500')   


      
      
