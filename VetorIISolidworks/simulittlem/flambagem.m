%graph%
x = [0 20 30 40 50 100 220];
y = [0.04334 0.03028 0.030296 0.03034 0.0302 0.030209 0.03025];
z = [0 6.941 10.197 13.464 16.72 33.0222 72.149];

plot3(x,y,z,'b');
xlabel('Comprimento do Reforço (mm)');
ylabel('Índice de flambagem (AMPRES)');
zlabel('Massa adicionada (g)');
grid on;