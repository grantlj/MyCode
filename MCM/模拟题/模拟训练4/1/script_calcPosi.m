clear
clc
%------------����first�ɻ�----------
%����first�ɻ�����Ϣ
firstPlane=[6650,1430,13901;7335,1430,13723;8020,1430,13568;8705,1430,13426;10075,1430,13196;6650,2230,14023;7335,2230,13842;8020,2230,13681;8705,2230,13541;10075,2230,13306;6650,3030,14177;7335,3030,13993;8020,3030,13830;8705,3030,13686;10075,3030,13445;6650,3830,14364;7335,3830,14176;8020,3830,14008;8705,3830,13860;10075,3830,13610;6650,4630,14582;7335,4630,14388;8020,4630,14215;8705,4630,14062;10075,4630,13802;6650,5430,14829;7335,5430,14629;8020,5430,14450;8705,5430,14291;10075,5430,14019;];
firstPlanePosition=[];
%�����������״���Ϣ

for i=1:(size(firstPlane,1)-2)
    disp(i);
    for j=(i+1):(size(firstPlane,1)-1)
        for k=(j+1):size(firstPlane,1)
            firstPlanePosition=[ firstPlanePosition; fun_calcPosi([ firstPlane(i,:),firstPlane(j,:),firstPlane(k,:) ]) ];
        end
    end
end

%ɾ���������Ч�����ݣ��õ����ս��
isRightData=~(isnan(firstPlanePosition)|(abs(firstPlanePosition)==inf));
firstPlanePosition=firstPlanePosition(isRightData);
firstPlanePosition=reshape(firstPlanePosition,length(firstPlanePosition)/3,3);

%------------����second�ɻ�----------
%����second�ɻ�����Ϣ
secondPlane=[4650,1710,48385;5150,1710,47495;5650,1710,46605;6150,1710,45712;6650,1710,44817;7150,1710,43917;4650,2135,48428;5150,2135,47538;5650,2135,46647;6150,2135,45754;6650,2135,44859;4650,2560,48469;5150,2560,47579;5650,2560,46689;6150,2560,45796;6650,2560,44901;7150,2560,44001;4650,2985,48510;5150,2985,47620;5650,2985,46730;6150,2985,45837;6650,2985,44938;4650,3410,48551;5650,3410,46770;6150,3410,45878;6650,3410,44979;7150,3410,44084;4650,3835,48591;5150,3835,47701;5650,3835,46811;6150,3835,45919;6650,3835,45024;];
secondPlane=secondPlane./1000;
secondPlanePosition=[];
%�����������״���Ϣ

for i=1:(size(secondPlane,1)-2)
    disp(i);
    for j=(i+1):(size(secondPlane,1)-1)
        for k=(j+1):size(secondPlane,1)
            secondPlanePosition=[ secondPlanePosition; fun_calcPosi([ secondPlane(i,:),secondPlane(j,:),secondPlane(k,:) ]) ];
        end
    end
end

%ɾ���������Ч�����ݣ��õ����ս��
isRightData=~(isnan(secondPlanePosition)|(abs(secondPlanePosition)==inf));
secondPlanePosition=secondPlanePosition(isRightData);
secondPlanePosition=reshape(secondPlanePosition,length(secondPlanePosition)/3,3);

%------------����third�ɻ�----------
%����third�ɻ�����Ϣ
thirdPlane=[7335,1370,107160;8705,1370,106150;7335,2170,106450;8705,2170,105440;7335,2970,105730;8705,2970,104720;7335,3770,105000;8705,3770,103990;7335,4570,104250;8705,4570,103240;7335,5370,103480;8705,5370,102480;];
thirdPlanePosition=[];
%�����������״���Ϣ

for i=1:(size(thirdPlane,1)-2)
    disp(i);
    for j=(i+1):(size(thirdPlane,1)-1)
        for k=(j+1):size(thirdPlane,1)
            thirdPlanePosition=[ thirdPlanePosition; fun_calcPosi([ thirdPlane(i,:),thirdPlane(j,:),thirdPlane(k,:) ]) ];
        end
    end
end

%ɾ���������Ч�����ݣ��õ����ս��
isRightData=~(isnan(thirdPlanePosition)|(abs(thirdPlanePosition)==inf));
thirdPlanePosition=thirdPlanePosition(isRightData);
thirdPlanePosition=reshape(thirdPlanePosition,length(thirdPlanePosition)/3,3);

%----------�������
clear i j k isRightData firstPlane secondPlane thirdPlane;


