function [mChosen] = mSelectFunction(GeometryDataFile,SurfaceVelocityDataFile,GeometryData2File,SurfaceVelocityData2File,BoundaryFile,MeshFile,ResultsFileName,mList)
%MSELECTFUNCTION This function selects the best m given the geometry,
%velocity, boundary, mesh files, name of the result file to write and the
%list of m values to ry

%%  User files: Geometry 1,2 ; Velocities 1,2 ; Boundaries ; Mesh ; m values to try
GeometryDataFile = '..\..\Mountain\GeometryData1meshRRm3.mat'; % Path to geometry 1
SurfaceVelocityDataFile = '..\..\Mountain\SurfaceVelocityData1meshRRm3.mat'; % Path to velocities 1
GeometryData2File = '..\..\Mountain\GeometryData2AmeshRRm3.mat'; % Path to geometry 2
SurfaceVelocityData2File = '..\..\Mountain\SurfaceVelocityData2AmeshRRm3.mat'; % Path to velocities 2
BoundaryFile = '..\..\Mountain\BoundaryRR.mat';             % Path to the boundary file
MeshFile = '..\..\Mountain\RRMeshFile.mat';                 % Path to the mesh file
ResultsFileName = "ResultsFile2AmeshRRm3FR.mat";            % Name of the results file to read
mList = [1,2,3,4,5,6,7,8,9,10];                             % m values I want to try

%% Creates two files to save data names and the value of m
load(MeshFile(4:end))                                       % Loading the mesh to have the area in order to calculate the RIMSE misfit, the relative path changes because I am not in the MountainCalculation folder
RIMSE = mList*0;                                            % Pre allocating the value of the misfit
m = 1 ;                                                     % The value doesn't matter it will be changed in the loop
i = 0;                                                      % List index (loop on the value of m, but need to change the value of the misfit)
RunType = 'Inverse-MatOpt';                                 % This is the RunType read by Ua, at first it is inverse then diagnostic, do not change
% This file defines the path to geometry and velocities, it is read by Ua to get the geometries, 
% velocities, mesh, boundaries and RunType. It is updated during the run
DataFile = matfile('DataFile.mat','Writable',true);
save("DataFile.mat","GeometryDataFile","SurfaceVelocityDataFile","BoundaryFile","MeshFile","RunType")
DataFileName = pwd+"\DataFile.mat";
% This file contains m and the name of the diagnostic run files, it is read by Ua to get m 
% and written by Ua to save the name of the diagnostic filename. It is updated during the run
UserFile = matfile('UserFile.mat','Writable',true); 
save("UserFile.mat","m")
UserFileName = pwd+"\UserFile.mat";

for m = mList                                               % Loop over the values of m
    i = i+1;                                                % Index for the misfit list
    UserFile.m = m;                                         % Update m in the UserFile

    %% Inversion
    cd MountainCalculation\                                 % Go to the inversion folder located at Ua\YouFileName\mSelection\MountainCalculation
    Ua                                                      % Launch an inverse run for log(A), log(C) for geometry 1, with m imposed
    close all
    ClearPersistent                                         % This function is in the MountainCalculation folder, it clears the persistent variables of Define scripts

    %% Diagnostic run with the second geometry, C from the inversion and initial m
    DataFile.GeometryDataFile = GeometryData2File;          % Use the 2nd geometry
    DataFile.SurfaceVelocityDataFile = SurfaceVelocityData2File; % Use the 2nd velocity file
    DataFile.RunType = 'Forward-Diagnostic';                % Change the RunType to Diagnostic
    Ua                                                      % Launch a diagnostic run for geometry 2 with C from the inversion (This is specified in DefineSlipperyDistribution)
    
    %% Change DataFile to geometry 1 for inverse run
    DataFile.GeometryDataFile = GeometryDataFile;           % Use the 1st geometry
    DataFile.SurfaceVelocityDataFile = SurfaceVelocityDataFile; % Use the 1st velocity file
    DataFile.RunType = 'Inverse-MatOpt';                    % Change the RunType to Inverse
    ClearPersistent                                         % Clear persistent variables in Define functions

    %% Calculate the misfit between the velocity for geometry 2 and the velocity for geometry 2 with the inverted C
    load(UserFileName,"DiagnosticFilename")                 % Get the name of the forward diagnostic file for this m
    load(DiagnosticFilename,"F")                            % Get the F field
    FDiag = F; ubCalc = FDiag.ub; vbCalc = FDiag.vb;        % Calculated fields

    load(SurfaceVelocityData2File)                          % Get the measured velocity for geometry 2, CHANGE IF USING REAL MEASUREMENTS: INTERPOLANTS
    ubMeas = FuMeas; vbMeas = FvMeas; uErr = FerrMeas;      % Measured fields
    % IF USING REAL DATA: 
    % ubMeas = double(FuMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
    % vbMeas = double(FvMeas(MUA.coordinates(:,1),MUA.coordinates(:,2))); 
    % uErr = double(FerrMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
    % MissingData = isnan(Meas.us) | isnan(Meas.vs) | isnan(Err) | (Err==0);
    % Meas.us(MissingData) = 0 ;  Meas.vs(MissingData) = 0 ; Err(MissingData) = 1e10;

    cd ..\                                                  % Calculate the misfit in the right folder Ua\YouFileName\mSelection
    RIMSE(i) = MisfitRIMSE(ubMeas,vbMeas,ubCalc,vbCalc,uErr,MUA); % Calculate the misfit
    
    %% Plotting both velocity fields to check
    PlotVelocities(F.x,F.y,ubMeas,vbMeas,ubCalc,vbCalc,m)
    
end
save("ResultsFile.mat","RIMSE","mList")                     % Save misfit data to plot
save(ResultsFileName,"RIMSE","mList")                       % Save misfit data to plot in the right folder

%% Plot Misfit
PlotMisfit(mList,RIMSE)

%% Select m
[r,i] = min(RIMSE);                                         % Get the indice of the minimum
mChosen = mList(i)                                          % Get the corresponding m

end