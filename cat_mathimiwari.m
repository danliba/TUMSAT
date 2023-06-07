hdir=dir('2*.mat');
chlor(801,1301,790)=NaN;

for ihw=1:1:size(hdir,1)
    
    fname=[hdir(ihw).name];
    
    load(fname);
    
    latitude(:,ihw)=lat2;
    longitude(:,ihw)=lon2;
    timechl(ihw,:)=time;
    chlor(:,:,ihw)=chl;
    
    
    
end

CHL='/Volumes/KINGSTON/himiwari data/CHL/20170701_20190831';
        mfile=fullfile(CHL);
        save(mfile,'latitude','longitude','timechl','chlor','-v7.3');