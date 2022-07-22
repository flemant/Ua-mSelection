%% This script estimates the best m given two geometries and velocities. Before usD:\ing it you must:
% Have the folder MoutainCalculation 
% Modify the file DefineInputsForInverseRun if you use real data (replace with interpolants)
% You can change the Define files with your own but you must keep line 4 to
% 13 of DefineInitialInputs, line 17 to 29 of
% DefineSlipperyDistribution, line 29 to 45 of DefineOutputs
% Modify the following FileNames with your file names
% Modify the m values you want to try
% Modify line 49 of the function mSelectFunction: ubMeas=FuMeas; vbMeas=FvMeas; uErr=FerrMeas
% ; they are interpolated on the nodes of the mesh

%%  User files: Geometry 1,2 ; Velocities 1,2 ; Boundaries ; Mesh ; m values to try
GeometryDataFile='D:\Documents\Ecole\ENS\Stage\Northumbria_M1\Ua\Ua-mSelection\Mountain\GeometryData1meshRRm3.mat';    % Path to geometry 1
SurfaceVelocityDataFile='D:\Documents\Ecole\ENS\Stage\Northumbria_M1\Ua\Ua-mSelection\Mountain\SurfaceVelocityData1meshRRm3.mat';  % Path to velocities 1
GeometryData2File='D:\Documents\Ecole\ENS\Stage\Northumbria_M1\Ua\Ua-mSelection\Mountain\GeometryData2AmeshRRm3.mat';  % Path to geometry 2
SurfaceVelocityData2File='D:\Documents\Ecole\ENS\Stage\Northumbria_M1\Ua\Ua-mSelection\Mountain\SurfaceVelocityData2AmeshRRm3.mat';  % Path to velocities 2
BoundaryFile='D:\Documents\Ecole\ENS\Stage\Northumbria_M1\Ua\Ua-mSelection\Mountain\BoundaryRR.mat';                   % Path to the boundary file
MeshFile='D:\Documents\Ecole\ENS\Stage\Northumbria_M1\Ua\Ua-mSelection\Mountain\RRMeshFile.mat';                       % Path to the mesh file
ResultsFileName="ResultsFile2AmeshRRm3FR.mat";                                                                         % Name of the results file to read
mList=[1,2,3,4,5,6,7,8,9,10];                                                                                          % m values you want to try

mChosen = mSelectFunction(GeometryDataFile,SurfaceVelocityDataFile,GeometryData2File,SurfaceVelocityData2File,BoundaryFile,MeshFile,ResultsFileName,mList);
