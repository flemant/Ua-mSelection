
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

% % B         is bedrock
% % s and b   are upper and lower ice surfaces
% % S         is ocean surface
% % alpha     is the tilt of the z axis of the coordinate system with respect to vertical


% x=MUA.coordinates(:,1); % these are the x coordinates of the nodes
% y=MUA.coordinates(:,2); % these are the y coordinates of the nodes
% 
% alpha=0.0; %  tilt of the coordinate system, do not change.
% 
% % Define the geometry of the bedrock : a gaussian mountain
% zmax=4000; 
% ampl_b=zmax; sigma_bx=20000 ; sigma_by=20000;
% Deltab=ampl_b*exp(-((x/sigma_bx).^2+(y/sigma_by).^2));
% 
% B=zeros(MUA.Nnodes,1) + Deltab ;
% b=B;         % lower ice surface (glacier sole) set equal to bedrock
% h=x*0+2;     % initial thickness set to 2 meters
% s=b+h;       % upper surface
% S=x*0-1e10;  % Just make sure the ocean surface is so low that all ice is grounded at all times

%figure; Plot_sbB(CtrlVar,MUA,s,b,B);

%% Geometry 2: initial geometry is geometry 1
persistent FB Fs Fb FS Frho

alpha=0;

fprintf('DefineGeometry %s \n',FieldsToBeDefined)

if isempty(FB)
    
    fprintf('DefineGeometry: loading file: %-s ',UserVar.Geometry1File)
    load(UserVar.Geometry1File,'FB','Fb','Fs','FS','Frho')
    fprintf(' done \n')
    
end

if contains(FieldsToBeDefined,'S')
    S=FS;
else
    S=NaN;
end

if contains(FieldsToBeDefined,'s')
    s=Fs;
else
    s=NaN;
end

b=NaN; B=NaN;

if contains(FieldsToBeDefined,'b')  || contains(FieldsToBeDefined,'B')
    
    B=FB;
    b=Fb;

end
end
