%%Reading himiwari satellite

% mo=8:12;
% da=1:30;
% [moi,dai]=meshgrid(mo,da);
% moi=moi';
% dai=dai';

most=2;
dast=2;
daend=31;
moend=7;

aviobj = QTWriter('2018HW-2.mov','FrameRate',3);
for im=most:1:moend
    yr=2018;
    
    if im>most
        dast=1;
    end
       
    if im==moend
        daend=3;
    else
        da=daend;
    end
    
    for ida=dast:1:daend

path0=sprintf('/Volumes/ftp.ptree.jaxa.jp/pub/himawari/L3/CHL/010/2018%02d/%02g',im,ida);
%path0='/Volumes/ftp.ptree.jaxa.jp/pub/himawari/L3/CHL/010/201711/14';

%aviobj.Quality = 100;

%hdir=dir([path0 '/*FLDK.02401_02401*nc']);
for i=0:100:2300
    if 800<= i && i<= 2000
    else
        
        %
        %H08_20170801_0300_1H_ROC010_FLDK.02401_02401.nc
        
        hdir=dir(fullfile(path0,sprintf('H08_2018%02d%02g_%04d_1H_ROC010_FLDK.02401_02401.nc',im,ida,i)));
        
        for ichl=1:1:size(hdir,1);
            
            fname=fullfile(path0,hdir(ichl).name);
            
            
            lon=ncread(fname,'longitude');
            la=ncread(fname,'latitude');
            chl=ncread(fname,'chlor_a');
            time=ncread(fname,'start_time');
            
            [loni,lati]=meshgrid(lon,la);
            
            % convert julian date of SSH to MATLAB julian date
            time=time+datenum(1858,11,17,0,0,0);
            % get time vector with year, month, date, hour, minite, second
            [yr,mo,da,hr,mi,se]=datevec(time);
            
            chl=chl';
            
            pcolor(loni,lati,chl);
            shading flat;
            colormap; colorbar;
            hc=colorbar;
            caxis(log10([0.5 8]));
            colormap jet
            set(hc,'ticks',log10([0.5 1 2 3 4 5 6 7 8]),...
                'ticklabels',[0.5 1 2 3 4 5 6 7 8],'TickDirection',('out'));
            title(datestr(datenum(yr,mo,da,hr,0,0)));
            xlim([120 180]); ylim([15 50]);
            hold on
            %[c,h]=contour(loni,lati,chl,log10([5 8]),'k');
            load coast
            plot(long,lat,'w');
            M1=getframe(gcf);
            writeMovie(aviobj, M1);
            pause(0.01)
             clf
        end
       
    end
    
end
end
end
close(aviobj);

% Movhw='./mov';
% mfile=fullfile(Movhw,'

