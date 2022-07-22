function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent FB Fs Fb FS Frho


fprintf('DefineGeometry %s \n',FieldsToBeDefined)

if isempty(FB)
    
    fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
    load(UserVar.GeometryInterpolant,'FB','Fb','Fs','FS','Frho')
    fprintf(' done \n')
    
end

g=9.81/1000;

if contains(FieldsToBeDefined,'S')
    S=FS;
else
    S=NaN;
end

if contains(FieldsToBeDefined,'s')
    s=Fs;
else
    s=NaN;
end

b=NaN; B=NaN;

if contains(FieldsToBeDefined,'b')  || contains(FieldsToBeDefined,'B')
    
    B=FB;
    b=Fb;
       
end



if contains(FieldsToBeDefined,'rho')
    rho=Frho(1);
    rhow=1030;
else
    rho=NaN;
    rhow=NaN;
end

end




