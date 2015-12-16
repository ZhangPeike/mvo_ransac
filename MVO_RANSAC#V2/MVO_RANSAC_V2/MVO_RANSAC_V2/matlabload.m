  clc;clear all;close all;
data=load('pose.txt');%��������poseֵ
dt=load('00.txt');%������ֵ
n=size(data,1)
translationError=[];
rotationError=[];
 temp=[0,0,0,1];
dist=0;
p0=eye(4);
length=[];
for i=1:n

    d1=reshape(data(i,:),4,3);
    d1=d1';
    d=[d1;temp];%����Ľ��
%     p0=p0*inv(d);
%        t1(i,:)=[p0(1,4),p0(3,4)];
  t1(i,:)=[d(1,4),d(3,4)];    
 
    dt0=reshape(dt(i+1,:),4,3);
    dt0=dt0';
    dt_=[dt0;temp];%gt
    t(i,:)=[dt_(1,4),dt_(3,4)];
   if i>=2
    dt1=reshape(dt(i-1,:),4,3);
    dt1=dt1';
    dt_1=[dt1;temp];%������ʵֵ
      dist_temp=dt0(:,4)-dt1(:,4);%��֡���ƽ��
    dist=sqrt(dist_temp'*dist_temp)+dist;%���˶�·��
   else
        dt1=reshape(dt(1,:),4,3);
    dt1=dt1';
    dt_1=[dt1;temp];%������ʵֵ
      dist_temp=dt0(:,4)-dt1(:,4);%��֡���ƽ��
    dist=sqrt(dist_temp'*dist_temp)+dist;%���˶�·��
   end

%%error test
    %distance
  
    
    length(i)=dist;
     pose_error=inv(d)*(dt_);
      %translationError
      dx=pose_error(1,4);
      dy=pose_error(2,4);
      dz=pose_error(3,4);
      translationError(i)=(sqrt(dx*dx+dy*dy+dz*dz)/dist)*100;
      %rotationError
      a = pose_error(1,1);
      b = pose_error(2,2);
      c = pose_error(3,3);
      d = 0.5*(a+b+c-1.0);
      rotationError(i)=acos(max(min(d,1.0),-1.0))/dist;
      
end

save 00data rotationError translationError t1 t length;%��������
figure
   plot(t1(:,1),t1(:,2),t(:,1),t(:,2), 'LineWidth',2);
       title('ʵ����Խ��');
       ylabel('Z(m)');xlabel('X(m)');
      legend('ʵ�����켣','��ʵ�켣');
      
  figure
  subplot(2,1,1);
     plot(length,translationError);
       title('ƽ�����'); legend('ʵ�����ƽ��������');
       ylabel('���ƽ�����(%)');xlabel('�˶����(m)');
    
    subplot(2,1,2);

     plot(length,rotationError);
       title('��ת���');legend('ʵ�������ת������');
       ylabel('�����ת��rad/m��');xlabel('�˶����(m)');


      
      