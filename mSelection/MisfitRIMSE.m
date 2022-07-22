function [RIMSE] = MisfitRIMSE(ubMeas,vbMeas,ubCalc,vbCalc,uErr,MUA)
%MISFITIRMSE Calculates the Root Integrated Mean Square Error
RSS=((ubMeas-ubCalc).^2+(vbMeas-vbCalc).^2)/uErr.^2;
Area=MUA.Area;
Int=FEintegrate2D([],MUA,RSS);
RIMSE=sqrt(sum(Int)/Area);

end
