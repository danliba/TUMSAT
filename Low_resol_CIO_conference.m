path0='F:\Modelo_sal_temp';
fn='May_data_CIO_conference.nc';
fn1='Climatology1993_2019.mat';
fns=fullfile(path0,fn);

load(fn1);

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

t=datetime(yr,mo,da,hr,0,0);
w=week(t);

% sst=mean(double(ncread(fn,'thetao')),2);
% sst=permute(sst,[4 1 3 2]); 
% 
% sstb=sst(w,:,1);

most=1;
moen=5;

weekst=1;
weeknd=20;

iter=0;
figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

% for im=most:1:moen
%     
for iw=weekst:1:weeknd
%     disp([num2str(im) '--' num2str(iw)])
    disp(num2str(iw))
    indx0=find(w==iw);
    
    iter=iter+1;
    numrec=length(indx0);
    
    for irec=1:1:numrec
        disp (['Proceess No.' num2str(irec) ' ... '])
      
         sst=mean(double(ncread(fn,'thetao',[1 1 1 indx0(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1])),2);
            sst=permute(sst,[3 1 2]);
            
            if irec==1
                
                sst2=zeros(size(sst));
            end
            
            SST=sst;
            sst2=sst2+SST./length(indx0);
    end
    
                
        pcolor(loni,-depi,sst2);
        hold on
        [c,h]=contour(loni,-depi,sst2,[10:2:30],'k:');
        clabel(c,h);
        colorbar; caxis([10 30]);
        shading flat
        cmocean('balance');
        title(['SST anom ' num2str(iw)]);
        c=colorbar;
        c.Label.String='Temperature (ºC)';
        ylabel('Depth');
        set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
        
        pause(0.1)
        clf
end

% end
