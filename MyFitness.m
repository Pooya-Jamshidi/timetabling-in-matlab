function [f fval]=MyFitness(x,Lessons,ClassCapcity,NumberOfTime,ClassPerSubject,NumberOfStudents,SoftConstraintPerTime,SoftConstraint)

f=0;

NumberOfLessons = length(x);
p = 1 : NumberOfLessons;
r = x(1 : NumberOfLessons);

fval = zeros(NumberOfTime * 5, length(ClassCapcity));
Helping = zeros(NumberOfTime * 5, NumberOfLessons);

for i=1:length(ClassPerSubject)    
    [fval Helping flag]=Helper(p(i),ClassPerSubject(p(i)),NumberOfStudents(p(i)),r(i),fval,Helping,Lessons,ClassCapcity);
    if (flag == 0)
        f=inf;
        break;
    end
end
A = fval;
I = find(A>0);
A(I) = NumberOfStudents(A(I));

f1=sum(sum(A.*repmat(SoftConstraintPerTime,[1 size(A,2)])));


ClassCapcity = repmat(ClassCapcity', [size(A,1) 1]);
bosyer = ClassCapcity - A;
f2 = sum(sum(bosyer(I)));

% SoftConstraint 
J = find(~isnan(SoftConstraint(:,1)));

f3=0;
for i=1:length(J)
    
    mask_sinif = zeros(1,size(fval,2));
    if SoftConstraint(J(i),1) == 0
        mask_sinif = ones(1,size(fval,2));
    else
        mask_sinif(SoftConstraint(J(i),1)) = 1;
    end
    mask_gun=zeros(1,5);
    if SoftConstraint(J(i),2) == 0
        mask_gun=ones(1,5);
    else
        mask_gun(SoftConstraint(J(i),2)) = 1;
    end
    mask_saat = zeros(NumberOfTime,1);
    if SoftConstraint(J(i),3) == 0
        mask_saat = ones(NumberOfTime,1);
    else
        mask_saat(SoftConstraint(J(i),3):min(NumberOfTime,SoftConstraint(J(i),3)-1+ClassPerSubject(J(i))))=1;
    end
    mask_ts=[];
    for j = 1 : length(mask_gun)
        if mask_gun(j) == 1
            mask_ts=[mask_ts;mask_saat];
        else
            mask_ts=[mask_ts;zeros(length(mask_saat),1)];
        end
    end
    mask=[];
    for j = 1 : length(mask_sinif)
        if mask_sinif(j) == 1
            mask = [mask mask_ts];
        else
            mask = [mask zeros(length(mask_ts),1)];
        end
    end
    f3 = f3 + sum(sum((fval==J(i)).*A.*mask*SoftConstraint(J(i),4)));
end

f=f1-f2-f3;

end