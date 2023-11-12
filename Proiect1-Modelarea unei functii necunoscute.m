load("proj_fit_14.mat")
id.X;
id.Y; 
val.X;
val.Y;  
figure;
mesh(id.X{1},id.X{2},id.Y)
mesh(val.X{1},val.X{2},val.Y)
title("Grafic Initial")
phi = [];
phi_val=[];
theta=[];
n=30;
MSE1=zeros(1,n);
MSE2=zeros(1,n);

for n=1:30
%matricea phi de identificare
N=length(id.X{1}); %nr de puncte din setul de identificare
il = 1; %indexul liniei
for i = 1:N
for j = 1:N
   ic = 1; %indexul coloanei
for m = 0:n %putere
for w = 0:n %putere
   if m + w <= n
    if m == 0 && w == 0
       phi(il, ic) = 1; % Prima coloană este întotdeauna 1
     else
    phi(il, ic) = id.X{1}(i)^m * id.X{2}(j)^w; % Calculează valorile pentru celelalte coloane
    end
    ic = ic + 1;
    end
    end
    end
    il = il + 1;
    end
end
% matricea phi de validare
M=length(val.X{1});
il_val = 1;
for z = 1:M
for b= 1:M
   ic_val = 1;
for p= 0:n
for t = 0:n
   if p+t <= n
 if p == 0 && t == 0
     phi_val(il_val, ic_val) = 1; % Prima coloană este întotdeauna 1
    else
   phi_val(il_val, ic_val) = val.X{1}(z)^p * val.X{2}(b)^t; % Calculează valorile pentru celelalte coloane
    end
    ic_val = ic_val + 1;
    end
    end
    end
il_val = il_val + 1;
end
end

Y_id=reshape(id.Y,N*N,1);
theta=phi\Y_id;
y_aprox_id=phi*theta;
y_aprox1_id=reshape(y_aprox_id,N,N);

Y_val=reshape(val.Y,M*M,1);
y_aprox_val=phi_val*theta;
y_aprox1_val=reshape(y_aprox_val,M,M);

if n==4
    figure
mesh(y_aprox1_id)
title("Aproximare si identificare")

figure
mesh(y_aprox1_val)
title("Aproximare si validare")
end
    
%MSE pentru identificare
e1=ones(N, 1); %matrice care sa stocheze toate valorile e1
for k=1:N
e1(k)=id.Y(k)-y_aprox1_id(k);
end
MSE1(n)=1/N*sum(e1.^2);

%MSE pentru validare
e2=ones(M, 1); %matrice care sa stocheze toate valorile e2 
for K=1:M
e2(K)=val.Y(K)-y_aprox1_val(K);
end
MSE2(n)=1/M*sum(e2.^2);
[minim,min_gr]=min(MSE2);
end

figure
plot(1:n,MSE1)
title("Eroarea Medie Patratica 1")

figure
plot(1:n,MSE2)
title("Eroarea Medie Patratica 2")
fprintf('MSE MINIM ESTE IN PUNCTUL:%f \nmin grad%d',min(MSE2),min_gr)