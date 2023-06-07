sshk=1.2;

yrst=2017;
yren=2019;
most=7;
moend=12;

%sshpath
load('20170701_20190831');
% load('etopo.mat');
lon=longitude;
lat=latitude;
 [yr,mo,da,hr,mi,se]=datevec(timechl);
 
 figure
 for iy=yrst:1:yren
     
     if iy==yren
         mend=8;
     else
     end
     for im=most:1:moend
         for dai=1:1:31
             
             indx01=find(yr==iy&mo==im&da==dai);
             
             daynum=datestr(datenum(iy,im,dai,0,0,0));
             
             for i=1:length(indx01)
                disp (['Proceess No.' num2str(i) ' ... '])
                
                chl=chlor(:,:,indx01(1));
                lon=longitude(:,indx01(1));
                lat=latitude(:,indx01(1));
                
%                 chl=chl;
                
            pcolor(lon,lat,chl');
            shading flat
            colormap; colorbar;
            hc=colorbar;
            caxis(log10([0.5 8]));
            colormap jet
            set(hc,'ticks',log10([0.5 1 2 3 4 5 6 7 8]),...
                  'ticklabels',[0.5 1 2 3 4 5 6 7 8],'TickDirection',('out'));
            title([daynum]);
            pause(0.4);
            clf   
         
             end
         end
     end
 end
 
         