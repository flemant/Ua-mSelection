
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%CHANGE INPUTFORINVERSERUN IF THESE ARE REAL MEASUREMENTS: INTERPOLANTS
%% DO NOT CHANGE THIS SECTION; IT IS USED TO GET DataFile AND UserFile 
cd ..\
home=pwd;
UserVar.DataFileName=home+"\DataFile.mat";
UserVar.UserFileName=home+"\UserFile.mat";
cd MountainCalculation\

load(UserVar.DataFileName);
load(UserVar.UserFileName);

%% Select the type of run 
if isempty(UserVar) || ~isfield(UserVar,'RunType')
    UserVar.RunType=RunType;
end

%% UserVar
if isempty(UserVar) || ~isfield(UserVar,'m')
    UserVar.m=m; % Define m
end

CtrlVar.FlowApproximation="SSTREAM" ;
%%
UserVar.GeometryInterpolant=GeometryDataFile; % my geometry file              
UserVar.SurfaceVelocityInterpolant=SurfaceVelocityDataFile;
UserVar.MeshBoundaryCoordinatesFile=BoundaryFile;

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"

UserVar.CFile='FC-Weertman.mat'; UserVar.AFile='FA-Weertman.mat';


%%

CtrlVar.Experiment=UserVar.RunType;

switch UserVar.RunType
    
    case {'Inverse-MatOpt','Inverse-ConjGrad','Inverse-MatOpt-FixPoint','Inverse-ConjGrad-FixPoint','Inverse-SteepestDesent'}
        
        CtrlVar.InverseRun=1;
        CtrlVar.Restart=0; % switch to 1 if want a restart run
        
        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevel=0;
        
        UserVar.Slipperiness.ReadFromFile=0; % read from the DefineSlipperyDistribution
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
        CtrlVar.Inverse.Iterations=50; % set to 100 to begin with, PlotInversion to see if the approximation is good
        CtrlVar.Inverse.InvertFor='logA-logC' ; % '-logAGlen-logC-' ; % {'logA-logC','-C-','-logC-','-AGlen-','-logAGlen-'}
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
        
        CtrlVar.Inverse.Measurements='-uv-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
        
        
        
        if contains(UserVar.RunType,'FixPoint')
            
            % FixPoint inversion is an ad-hoc method of estimating the gradient of the cost function with respect to C.
            % It can produce quite good estimates for C using just one or two inversion iterations, but then typically stagnates.
            % The FixPoint method can often be used right at the start of an inversion to get a reasonably good C estimate,
            % after which in a restart step one can switch to gradient calculation using the adjoint method 
            CtrlVar.Inverse.DataMisfit.GradientCalculation='FixPoint' ;
            CtrlVar.Inverse.InvertFor='logC' ;
            CtrlVar.Inverse.Iterations=1;
            CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
          
        end
        
   
    case 'Forward-Diagnostic'
               
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1; % Reads the file created by the inverse run
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
end


CtrlVar.dt=1e-5; 
CtrlVar.time=0;
CtrlVar.TotalNumberOfForwardRunSteps=1; 
CtrlVar.TotalTime=1;

% time interval between calls to DefineOutputs.m
CtrlVar.DefineOutputsDt=1; 
% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=1;  
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5; 

%% Meshing 

CtrlVar.ReadInitialMesh=1; 
CtrlVar.ReadInitialMeshFileName=MeshFile;
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
xd=70e3; xu=-70e3 ; yl=70e3 ; yr=-70e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
                                                        
%%  Bounds on C and AGlen
%CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;

CtrlVar.Cmin=1e-20;  CtrlVar.Cmax=1e20;        


%% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation 
                                      % of the directional derivative of the objective function.  
CtrlVar.Inverse.TestAdjointFiniteDifferenceType='second-order' ; % {'central','forward'}
CtrlVar.Inverse.TestAdjointFiniteDifferenceStepSize=1e-8 ;
CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
                                         % if left empty, values are calulated for every node/element within the mesh. 
                                         % If set to for example [1,10,45] values are calculated for these three
                                         % nodes/elements.
% end, testing adjoint parameters. 


if contains(UserVar.RunType,'MatOpt')
    CtrlVar.Inverse.MinimisationMethod='UaOptimization-Hessian';
else
    CtrlVar.Inverse.MinimisationMethod='UaOptimization';
    if contains(UserVar.RunType,'ConjGrad')
        CtrlVar.Inverse.GradientUpgradeMethod='ConjGrad' ; %{'SteepestDecent','ConjGrad'}
    else
        CtrlVar.Inverse.GradientUpgradeMethod='SteepestDecent' ; %{'SteepestDecent','ConjGrad'}
    end
    
end

                                                    

CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1e3 ; % 1000 to 25000

CtrlVar.Inverse.Regularize.logC.ga=0;  % testing for Budd
CtrlVar.Inverse.Regularize.logC.gs=1e3 ; % testing for Budd

CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1e3 ;


%%
CtrlVar.ThicknessConstraints=1;
CtrlVar.ResetThicknessToMinThickness=0;  % change this later on
CtrlVar.ThickMin=1;

%% Filenames

CtrlVar.NameOfFileForSavingSlipperinessEstimate="C-Estimate"+CtrlVar.SlidingLaw+".mat";
CtrlVar.NameOfFileForSavingAGlenEstimate=   "AGlen-Estimate"+CtrlVar.SlidingLaw+".mat";

if CtrlVar.InverseRun
    CtrlVar.Experiment="Mountain-Inverse-"...
        +CtrlVar.ReadInitialMeshFileName...
        +CtrlVar.Inverse.InvertFor...
        +CtrlVar.Inverse.MinimisationMethod...
        +"-"+CtrlVar.Inverse.AdjointGradientPreMultiplier...
        +CtrlVar.Inverse.DataMisfit.GradientCalculation...
        +CtrlVar.Inverse.Hessian...
        +"-"+CtrlVar.SlidingLaw...
        +"-"+num2str(CtrlVar.DevelopmentVersion);
else
    CtrlVar.Experiment="Mountain-Forward"...
        +CtrlVar.ReadInitialMeshFileName;
end


filename=sprintf('IR-%s-%s-Nod%i-%s-%s-Cga%f-Cgs%f-Aga%f-Ags%f-m%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    UserVar.m,...
    CtrlVar.Inverse.InvertFor);

CtrlVar.Experiment=replace(CtrlVar.Experiment," ","-");
filename=replace(filename,'.','k');

CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;


end
