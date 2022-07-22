
function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

%  as   is the upper surface (local) mass balance in the units m/a (m/yr)
%  ab   is the lower surface (local) mass balance in the units m/a

x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2) ;
%% Geometry 1
% l0=40e3;
% a0=15;
% a1=-2*a0/l0;
% as=a0+a1*sqrt(abs(x).^2+abs(y).^2) ;
% ab=x*0 ;
% asMin=-5; 
% as(as<asMin)=asMin;


%% Geometry 2A
l0=40e3;
a0=15;
a1=-2*a0/l0;
a2=-3; % change in MB due to climate change
as=a0+a1*sqrt(abs(x).^2+abs(y).^2)+a2 ;
ab=x*0 ;
asMin=-5; 
as(as<asMin)=asMin;


end

