pathssh='G:\ecosystem_laboratory\KLM\SSHData';
fn1='SSH1993_2019.nc';
sshfns=fullfile(pathssh,fn1);

sshK=1.2;
range=[115 165 22 48];
L1=ncread(sshfns,'latitude');
L2=ncread(sshfns,'longitude');
T=ncread(sshfns,'time');

[loni,lati]=meshgrid(L2,L1);

maskssh=double(range(1)<=loni & loni<=range(2) &...
                range(3)<=lati & lati<=range(4));
maskssh(maskssh==0)=NaN;

[yr,mo,da,hr,mi,se]=datevec(double(T)+datenum(1950,1,1,0,0,0));

lonissh=double(loni);
latissh=double(lati);

topopath='F:\himiwari2data';
topofn='etopo.mat';
topofns=fullfile(topopath,topofn);
load(topofns);

fn2='CHL_daily.nc';
loncl=ncread(fn2,'lon');
latcl=ncread(fn2,'lat');
timecl=ncread(fn2,'time');

[yrcl,mocl,dacl,hrcl,micl,secl]=datevec(double(timecl)+datenum(1900,1,1,0,0,0));

yrst=2017;
yren=2017;
most=1;
moend=12;

disti=0:5000:6e6;
iter=0;
jj=0;

% aviobj = QTWriter('Daily_CHL1.mov','FrameRate',2);%aviobj.Quality = 100;
figure
for iy=yrst:1:yren
    
%     if iy==yrst
%         most=7;
    if iy==yren
        moend=12;
    end
    
    
    for im=most:moend
        
        for dai=1:1:31
            
        indx01=find(yr==iy&mo==im&da==dai);
        indx02=find(yrcl==iy&mocl==im&dacl==dai);
        
        daynum2=num2str(datenum(iy,im,0,0,0,0));
        daynum=datestr(datenum(iy,im,dai,0,0,0));
        
        for i=1:length(indx01)
                disp (['Proceess No.' num2str(i) ' ... '])
                
                ssh=ncread(sshfns,'adt',[1 1 indx01(i)],[Inf Inf 1],[1 1 1]);
                
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
                
                
          for icl=1:length(indx02)
              
              chl=ncread(fn2,'CHL',[1 1 indx02(icl)],[Inf Inf 1],[1 1 1]);
              
              chl=chl';
              
              jj=jj+1;
              
              
               pcolor(loncl,latcl,chl); colorbar;
                shading flat
                colormap; colorbar;
                hc=colorbar;
                caxis(log10([0.5 8]));
                colormap jet
                set(hc,'ticks',log10([0.5 1 2 3 4 5 6 7 8]),...
                  'ticklabels',[0.5 1 2 3 4 5 6 7 8],'TickDirection',('out'));
                title([daynum]);
                xlim([130 150]); ylim([30 40]);
                hold on
                plot(lonki,latki,'r','Linewidth',2);
                load coast
                plot(long,lat,'k');
                axis([130 150 30 40]);
                
                hold on
                contour(lonb,latb,topo,[-1000 1000],'k');
%                 
%                 M1=getframe(gcf);
%                 writeMovie(aviobj, M1);

%             M1=getframe(gcf);
%             writeMovie(aviobj, M1);    
             pause(0.4);
            clf
            
          end
        end
        end
    end
end
% end

% close(aviobj);

              
              
              
             
            
        
        
        
        
       
      
    