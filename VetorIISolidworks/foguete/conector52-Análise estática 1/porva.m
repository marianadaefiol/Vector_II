mpolvora = 0.1:0.05:2; %gramas
r = 0.0295; %metros
h = 0.085; %metros
vol1 = pi*r^2 * h;%metros^3
R = 8.20574e-05;
p1 = 1;%atm
t1 = 300; %kelvin

modCisNY = 190e6; %MPa - Nylon

Ai = 2*pi*r^2 + 2*pi*r*h;


%t2 = 300:1:500; %kelvin

massaAr  = 1.1644.*vol1;

n1 = p1*vol1/(R*t1);

Q = 4039.26*(mpolvora./1202); %kJ
c = 1.012;
deltaT = Q/(massaAr*c);
t2 = t1 + deltaT;

n2 = n1 + 11*(mpolvora./1202);

p2 = (p1*n2.*t2)/(n1*t1);

p2_PASCAL = p2*101325;
%plot(t2,p2)
F = p2_PASCAL * Ai;
Fcis = modCisNY * Ai;
plot(mpolvora,F)
grid on