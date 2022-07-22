function [Q] = QuantifySelection(RIMSE)
%QUANTIFYSELECTION Quantifies the sharpness of the cost function Q=RIMSE(i+1)-2*RIMSE(i)+RIMSE(i-1)

[r,i]=min(RIMSE);
% RIMSE(i)=[];
% deltar=min(RIMSE-r);
% Q=deltar/r;
Q=RIMSE(i+1)-2*RIMSE(i)+RIMSE(i-1);
% RIMSE(i)=[];
% deltar=min(RIMSE-r);
% Q=deltar;
end

