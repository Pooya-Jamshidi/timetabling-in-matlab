function [fval DersAtanabilir sonuc]=Helper(ders,derssaat,dersmevcut,secme,fval,DersAtanabilir,Cakisma,Derslik)


sonuc=1;
Gunsaat=size(fval,1)/5;
Toplam=fval(1:end-derssaat+1,:);
toplam=DersAtanabilir(1:end-derssaat+1,ders);
for i=1:derssaat-1
    Toplam=Toplam+fval(i+1:end-derssaat+1+i,:);
    toplam=toplam+DersAtanabilir(i+1:end-derssaat+1+i,ders);
end

for i=1:4
    Toplam(i*Gunsaat+2-derssaat:i*Gunsaat,:)=1;
end

Toplam=Toplam+repmat(toplam,[1 size(Toplam,2)]);


I=double(Derslik-dersmevcut<0)';
Toplam=Toplam+repmat(I,[size(Toplam,1) 1]);

I=find(Toplam'==0);
if (length(I)==0)
    sonuc=0;
    return;
end

s=ceil(secme*length(I));
if s==0
    s=1;
end
saat=ceil(I(s)/size(Toplam,2));
sinif=I(s)-(saat-1)*size(Toplam,2);
fval(saat:saat-1+derssaat,sinif)=ders;
DersAtanabilir(saat:saat-1+derssaat,find(Cakisma(ders,:)==1))=1;


