function   [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
%     m=1 ; C=1e-1 ;  
    m=3 ; C=1e-4 ; 
    factor=1; 
    C=factor*C ; %  For example setting factor=2 and then re-running will show you the effect of doubling the value of C. 
    
    C=C+zeros(MUA.Nnodes,1);
   
end
