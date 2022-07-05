%% Carrega e define variáveis
clear 
close all
clc

%%
load empuxosEnsaios.mat; %Arquivo com os dados adquiridos de empuxo no tempo
tsim = 32; %Tempo de simulação
f = 1000; %pontos adquiridos por segundo (Hz)
tplot = [0:(1/f):tsim]'; %Cria vetor com 32000 elementos onde tplot(n+1)-tplot(n)=1/f

N = 5; %Numero de queimas
%%
h_londrina = 1; 
g = 9.80665; %gravidade'
vsom = 340.29;
%Is = 101; %impulso específico
%tq = 4.0; %segundos
mp = 0.260; %massa do propelente
%Massa para cada modelo%

%Modelo atual%
%me = 1.613 + 0.200; % massa da estrutura, paraquedas e eletronicos

%mc = 0.2805;   %massa da carcaça 52mm
mc = 0.5412; %massa da carcaça 54mm
mm = 0.37070+0.17595;
mbb = 0.031;    %massa do beagle bone
mpq = 0.230;    %massa o PÁRAquedas

me = mc + mbb + mpq + 0.1 + mm; %massa da estrutura

%Modelo Fibra de carbono
%me = 1.481 + 0.200; %massa da estrutura fibra de carbono, paraq+eletronic


mi = me + mp;  %massa inicial do foguete

A = (pi/4)*(0.085^2); %área da seção transvesal principal do foguete

%valores iniciais das variaveis
rho_0 = 0.002378 * 515.4; %densidade inicial do ar (kg/m^3)
hmar = h_londrina;
Cd0 = 0.23;

v = zeros(tsim*f+1,N);
h = zeros(tsim*f+1,N);
Cd = zeros(tsim*f+1,N);
Fd = zeros(tsim*f+1,N);
Fr = zeros(tsim*f+1,N);
Acc = zeros(tsim*f+1,N);
v(1) = 0;
h(1) = 0;

%To = %temperatura ambiente (518.4 R = 15 C)
%b = %gradiente da temperatura com a altitude (0.003566R/ft)
%R = %constante dos gases para o ar (53.33089 ft/R)
%rho_0 = 0.002378; %densidade inicial do ar (slug/ft^3) em 744mmHg e 15C
%%

%definir o vetor empuxo 
E(1:tsim*f) = 0;
E = E';

E(1:length(empuxoT1),1) = empuxoT1;
E(1:length(empuxoT2),2) = empuxoT2;
E(1:length(empuxoP1),3) = empuxoP1;
E(1:length(empuxoP2),4) = empuxoP2;
E(1:length(empuxoP3),5) = empuxoP3;



for k = 1:N
    
  
    % Definindo o vetor de massa
    I(:,k) = cumsum(E(:,k))/f; % vetor impulso
    It(1,k) = sum(E(:,k))/f; % impulso total
    m(:,k) = mi - mp*(I(:,k)/It(1,k)); %vetor de massa do foguete

    %define o vetor força peso;
    P = m * g;


    %%

    %Corpo da simulação
    for i = 1 : tsim*f 
%         rho(i,k) = rho_0 * (1 - (0.00000688/0.3048)*(hmar + h(i))).^4.256;
%         if v(i,k) < 238
%             Cd(i,k) = Cd0;
%         elseif v(i,k) < 442
%             Cd(i,k) = 0.32308*log(v(i,k)/vsom)+0.3452;
%         else
%             break; % v>= 442, modelo não funciona
%         end  
        
        rho(i,k) = rho_0 * (1 - (0.00000688/0.3048) * (hmar+h(i))).^ 4.256;
        if norm(v(i,k)) < 238 % v<238
            Cd(i,k) = Cd0;
        elseif norm(v(i,k)) < 442
            Cd(i,k) = 0.32308*log(norm(v(i,k))/vsom)+0.3452 ; %238<=v<442
        else
            break; %v>=442 modelo nÃ£o funciona
        end

        Fd(i,k) = sign(v(i,k))*(1/2)*Cd(i,k)*A*rho(i,k)*(v(i,k)^2);
        Fr(i,k) = E(i,k) - P(i,k) - Fd(i,k);


        if h(i,k) < 0
            h(i,k) = 0;
            v(i,k) = 0;
        end

        Acc(i,k) = Fr(i,k)/m(i,k);
        v(i+1,k) = v(i,k) + (1/f)*Acc(i,k);
        h(i+1,k) = h(i,k) + (1/f)*v(i,k);

        if h(i+1,k) <= 0
            Fr(i,k) = 0;
            Acc(i,k) = 0;
        end


    end
    
    figure(k)
    %plots
    
    subplot(4,1,1)
    plot(tplot(1:tsim*f), Acc(1:tsim*f,k)/g, 'b')
    ylabel('Aceleração (g)')
    
    switch k
        case 1
            title('Propelente T1')
        case 2
            title('Propelente T2')
        case 3
            title('Propelente P1')
        case 4
            title('Propelente P2')
        case 5
            title('Propelente P3')
    end
    
    subplot(4,1,2)
    plot(tplot(1:tsim*f), v(1:tsim*f,k), 'b')
    ylabel('Velocidade (m/s)')

    subplot(4,1,3)
    plot(tplot(1:tsim*f), h(1:tsim*f,k), 'b')
    ylabel('Altura(m)')

    subplot(4,1,4)
    plot(tplot(1:tsim*f), -Fd(1:tsim*f,k), 'b')
    ylabel('Drag (kgm/s^2)')

    xlabel('Tempo(s)')
    
    

end

H_max(1,:) = max(h(:,:))
v_max(1,:) = max(v(:,:))
a_max(1,:) = max(Acc(:,:)/g)
Fd_max(1,:) = max(Fd(:,:))



%%
subplot(3,1,1)
bar(H_max(1,:))
text(1:length(H_max(1,:)),H_max(1,:),num2str(H_max(1,:)'),'vert','bottom','horiz','center'); 
box off
ylabel('Altura Máxima (m)')
%title('Alturas, velocidades e acelerações máximas')

subplot(3,1,2)
bar(v_max(1,:))
text(1:length(v_max(1,:)),v_max(1,:),num2str(v_max(1,:)'),'vert','bottom','horiz','center'); 
box off
ylabel('Velocidade máxima (m/s)')

subplot(3,1,3)
bar(a_max(1,:))
text(1:length(a_max(1,:)),a_max(1,:),num2str(a_max(1,:)'),'vert','bottom','horiz','center'); 
box off
ylabel('Aceleração máxima (g)')

