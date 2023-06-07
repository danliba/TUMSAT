fn1='SSH1993_2019.nc';

L1=ncread(fn1,'latitude');
L2=ncread(fn1,'longitude');
T=ncread(fn1,'time');
[yr,mo,da,hr,mi,se]=datevec(double(T)+datenum(1950,1,1,0,0,0));
% aviobj = QTWriter('SSHK.mov','FrameRate',1);%aviobj.Quality = 100;


figure
for k=2017:2019
        if k==2019
            mend=1;
            
        else mend=12;
        end
    for i=1:mend
        for dai=1:1:31
        
        indx01=find(yr==k&mo==i&da==dai);
        
%         for im=1:1:mend
            daynum2=num2str(datenum(k,i,0,0,0,0));
            daynum=datestr(datenum(k,i,dai,0,0,0));
            
            % datetxt2=[daynum(8:end) daynum(3:7) daynum(1:2)];
            
            for i=1:length(indx01)
                disp (['Proceess No.' num2str(i) ' ... '])
                
                ssh=ncread(fn1,'adt',[1 1 indx01(i)],[Inf Inf 1],[1 1 1]);
                
                ssh=ssh';
%                 if i==1
%                     sshm=zeros(size(ssh));
%                 end
%                 
%                 sshm=sshm+ssh./length(indx01);
                
                pcolor(L2,L1,ssh); colorbar;
                shading flat
                title([daynum]);
                hold on
                [c,h]=contour(L2,L1,ssh,[1 1.2],'k');
                clabel(c,h)
%                 load coast
%                 plot(long,lat,'k');
%                 axis([125 150 25 40]);
%                 caxis([0.2 1.8]);
%                 
%                 x1=135;x2=140;
%                 y1=30;y2=34;
%                 x = [x1, x2, x2, x1, x1];
%                 y = [y1, y1, y2, y2, y1];
%                 p1=plot(x, y, 'b-', 'LineWidth', 3);
%                 
%                 hold on
%                 a1=135.4;a2=136.5;
%                 b1=31.3;b2=31.9;
%                 a = [a1, a2, a2, a1, a1];
%                 b = [b1, b1, b2, b2, b1];
%                 p2=plot(a, b, 'r-', 'LineWidth', 3);
%                 
%                 hold on
%                 h1=138.5;h2=142;
%                 c1=28;c2=34.2;
%                 h = [h1, h2, h2, h1, h1];
%                 c = [c1, c1, c2, c2, c1];
%                 p3=plot(h, c, 'k-', 'LineWidth', 2);
%                 legend([p1 p2 p3],{'LM spotted area','Koshu Seamount','Izu Ridge'});
%                 pause(0.005)
                pause(0.4);
            clf
                
            end
        end
            
%             pcolor(L2,L1,ssh); colorbar;
%             shading flat
%             hold on
%             [c,h]=contour(L2,L1,ssh,[1.2 1.2],'k');
%         
% %             hold on
% %             [c,h]=contour(L2,L1,ssh,[1.1 1.1],'g','Linewidth',2);
% %       
% %             hold on
% %             [c,h]=contour(L2,L1,ssh,[1 1],'w--','Linewidth',2);
% %           
% %             hold on
% %             [c,h]=contour(L2,L1,ssh,[0.9 0.9],'r-','Linewidth',2.5);
%             
%            
%             load coast
%             plot(long,lat,'k');
%             axis([125 150 25 40]);
%             caxis([0.2 1.8]);
%             title([daynum]);
%             hold on
%             
%             x1=135;x2=140;
%             y1=30;y2=34;
%             x = [x1, x2, x2, x1, x1];
%             y = [y1, y1, y2, y2, y1];
%             p1=plot(x, y, 'b-', 'LineWidth', 3);
%             
%             hold on
%             a1=135.4;a2=136.5;
%             b1=31.3;b2=31.9;
%             a = [a1, a2, a2, a1, a1];
%             b = [b1, b1, b2, b2, b1];
%             p2=plot(a, b, 'r-', 'LineWidth', 3);
%             
%             hold on
%             h1=138.5;h2=142;
%             c1=28;c2=34.2;
%             h = [h1, h2, h2, h1, h1];
%             c = [c1, c1, c2, c2, c1];
%             p3=plot(h, c, 'k--', 'LineWidth', 2);
%             legend([p1 p2 p3],{'LM spotted area','Koshu Seamount','Izu Ridge'});
%             
% %             M1=getframe(gcf);
%             writeMovie(aviobj, M1);
            
%         end
%         NLMsshp='./NLMssh';
%         mfile=fullfile(NLMsshp,[daynum,'SSH monthly average']);
%         save(mfile,'L2','L1','sshm');
        % saveas(datetext,(gcf,['fig2/1994_','.fig']))
        
    end
end

% close(aviobj);
