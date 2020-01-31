%%
% defining fitness function to create chromosome
function scores = Fitness(x, Lessons, ClassCapcity, NumberOfTime, ClassPerSubject, NumberOfStudents, SoftConstraintPerTime, SoftConstraint)
scores = zeros(size(x, 1), 1);
for i = 1 : size(x, 1)  
    
    %[f fval] = myfitness(x{j},Lessons,ClassCapcity,NumberOfTime,ClassPerSubject,NumberOfStudents,SoftConstraintPerTime,SoftConstraint);
    %%
    [f fval] = MyFitness(x(i, :), Lessons, ClassCapcity, NumberOfTime, ClassPerSubject, NumberOfStudents, SoftConstraintPerTime, SoftConstraint);
    scores(i) = f;
    %%
end
%%