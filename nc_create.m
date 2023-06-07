%% converting Matfile to Nc

clear all

load('20170701_20190831.mat');

% chlor_a= chlor;
% Dimensions: 801*1301*790;

% Resolution: longitude=0.01;
%             latitude=0.01;



ncout=netcdf.create('Himawari.nc','CLOBBER');

% define dimensions e.g. 120 for xi, and 64 for zc, and time for unlimited record dimension

dimX=netcdf.defDim(ncout,'xi',1301);
dimY=netcdf.defDim(ncout,'yi',801);
dimT=netcdf.defDim(ncout,'time',netcdf.getConstant('NC_UNLIMITED'));

% define variables using dimensions you defined

varid10=netcdf.defVar(ncout,'longitude','double',[dimX]);
varid11=netcdf.defVar(ncout,'latitude','double',[dimY]);
varid13=netcdf.defVar(ncout,'timechl','double',[dimT]);
varid10=netcdf.defVar(ncout,'chlor_a','double',[dimX dimY dimT]);

% end the define mode
                netcdf.endDef(ncout);
% close the file
                netcdf.close(ncout);


%ncwrite
loni=longitude(1:1301);
lati=latitude(1:801);
time=timechl(1:790);

ncwrite('Himawari.nc','longitude',loni);
ncwrite('Himawari.nc','latitude',lati);
ncwrite('Himawari.nc','timechl',time);

for timei=1:1:790
    
     Y=size(chlor(:,:,timei));
     ncwrite('Himawari.nc','chlor_a',Y,[1 1 timei]);
     
end



% ncwrite('Himawari.nc','longitude',[1 1],[1301 1],[1 1]);
% lon=ncread('Himawari.nc','longitude')
% display(lon)
% ncwrite('Himawari.nc','latitude',[1 1],[Inf Inf],[1 1]);
% ncwrite('Himawari.nc','timechl',[1 1 1],[Inf Inf Inf],[1 1 1]);
% ncwrite('Himawari.nc','chlor_a',[1 1 1],[Inf Inf Inf],[1 1 1]);


