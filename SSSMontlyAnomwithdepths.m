filename='datanorthpacificdepth.nc';

lonu=ncread(filename,'longitude');
latu=ncread(filename,'latitude');
depthu=ncread(filename,'depth');
time=ncread(filename,'time')./24;

lonu=double(lonu);
latu=double(latu);
depthu=double(depthu);
time=double(time);

[lonx,latx,depthx]=meshgrid(lonu,latu,depthu);

time=time+datenum(1950,1,1,0,0,0);

[yr,mo,da,hr,mi,se]=datevec(time);

yrst=1995;

yren=2017;

most=1;

moen=12;

load('SSS1993_201811MontlyClim12label12.mat');

iter=0;



figure

for iy=yrst:1:yren
    % if iy is greater than yrst, then let most is 1
    if iy>yrst
        most=1;
    end
 
    % start the loop for month
    for im=most:1:moen
        % display the month under processing
        disp(datestr(datenum(iy,im,30,0,0,0)));
        % find the index of CHL data at iy=yr and im=mo
        indx=find(yr==iy & mo==im);
        % check whether index is unique and found
        if length(indx)>1
            disp('index has more than two entries')
            datestr(time(indx))
        elseif isempty(indx)==1
            error('there is no sal data')
        end
        
                % update the iter by adding 1
        iter=iter+1;
        % get sal monthly data
        Sali=ncread(filename,'so',[1 1 1 indx(1)],...
            [size(lonu,1) size(latu,1) size(depthu,1) 1],[1 1 1 1]);
        % transpose the data
        Sali=permute(Sali,[2 1 3 4]);
        % compute anomaly
        Salianom=Sali-ssss(:,:,:,im);
        
    Salidata= squeeze(Sali(:,70,:));
    latiplot = squeeze(latx(:,70,:));
    depthplot = squeeze(depthx(:,70,:));
    
        
    salianomplot11=squeeze(Salianom(:,70,11));
    salianomplot12=squeeze(Salianom(:,70,12));
    Salimean1112=(salianomplot11+salianomplot12)/2;
% %     
    Salimean1112s(:,iter)=Salimean1112; 
    timeis(:,iter)=repmat(datenum(iy,im,15,0,0,0),[size(Salimean1112) 1]); 
    latus(:,iter)=latu;
% %     
    saliplot11= squeeze(Sali(:,70,11));
    saliplot12= squeeze(Sali(:,70,12));
    Saliplot1112=(saliplot11+saliplot12)/2;
    
    Saliplot1112s(:,iter)=Saliplot1112; 

    timeisplot(:,iter)=repmat(datenum(iy,im,15,0,0,0),[size(Saliplot1112) 1]);
        
    
        pcolor(latiplot,-depthplot,Salidata);

        shading interp

        colorbar; caxis([34 35.5]);
%         
%         mymap = [0 0 1
%     0.125 0.125 1
%     0.25 0.25 1
%     0.375 0.375 1
%     0.5 0.5 1
%     0.621 0.621 1
%     0.746 0.746 1
%     0.871 0.871 1
%     1 1 1
%     1 1 1
%     1 0.871 0.871
%     1 0.746 0.746
%     1 0.621 0.621
%     1 0.5 0.5
%     1 0.375 0.375
%     1 0.25 0.25
%     1 0.125 0.125
%     1 0 0];
% 
%       colormap(mymap)
 
      hold on
      [c,h]=contour(latiplot,-depthplot,Salidata,[34:0.2:35.5],'k');
      clabel(c,h);
        
      hold on 

      set(gca,'xtick',[6:3:35],'xticklabel',[6:3:35],'xlim',[6 35]);
      xlabel('Latitude'); ylabel('depth'); 
       
      title(datestr(datenum(iy,im,28,0,0,0)));
      
      pause(0.1)
      clf
  
  

    end
end

figure
pcolor(timeis',latus',Salimean1112s');

       
         mymap = [0 0 1
    0.15 0.15 1
    0.30 0.30 1
    0.45 0.45 1
    0.60 0.60 1
    0.75 0.75 1
    0.9 0.9 1
    1 1 1
    1 1 1
    1 0.9 0.9
    1 0.75 0.75
    1 0.6 0.6
    1 0.45 0.45
    1 0.30 0.30
    1 0.15 0.15
    1 0 0];

      colormap(mymap)
%  
%       hold on
%       [c,h]=contour(timeis',latus',Salimean1112s',[-0.4:0.05:0.4],'k');
%       clabel(c,h);
      
      shading interp
       
      colorbar; caxis([-0.4 0.4]);
      
        
      hold on 

      set(gca,'ytick',[6:3:20],'yticklabel',[6:3:20],'ylim',[6 20]);
      datetick('x','YY/mm');
      xlabel('time'); ylabel('latitude'); 

date=[1997 04 01; 1998 05 01; 2002 08 01; 2003 03 01; 2004 08 01; 2005 03 01; 2006 08 01; 2007 01 01; 2009 07 01; 2010 04 01; 2015 05 01; 2016 05 01];
years=date(:,1);
months=date(:,2);
day=date(:,3);
timec=datenum(years,months,day);
xa=[timec(1) timec(1) timec(2) timec(2) timec(1)];
xb=[timec(3) timec(3) timec(4) timec(4) timec(3)];
xc=[timec(5) timec(5) timec(6) timec(6) timec(5)];
xd=[timec(7) timec(7) timec(8) timec(8) timec(7)];
xe=[timec(9) timec(9) timec(10) timec(10) timec(9)];
xf=[timec(11) timec(11) timec(12) timec(12) timec(11)];
ya=[6 20 20 6 6]

hold on
plot(xa,ya,'r--','linewidth',1.5)
hold on
plot(xb,ya,'r--','linewidth',1.5)
hold on
plot(xc,ya,'r--','linewidth',1.5)
hold on
plot(xd,ya,'r--','linewidth',1.5)
hold on
plot(xe,ya,'r--','linewidth',1.5)
hold on
plot(xf,ya,'r--','linewidth',1.5)
      
 figure
 
 pcolor(timeisplot',latus',Saliplot1112s');
 
%           mymap = [0 0 1
%     0.15 0.15 1
%     0.30 0.30 1
%     0.45 0.45 1
%     0.60 0.60 1
%     0.75 0.75 1
%     0.9 0.9 1
%     1 1 1
%     1 1 1
%     1 0.9 0.9
%     1 0.75 0.75
%     1 0.6 0.6
%     1 0.45 0.45
%     1 0.30 0.30
%     1 0.15 0.15
%     1 0 0];

  cmocean('haline')
%  
      hold on
      [c,h]=contour(timeisplot',latus',Saliplot1112s',[34:0.1:35],'k');
      clabel(c,h);
      
      shading interp
       
      colorbar; caxis([34 35]);
      
        
      hold on 

      set(gca,'ytick',[6:3:20],'yticklabel',[6:3:20],'ylim',[6 20]);
      datetick('x','YY/mm');
      xlabel('time'); ylabel('latitude');
      

date=[1997 04 01; 1998 05 01; 2002 08 01; 2003 03 01; 2004 08 01; 2005 03 01; 2006 08 01; 2007 01 01; 2009 07 01; 2010 04 01; 2015 05 01; 2016 05 01];
years=date(:,1);
months=date(:,2);
day=date(:,3);
timec=datenum(years,months,day);
xa=[timec(1) timec(1) timec(2) timec(2) timec(1)];
xb=[timec(3) timec(3) timec(4) timec(4) timec(3)];
xc=[timec(5) timec(5) timec(6) timec(6) timec(5)];
xd=[timec(7) timec(7) timec(8) timec(8) timec(7)];
xe=[timec(9) timec(9) timec(10) timec(10) timec(9)];
xf=[timec(11) timec(11) timec(12) timec(12) timec(11)];
ya=[6 20 20 6 6]

hold on
plot(xa,ya,'r--','linewidth',1.5)
hold on
plot(xb,ya,'r--','linewidth',1.5)
hold on
plot(xc,ya,'r--','linewidth',1.5)
hold on
plot(xd,ya,'r--','linewidth',1.5)
hold on
plot(xe,ya,'r--','linewidth',1.5)
hold on
plot(xf,ya,'r--','linewidth',1.5)

 

