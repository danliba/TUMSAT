fn1='SSH1993_2019.nc';
sshK=1.2;
range=[115 165 22 48];
L1=ncread(fn1,'latitude');
L2=ncread(fn1,'longitude');
T=ncread(fn1,'time');

[loni,lati]=meshgrid(L2,L1);
% loni=double(L2);
% lati=double(L1);

maskssh=double(range(1)<=loni & loni<=range(2) &...
                range(3)<=lati & lati<=range(4));
maskssh(maskssh==0)=NaN;

[yr,mo,da,hr,mi,se]=datevec(double(T)+datenum(1950,1,1,0,0,0));
load('etopo.mat');
load('20170701_20190831');
[yrcl,mocl,dacl,hrcl,micl,secl]=datevec(timechl);

lonissh=double(loni);
latissh=double(lati);

yrst=2019;
yren=2019;
most=1;
moend=1;

disti=0:5000:6e6;
iter=0;

aviobj = QTWriter('HW8.mov','FrameRate',2);%aviobj.Quality = 100;
figure
for iy=yrst:1:yren
        if iy==2019
            mend=1;
            
%         else mend=12;
        end
    for im=most:moend
        if im==10
            daend=30;
        else
        end
        for dai=12:1:31
            
        
        indx01=find(yr==iy&mo==im&da==dai);
        indx02=find(yrcl==iy&mocl==im&dacl==dai);
        
%         for im=1:1:mend
            daynum2=num2str(datenum(iy,im,0,0,0,0));
            daynum=datestr(datenum(iy,im,dai,0,0,0));
            
            % datetxt2=[daynum(8:end) daynum(3:7) daynum(1:2)];
            
            for i=1:length(indx01)
                disp (['Proceess No.' num2str(i) ' ... '])
                
                ssh=ncread(fn1,'adt',[1 1 indx01(i)],[Inf Inf 1],[1 1 1]);
                
                ssh=ssh';
                iter=iter+1;
        
                [lonk, latk]=Extract_KuroshioAxis(ssh.*maskssh, lonissh, latissh,sshK);
        % find the indice of the Kuroshio path where latitude is greater
        % than 24 degree north of Taiwan
                indxpath=find(latk>24);
                
                latk=latk(indxpath);
                lonk=lonk(indxpath);
                
                dx=distance(latk(2:end),lonk(2:end),latk(1:end-1),lonk(1:end-1)).*60.*1852;
        % compute the distance from the north of Taiwan by cumulative sum
                distx=cat(2,0,cumsum(dx));
                
                lonki=interp1(distx,lonk,disti);
                latki=interp1(distx,latk,disti);
                
                chl=chlor(:,:,indx02(1));
                lon=longitude(:,indx02(1));
                la=latitude(:,indx02(1));

                pcolor(lon,la,chl); colorbar;
                shading flat
                colormap; colorbar;
                hc=colorbar;
                caxis(log10([0.5 8]));
                colormap jet
                set(hc,'ticks',log10([0.5 1 2 3 4 5 6 7 8]),...
                  'ticklabels',[0.5 1 2 3 4 5 6 7 8],'TickDirection',('out'));
                title([daynum]);
                xlim([120 180]); ylim([15 50]);
                hold on
                plot(lonki,latki,'r','Linewidth',2);
                load coast
                plot(long,lat,'k');
                axis([115 180 15 50]);
                
                hold on
                contour(lonb,latb,topo,[-1000 1000],'k');
%                 
                M1=getframe(gcf);
                writeMovie(aviobj, M1);

                pause(0.4);
            clf
                
            end
        end
            

        
    end
end

close(aviobj);
