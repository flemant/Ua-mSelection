function [UserVar,C,m,q,mu]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

persistent FC

m=UserVar.m;
q=1;      % Only used in the Budd sliding law
mu=0.5 ;  % Used in sliding laws involving Couloum friction such as minCW, rpCW, and rCW 

if ~UserVar.Slipperiness.ReadFromFile
    
    
    ub=10 ; tau=80 ; % units meters, year , kPa
    C0=ub/tau^m;
    C=C0;
    
    
else     % For the diagnostic run
%% DO NOT CHANGE THIS SECTION; THIS IS NECESSARY TO LOAD C FROM THE INVERSION FOR THE DIAGNOSTIC RUN    
    
    if isempty(FC) 

        % create a FC file
        load('C-EstimateWeertman.mat','C','xC','yC') %Read the file created by the inverse run
        FC=scatteredInterpolant(xC,yC,C); 
        save(UserVar.CFile,'FC')
    end
    
    C=FC(MUA.coordinates(:,1),MUA.coordinates(:,2));
    C=kk_proj(C,CtrlVar.Cmax,CtrlVar.Cmin) ;
    
end
