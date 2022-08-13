function [mn] = updatedata(b)
%this method get the data from each date of month and calculate the mean 
% and save it for the next  month data
%   Detailed explanation goes here
dte=b.Var1;
for i = 1:length(b.ExtraVar7)
   z(i) = str2num(cell2mat((b.ExtraVar7(i)))); 
end
hdt= z';
Strdte = extractBetween(string(dte),1,19);
dtem=datetime(extractBetween(string(dte),1,19),'InputFormat','yyyy-MM-dd HH:mm:ss');
varNames=["DATE","H"];
tbl=table(dtem,hdt,'VariableNames',varNames);
gm = findgroups(month(tbl.DATE));

m1=tbl(find(gm==1),:);
gd1 = findgroups(day(m1.DATE));
gd1m=splitapply(@daymean,m1.H,gd1);

m2=tbl(find(gm==2),:);
gd2 = findgroups(day(m2.DATE));
gd2m=splitapply(@daymean,m2.H,gd2);

m3=tbl(find(gm==3),:);
gd3 = findgroups(day(m3.DATE));
gd3m=splitapply(@daymean,m3.H,gd3);

allmean=vertcat(gd1m,gd2m,gd3m);



mn = allmean;
end