hdir=dir('2*.mat');
hdir(2) = [];
%load('etopo.mat')

% aviobj = QTWriter('Himiwari_daily2.mov','FrameRate',3);
figure
for ihw=1:1:size(hdir,1)
    
    fname=[hdir(ihw).name];
    
    load(fname);
    
   
    % get time vector with year, month, date, hour, minite, second
     [yr,mo,da,hr,mi,se]=datevec(time);
            
            
            pcolor(lon2,lat2,chl);
            shading flat
            colormap; colorbar;
            hc=colorbar;
            caxis(log10([0.5 8]));
            colormap jet
            set(hc,'ticks',log10([0.5 1 2 3 4 5 6 7 8]),...
                  'ticklabels',[0.5 1 2 3 4 5 6 7 8],'TickDirection',('out'));
            title(datestr(datenum(yr,mo,da,hr,0,0)));
            hold on
            %[c,h]=contour(loni,lati,chl,log10([5 8]),'k');
            load coast
            plot(long,lat,'w');
%             hold on
%             contour(lonb,latb,topo,[-1000 1000],'k');
            %contour(lonb,latb,topo,[-1000 1000],'LineWidth', 2, 'Color', [0.75 0.75 0.75])
            axis([126 142 26 37]);
         
           
%    M1=getframe(gcf);
%    writeMovie(aviobj, M1);
    pause(0.01)
   clf
end
% close(aviobj);
