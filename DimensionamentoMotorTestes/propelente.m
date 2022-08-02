clc;
clear;
close;

% parâmetros do propelente
rho = 1730;           % densidade do propelente (kg/m^3)
De = 2 * 0.020;       % diâmetro externo do propelente (m)
Di = 2 * 0.004;       % diâmetro interno do propelente (m)
mp_original = 0.300   % massa do propelente original (kg)

% parâmetros do motor de teste
hc = 0.14151;         % comprimento da câmara de combustão (m)

% parâmetros do isolamento térmico
e = 2e-3;             % espessura do isolamento térmico (m)

% comprimento do propelente original
hp_original = mp_original/(rho*pi*(De^2-Di^2)*0.25)

% massa máxima possível do propelente
mpmax = (rho*pi*(De^2-Di^2)*0.25) * hc - e

% comprimeto máximo do propelente
hpmax = hc - e

% massa x comprimento
i = 1;
mp(1) = 0.200;
hp(1) = mp(i)/(rho*pi*(De^2-Di^2)*0.25);
while (mp(i) <= 0.400)
    i = i + 1;
    mp(i) = mp(i-1) + 0.001;
    hp(i) = mp(i)/(rho*pi*(De^2-Di^2)*0.25);
end

figure(1);
scatter(mp_original,hp_original,'MarkerEdgeColor',[0.4660 0.6740 0.1880],...
        'MarkerFaceColor',[0.4660 0.6740 0.1880],'LineWidth',1.5);
hold on;
scatter(mpmax,hpmax,'MarkerEdgeColor',[0.8500 0.3250 0.0980],...
        'MarkerFaceColor',[0.8500 0.3250 0.0980],'LineWidth',1.5);
hold on;
plot(mp,hp,'Color',[0 0.4470 0.7410],'LineWidth',2);
hold off;
grid on;
xlabel('Massa (kg)');
ylabel('Comprimento (m)');
legend('Comprimento Original (m)','Comprimento Máximo (m)','Variação Massa x Comprimento (m)',...
       'Position',[0.454580278312328 0.150793674481766 0.435714275443128 0.126190472784497]);
