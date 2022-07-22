%% Save data
clear
load("MyData_Geom2AmeshRRm3.mat","CtrlVar","time","F","length","hmax")
FB = F.B;
Fb = F.b;
Frho = F.rho;
Fs =F.s;
FS=F.S;
save('GeometryData2AmeshRRm3.mat','FB','Fb','Frho','Fs','FS')
%%
FerrMeas = F.ub*0+1; % random error added to the mesurements
FuMeas = F.ub;
FvMeas = F.vb;

save('SurfaceVelocityData2AmeshRRm3.mat','FuMeas','FvMeas','FerrMeas')
%% White noise
clear
load("MyData_Geom1meshRRm3.mat","CtrlVar","time","F","length","hmax")
sigma=5;
err = sigma*randn(size(F.ub)); % random error added to the measurements
FerrMeas = F.ub*0+sigma; %always 1 because I know the error
FuMeas = F.ub+err;
FvMeas = F.vb+err;
save('SurfaceVelocityData1AmeshRRm3GN1.mat','FuMeas','FvMeas','FerrMeas')

load("MyData_Geom2AmeshRRm3.mat","CtrlVar","time","F","length","hmax")
FuMeas = F.ub+err;
FvMeas = F.vb+err;
save('SurfaceVelocityData2AmeshRRm3GN1.mat','FuMeas','FvMeas','FerrMeas')
%%
dhdtMeas=F.dhdt;
dhdtErrMeas=0*F.dhdt+1;
save('dhdtData1a05_l020.mat','dhdtMeas','dhdtErrMeas')
%%
%Boundary=[MUA.Boundary.x MUA.Boundary.y]
%save('Boundary.mat','Boundary')
%% Save interpolants
% clear
% load("MyData_Geom2_a010_l010_y4.mat","CtrlVar","time","F","length","hmax")

% BedMachineToUaGriddedInterpolants("MyData_Geom2_a010_l010_y4.mat",1,false,2*1*500,false)
%%
clear
load("MyData_Geom1_a010_l020.mat","CtrlVar","time","F","length","hmax")
%%
%[X,Y]=ndgrid(F.x,F.y);
FB = scatteredInterpolant(F.x,F.y,F.B,'linear','linear');
Fb = scatteredInterpolant(F.x,F.y,F.b,'linear','linear');
Frho = scatteredInterpolant(F.x,F.y,F.rho,'linear','linear');
Fs = scatteredInterpolant(F.x,F.y,F.s,'linear','linear');
%save('GeometryInterpolants1.mat','FB','Fb','Frho','Fs')
%%
FerrMeas = scatteredInterpolant(F.x,F.y,F.ub*0+1,'linear','linear');
FuMeas = scatteredInterpolant(F.x,F.y,F.ub,'linear','linear');
FvMeas = scatteredInterpolant(F.x,F.y,F.vb,'linear','linear');

%save('SurfaceVelocityInterpolants1.mat','FerrMeas','FuMeas','FvMeas')
