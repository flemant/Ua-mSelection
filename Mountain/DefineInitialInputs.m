

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)
%% UserVar
 UserVar.Geometry1File='GeometryData1bismeshRRm3.mat'; % The initial geometry is the 1st geometry
 UserVar.SaveFileEachRunStep=false;   % This is used in the m-file: DefineOutputs.m
 UserVar.PlotFigures=true ;           % This is used in the m-file: DefineOutputs.m


%%

CtrlVar.TimeDependentRun=true; 
CtrlVar.Experiment='Mountain';

CtrlVar.FlowApproximation='SSTREAM' ; 

CtrlVar.time=0 ;                                % start time
CtrlVar.dt=1e-3;                                   % the time step, units years.
CtrlVar.TotalNumberOfForwardRunSteps=Inf;  
CtrlVar.TotalTime=50;                           % total model-time, i.e. the total time of the simulation, units year

% automated time stepping
CtrlVar.AdaptiveTimeStepping=1 ; CtrlVar.ATSdtMax=1; 

CtrlVar.DefineOutputsDt=0.1; % model time interval between calling DefineOutputs.m


% set mininum allowed ice thickness
CtrlVar.ThickMin=1;                
CtrlVar.ResetThicknessToMinThickness=0;  
CtrlVar.ThicknessConstraints=1;  
%% Mesh domain and resolution 
CtrlVar.ReadInitialMesh=1; 
CtrlVar.ReadInitialMeshFileName='RRMeshFile.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
xd=70e3; xu=-70e3 ; yl=70e3 ; yr=-70e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
% a=60e3; % horizontal radius
% b=60e3; % vertical radius
% x0=0; % x0,y0 ellipse centre coordinates
% y0=0;
% t=linspace(-pi,pi,200);  t(end)=[];
% xe=x0+a*cos(t);
% ye=y0+b*sin(t);
% MeshBoundaryCoordinates=[1 NaN ; xe(:) ye(:)];


CtrlVar.MeshSize=4000;
%CtrlVar.MeshRefinementMethod='explicit:global';
CtrlVar.PlotMesh=1;
CtrlVar.AdaptMesh=0;
% CtrlVar.AdaptMeshAndThenStop=1; 
% CtrlVar.AdaptMeshInitial=1  ;   
% CtrlVar.AdaptMeshMaxIterations=10;
% CtrlVar.SaveAdaptMeshFileName='SRFineMeshFile.mat';
%%
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead='Mountain_Restartfile.mat';
CtrlVar.NameOfRestartFiletoWrite='Mountain_Restartfile.mat';
end
