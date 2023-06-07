% define the range of the SSH data for determination of the Kuroshio axis
range=[115 165 22 48];
% define the SSH value to extract the Kuroshio axis
sshK=1.2;

% define the starting year, month, and the last year and month for the
% processing
yrst=2004;
most=9;
yren=2019;
moen=1;

% define path for the SSH monthly mean file and its name
sshpath='./SSHData';
sshfn='SSH1993_2019MonthlyMean.mat';
% generate a complete file name with the absolute path
sshfns=fullfile(sshpath,sshfn);
% load the SSH monthly mean data
load(sshfns)
% make the variables loni lati times to be double and remame them
lonissh=double(loni);
latissh=double(lati);
timessh=double(times);

% compute mask for the SSH data within the "range".
maskssh=double(range(1)<=loni & loni<=range(2) &...
    range(3)<=lati & lati<=range(4));
maskssh(maskssh==0)=NaN;

% compute time vector for the SSH data 
[yrssh,mossh,dassh,hrssh,missh,sessh]=datevec(timessh);

% define path for the CHL monthly climatology and mean file, and their
% names
chlpath='./ChlData';
% climatology
chlclmfn='CHL1997_2019MonthlyClim.mat';
% monthly mean netcdf file
chlfn='CHLA1997_2019.nc';
% generate complete file names with the absolute paths
chlclmfns=fullfile(chlpath,chlclmfn);
chlfns=fullfile(chlpath,chlfn);
% load CHL climatology file
load(chlclmfns)
% make the variables loni lati times to be double and remame them
lonichl=double(loni);
latichl=double(lati);
timechl=double(ncread(chlfns,'time'));
% compute matlab julian date for CHL monthly netcdf file
timechl=timechl+datenum(1900,1,1,0,0,0);
% get time vector with year, month, date, hour, minite, second
[yr,mo,da,hr,mi,se]=datevec(timechl);

% keep the months as different names
most0=most;
moen0=moen;

% generate a distance vector for the interpolation of chl anomaly along the
% Kuroshio axis
disti=0:5000:6e6;
% initialize iter to count the continueous number
iter=0;
% aviobj = QTWriter('SSHKallpath1.1.mov','FrameRate',2);
% start the loop for year
for iy=yrst:1:yren
    % if iy is greater than yrst, then let most is 1
    if iy>yrst
        most=1;
    end
    % if iy is equal to yren, then let most is moen0,
    if iy==yren
        moen=moen0;
    % otherwise 12
    else
        moen=12;        
    end
    % start the loop for month
    for im=most:1:moen
        % display the month under processing
        disp(datestr(datenum(iy,im,15,0,0,0)));
        % find the index of CHL data at iy=yr and im=mo
        indx=find(yr==iy & mo==im);
        % check whether index is unique and found
        if length(indx)>1
            disp('index has more than two entries')
            datestr(timechl(indx))
        elseif isempty(indx)==1
            error('there is no chla data')
        end
        % find the index of SSH data at iy=yr and im=mo
        indx2=find(yrssh==iy & mossh==im);
        % check whether index is unique and found
        if length(indx2)>1
            disp('index2 has more than two entries')
        elseif isempty(indx2)==1
            error('there is no ssh data')
        end
        
        % update the iter by adding 1
        iter=iter+1;
        % get CHL monthly data
        CHLi=ncread(chlfns,'CHL',[1 1 indx(1)],...
            [size(lonichl,2) size(lonichl,1) 1],[1 1 1]);
        % transpose the data
        CHLi=CHLi';
        % compute anomaly
        CHLanom=CHLi-CHLs(:,:,im);
        % get SSH monthly data
        SSHi=SSHs(:,:,indx2);

        % compute the Kuroshio axis by contour command
        [lonk, latk]=Extract_KuroshioAxis(SSHi.*maskssh, lonissh, latissh,sshK);
        % find the indice of the Kuroshio path where latitude is greater
        % than 24 degree north of Taiwan
        indxpath=find(latk>24);
        % extract the lon and lat of the Kuroshio axis where latitude is greater
        % than 24 degree north of Taiwan
        latk=latk(indxpath);
        lonk=lonk(indxpath);
        % compute the distance between neighboring two points along the
        % Kuroshio Axis
        dx=distance(latk(2:end),lonk(2:end),latk(1:end-1),lonk(1:end-1)).*60.*1852;
        % compute the distance from the north of Taiwan by cumulative sum
        distx=cat(2,0,cumsum(dx));
        
        % Because defined Kuroshio axis by Extract_KuroshioAxis.m is
        % irregular in its distance, now the lon and lat along the axis is
        % interpolated with respect to the distance, with the uniform
        % distance resolution
        lonki=interp1(distx,lonk,disti);
        latki=interp1(distx,latk,disti);
        
        % then interpolate chl anomaly along the Kuroshio axis
        chlai=interp2(lonichl,latichl,CHLanom,lonki,latki);
        
        % lets store the data along the Kuroshio axis
        chlais(:,iter)=chlai';
        lonkis(:,iter)=lonki';
        latkis(:,iter)=latki';
        distis(:,iter)=disti';
        timeis(:,iter)=repmat(datenum(iy,im,15,0,0,0),[length(chlai) 1]);
        
%         just for polts for checking
        pcolor(lonichl,latichl,CHLanom);shading flat;colorbar
        caxis([-.1 .1])
        colormap jet
        
        hold on
        [c,h]=contour(lonissh,latissh,SSHi,[sshK sshK],'k');
        plot(lonki,latki,'r','linewidth',3)
        title(datestr(datenum(iy,im,15,0,0,0)))
        pause(0.05)
%          M1=getframe(gcf);
%             writeMovie(aviobj, M1);
%             clf
%         
    end
end
% close(aviobj);
% saving the data with the file neme: ChlAlongKuroshio.mat
%save('DSTR_ChlAlongKuroshio','chlais','lonkis','latkis','distis','timeis')

% make a few plots
% for chl anomaly along the Kuroshio Axis

saveas(gcf,'example_KPLM.jpg','jpg')
figure
pcolor(timeis,distis,chlais); title('Chlorophyll anomaly');
shading flat
caxis([-.1 .1])
colorbar
colormap jet
datetick('x','YY/mm')


% for latitude along the Kuroshio Axis
figure
pcolor(timeis,distis,latkis); title('Latitude');
shading flat
%         caxis([-.1 .1])
colorbar
colormap jet
datetick('x','YY/mm')

% for longitude along the Kuroshio Axis
figure
pcolor(timeis,distis,lonkis);title('Longitude');
shading flat
%         caxis([-.1 .1])
colorbar
colormap jet
datetick('x','YY/mm')



