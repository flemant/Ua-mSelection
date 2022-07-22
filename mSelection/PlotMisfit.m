function [] = PlotMisfit(mList,RIMSE)
%PLOTMISFIT Plots the RIMSE (misfit)
%% Plot RIMSE
figure;
plot(mList,RIMSE,'- .k','LineWidth',1.5,'MarkerSize', 18,'MarkerFaceColor','r','MarkerEdgeColor','r')
ylabel('$\Gamma$','interpreter','latex')
xlabel('$m$','interpreter','latex')
ax = gca; 
ax.FontSize = 18;
ax.TickLabelInterpreter="latex";

end

