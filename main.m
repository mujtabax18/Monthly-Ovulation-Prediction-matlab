clc
close all;
clear all;

%% loading data from all weeks
files = dir('weeks/*.csv');
opts = delimitedTextImportOptions('DataLines',100); 
b=[];
for i=1:length(files)
    file = fullfile(files(i).folder, files(i).name);
    b =vertcat(b,readtable(file,opts,'ReadVariableNames', false));
end
%% processing and updating data
allmean=updatedata(b);
%% Import Data 
opts = detectImportOptions('train.xlsx'); 
train = readtable("train.xlsx",opts);
train=train(:,["DATE","BBT","BBP","Activity","Output"]);
train1= train(:,["BBT","BBP","Activity","Output"]);
%% plot the Graphs
plotgraphs(train1);

%% updated data part
%% Import Data 
q = train;
q.Activity=allmean;
q1= q(:,["BBT","BBP","Activity","Output"]);
%% plot the Graphs
figure
plotgraphs(q1);



%% Training and testing 
[net,miniBatchSize]=trainandtest(train1);

%% Predicting new dates
opts = detectImportOptions('test.xlsx'); 
test = readtable("test.xlsx",opts);
test1= test(:,["BBT","BBP","Activity"]);
NxtPred = classify(net,test1,'MiniBatchSize',miniBatchSize);
dd=datenum(test.DATE);
Output=string(NxtPred(:,1));
disp('Next Predicted dates for menstrual cycle')
for i=1:length(Output)
    if(Output(i)=="1")
        fprintf('%s\n',datestr(dd(i)))
    end
end
test2=table(test.DATE,test.BBT,test.BBP,test.Activity,Output);
test2.Properties.VariableNames =train.Properties.VariableNames;
newtrain=vertcat(train(:,["DATE","BBT","BBP","Activity","Output"]),test2);
writetable(newtrain,'results.xlsx','Sheet',1);