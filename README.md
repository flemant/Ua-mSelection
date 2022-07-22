# mSelection
An algorithm to estimate the sliding exponent of a glacier written in Matlab 

This code requires the open source ice flow model Ua (https://github.com/GHilmarG/UaSource). It calculates the best estimate of the sliding exponent of Weertman sliding law. \
The algorithm requires the velocity field and geometry of a glacier at two different times. For now it has been tested only on synthetic geometries.\
The estimation of m consists in a minimisation problem. A cost function Gamma, function of m, is minimized to find the best estimate of m. \
The folder Mountain contains the synthetic data I used.\
The folder mSelection contains the algorithm of selection of m. The m-estimation algorithm is implemented as a script (mSelection/mSelect) or a function (mSelection/mSelectFunction) which can be called with the script mSelection/mSelectUsingFunction.\
The algorithm communicates with the ice flow model Ua thank to two files which are modified during the run (DataFile and UserFile). The inputs of the ice flow model are defines in the folder mEstimation\MountainCalculation. Some parts of DefineInitialInputs, DefineInitialInputsForInverseRun, DefineSlipperyDistribution and DefineOutputs must not be modified for the program to work. They are marked in section with %% DO NOT CHANGE THIS SECTION. You can mody these files with your own but you must keep theses sections.\
Is you use real data, mSelection\MountainCalculation\DefineInitialInputsForInverseRun and mSelection\mSelect must be modified to interpolates the data on the nodes of the mesh.\
