%%
% This is first part of work that we wanna bring data from file.
clear all
clc
% we set the file path here
file='iu.xlsx';

% Here we are reading datas from excel file
% reading from file's first sheet!
[A B] = xlsread(file, 1);
numberOfSubjects = size(A,1);
ConflictLessons = zeros(numberOfSubjects, numberOfSubjects);
% Making ConflictLessons conflict teacher for ConflictLessons
for i = 1 : numberOfSubjects
    for j = 1 : numberOfSubjects
        if i ~= j && ((~isequal(B{i+1,5},B{j+1,5}) && A(i,1)==A(j,1)) || isequal(B{i+1,12},B{j+1,12}))
            ConflictLessons(i,j) = 1;
        end
    end
end

ClassPerSubject = A(:, 6);
NumberOfStudents = A(:, 11);
if (size(A,2) > 11)
    SoftConstraint = A(:, 12:15);    
else
    SoftConstraint = nan(size(A,1), 4);
end
% reading from file's second sheet
[C D] = xlsread(file, 2);
NumberOfTime = size(C, 1);
SoftConstraintPerTime = C(:, 3:7);
SoftConstraintPerTime = SoftConstraintPerTime(:);

% reading from file's third sheet
[E F] = xlsread(file, 3);
ClassCapcity = E;
%%
% in this part we manage GA with ga tool of matlab!


% Defining fitness and choromosome as ga's arguments
FitnessFcn = @(x) Fitness(x, ConflictLessons, ClassCapcity, NumberOfTime, ClassPerSubject, NumberOfStudents, SoftConstraintPerTime, SoftConstraint);
% options = optimoptions(@ga,'MaxGenerations',200,'PopulationSize',500, ...
%                             'PlotFcn', @gaplotbestf, ... 
%                             'HybridFcn',@patternsearch, ...
%                             'MutationFcn', {@mutationuniform, 0.1}, ...
%                         'MaxStallGenerations',50,'UseVectorized',true);
[x, fval, reason, output] = ga(FitnessFcn, numberOfSubjects, [], [], [], [], zeros(numberOfSubjects, 1), ones(numberOfSubjects, 1), []);
[f fval]=MyFitness(x,ConflictLessons,ClassCapcity,NumberOfTime,ClassPerSubject,NumberOfStudents,SoftConstraintPerTime,SoftConstraint);

%%
% Managing information for exporting to the final file.

for i=1:size(fval,1)
    q=[];qs=1;
    for j=1:size(fval,2) 
        d=fval(i,j);
        if (d>0)
            q=[q B{d+1,5} '-' B{d+1,4} '-'  B{d+1,11} ' ' B{d+1,12} '-' F{j+1,1} char(10)];
            qs=qs+1;
        end
    end
    q=q(1:end-1);
    
    temp=ceil(i/NumberOfTime);
    time=i- (temp-1)*NumberOfTime;
    D{time+1,temp+1}=q;
end

%%
% exporting information to excel result file 
xlswrite('result.xlsx',D);

hExcel = actxserver('Excel.Application');
hWorkbook = hExcel.Workbooks.Open([cd '\result.xlsx']);
hWorksheet = hWorkbook.Sheets.Item(1);
hWorksheet.Columns.Item(1).columnWidth = 15; 
hWorksheet.Columns.Item(2).columnWidth = 40; 
hWorksheet.Columns.Item(3).columnWidth = 40; 
hWorksheet.Columns.Item(4).columnWidth = 40; 
hWorksheet.Columns.Item(5).columnWidth = 40; 
hWorksheet.Columns.Item(6).columnWidth = 40; 
hWorkbook.Save;
hWorkbook.Close;
hExcel.Quit;

%%