function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

%%

persistent hLast nCounter timeLast length time hmax 





if UserVar.SaveFileEachRunStep

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7
        mkdir('ResultsFiles') ;
    end


    FileName=['ResultsFiles/',sprintf('%07i',round(100*CtrlVar.time)),'-TransPlots-',CtrlVar.Experiment];
    fprintf(' Saving data in %s \n',FileName)
    save(FileName,'CtrlVar','MUA','F')

end




if isempty(nCounter)

    nCounter=0;

    length=NaN(1000,1);  % I'm preallocating here, 1000 is just a number that I think will be large enough
    time=NaN(1000,1) ;   % This number should be at least as large as the number of runsteps.
    hmax=NaN(1000,1) ;
    

end

x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

nCounter=nCounter+1 ;

if UserVar.PlotFigures
    
    if nCounter>1

        dt=CtrlVar.time-timeLast;

        if dt>0

            dhdt=(F.h-hLast)/dt ;


            %FindOrCreateFigure("dh/dt") ;
            %plot(x/1000,dhdt,'.')
            %xlabel('x (km)') ; ylabel('dh/dt (m/yr)') ;
            %title(sprintf('dh/dt=%-g (yr)',CtrlVar.time)) ;

        end
    end

    [~,I]=sort(x);


end

hLast=F.h ;
timeLast=CtrlVar.time ;



%%
%x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);
%FindOrCreateFigure("Velocity in x direction") ;
%plot(x/1000,F.ub,'.') ; xlabel('x (km)') ; ylabel('y (m/a)') ; title(sprintf('t=%-g (yr)',CtrlVar.time)) ;
%%

%FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA) ;

%% Identify a steady state

L=max(sqrt(x(F.h>2).^2+y(F.h>2).^2));  
% this is the length of the glacier,
% but note that right at the beginning of the run
% there might not be any nodes where the thickness is
% greater than the minimum value (this would result in L
% being empty).
if ~isempty(L)

    % now put length and time into seperate (persitent) variables.
    
    length(nCounter)=L;
    time(nCounter)=CtrlVar.time ;
    hmax(nCounter)=max(F.h) ;

    % figure ; plot(time,length/1000) ; ylabel('length (km)' ) ; xlabel('time (yr)')


end


if CtrlVar.DefineOutputsInfostring=="Last call"
    % OK, so this is the last time this m-file is called during the run.
    % And now we save the data into a file, so that we can then read it in
    % later and plot the results.
    save("MyData_Geom2IbismeshRRm3.mat","CtrlVar","time","F","length","hmax")
    
    FindOrCreateFigure("Maximum Ice thickness") ;
    plot(time,hmax,'.') ;
    xlabel('time (yr)') ; ylabel('ice maximum thickness (m)') ;
    title(sprintf('t=%-g (yr)',CtrlVar.time)) ;

    FindOrCreateFigure("Length of the glacier") ;
    plot(time,length/1000,'.') ;
    xlabel('time (yr)') ; ylabel('length (km)') ;
    title(sprintf('t=%-g (yr)',CtrlVar.time)) ;


end




end
