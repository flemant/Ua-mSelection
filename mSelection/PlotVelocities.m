function [] = PlotVelocities(x,y,ubMeas,vbMeas,ubCalc,vbCalc,mValue)
%PLOTVELOCITIES Plot Measured, Calculated and Calc-Meas velocities

    figure;
    QuiverColorGHG(x,y,ubMeas,vbMeas)
    ylabel('y (m)')
    xlabel('x (m)')
    title("Measured Velocity"+int2str(mValue))

    figure;
    QuiverColorGHG(x,y,ubCalc,vbCalc)
    ylabel('y (m)')
    xlabel('x (m)')
    title("Calculated Velocity"+int2str(mValue))

    figure;
    QuiverColorGHG(x,y,ubCalc-ubMeas,vbCalc-vbMeas)
    ylabel('y (m)')
    xlabel('x (m)')
    title("ubCalc-ubMeas, vbCalc-vbMeas")
end

