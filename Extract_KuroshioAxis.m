function [lonk, latk]=Extract_KuroshioAxis(ssh, lon, lat,sshK)
% ���
%    sshfname: �C�ʍ��x�f�[�^���i�[���Ă���Matlab file��
% 


% �ǂݍ��񂾊C�ʍ��x��p���āA�����̓��l����v�Z����
c=contourc(lon(1,:),lat(:,1),ssh,[sshK sshK]);

% �v�Z�����ł��������l��ɉ������ܓx�o�x�𒊏o����
[m,n]=size(c);
flag=1;
endnum=0;
numdatap=0;
while flag==1
    numdata=c(2,endnum+1);
    if numdata > numdatap;
        lonk=c(1, endnum+2: endnum+1+numdata);
        latk=c(2, endnum+2: endnum+1+numdata);
        numdatap=numdata;
    end
    endnum=endnum+1+numdata;
    if endnum+1>n
        flag=-1;
     end
end
