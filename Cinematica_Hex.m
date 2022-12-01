% Proyecto de graduacion - Hexapod
% Luis Roberto Salazar - Carnet 17337
% Simulacion y ejecucion de trayectorias 
% Matlab - ESP32

clc;
clear;

L1 = 0.06;
L2 = 0.062;
L3 = 0.131529;

s = 'Rz(q1) Ty(L1) Rx(q2) Ty(L2) Rx(q3) Tz(L3)';
dh = DHFactor(s);
t = dh.tool;
c = dh.command('leg');
leg = eval(c);

W = 0.176619;
L = 0.251619;
R = 0.134;

legs(1) = SerialLink(leg, 'name', 'leg1', 'base', SE3(L/2, W/2, 0)*SE3.Rz(-pi/4));
legs(2) = SerialLink(leg, 'name', 'leg2', 'base', SE3(0, R, 0));
legs(3) = SerialLink(leg, 'name', 'leg3', 'base', SE3(-L/2, W/2, 0)*SE3.Rz(pi/4));
legs(4) = SerialLink(leg, 'name', 'leg4', 'base', SE3(-L/2, -W/2, 0)*SE3.Rz(pi-pi/4));
legs(5) = SerialLink(leg, 'name', 'leg5', 'base', SE3(0, -R, 0)*SE3.Rz(pi));
legs(6) = SerialLink(leg, 'name', 'leg6', 'base', SE3(L/2, -W/2, 0)*SE3.Rz(pi+pi/4));

%% Cinematica Directa
q0 = [0, -pi/4, -pi/4];
q1 = [0, -pi/2, -pi/2];
q2 = [0, -pi/2, pi/4];
T0 = leg.fkine(q0);
T1 = leg.fkine(q1);
T2 = leg.fkine(q2);

%% Matriz CD
for i=1:3
    p(i) = 512 + round(rad2deg(q0(i))/0.29);
end
for j=1:3
    o(j) = 512 + round(rad2deg(q1(j))/0.29);
end
for k=1:3
    b(k) = 512 + round(rad2deg(q2(k))/0.29);
end

P(1) = p(1);
P(2) = p(3);
P(3) = p(2);

O(1) = o(1);
O(2) = o(3);
O(3) = o(2);

B(1) = b(1);
B(2) = b(3);
B(3) = b(2);

sec1 = [P P P P P P]';
sec2 = [O O O O O O]';
sec3 = [B B B B B B]';

secD = [sec1 sec2 sec3];

%% Cinematica Inversa
M1 = transl(0.1, 0.1, 0); % define the start point
M2 = transl(0.1, 0.1, -0.2);	% and destination
Mi = ctraj(M1, M2, 4); 
q = leg.ikine(Mi, 'q0', [0, 0, 0], 'mask',[1, 1, 0, 0, 0, 0]);
qg1 = q(1,:); %Visualizacion
qg2 = q(2,:);
qg3 = q(3,:);
qg4 = q(4,:);
ql = 512 + round(rad2deg( q )/0.29);
ql1 = ql(1,:);
ql2 = ql(2,:);
ql3 = ql(3,:);
ql4 = ql(4,:);

M3 = transl(0.1, 0.1, -0.2); % define the start point
M4 = transl(0.1, 0.1, 0);	% and destination
Mi2 = ctraj(M3, M4, 4);
b = leg.ikine(Mi2, 'q0', [0, 0, 0], 'mask',[1, 1, 0, 0, 0, 0]);
bg1 = b(1,:); %Visualizacion
bg2 = b(2,:);
bg3 = b(3,:);
bg4 = b(4,:);
bl = 512 + round(rad2deg( b )/0.29);
bl1 = bl(1,:);
bl2 = bl(2,:);
bl3 = bl(3,:);
bl4 = bl(4,:);

%% Matriz CI
QL1(1) = ql1(1);
QL1(2) = ql1(3);
QL1(3) = ql1(2);

QL2(1) = ql2(1);
QL2(2) = ql2(3);
QL2(3) = ql2(2);

QL3(1) = ql3(1);
QL3(2) = ql3(3);
QL3(3) = ql3(2);

QL4(1) = ql4(1);
QL4(2) = ql4(3);
QL4(3) = ql4(2);

sec1 = [QL1 QL1 QL1 QL1 QL1 QL1]';
sec2 = [QL2 QL2 QL2 QL2 QL2 QL2]';
sec3 = [QL3 QL3 QL3 QL3 QL3 QL3]';
sec4 = [QL4 QL4 QL4 QL4 QL4 QL4]';

BL1(1) = bl1(1);
BL1(2) = bl1(3);
BL1(3) = bl1(2);

BL2(1) = bl2(1);
BL2(2) = bl2(3);
BL2(3) = bl2(2);

BL3(1) = bl3(1);
BL3(2) = bl3(3);
BL3(3) = bl3(2);

BL4(1) = bl4(1);
BL4(2) = bl4(3);
BL4(3) = bl4(2);

sec5 = [BL1 BL1 BL1 BL1 BL1 BL1]';
sec6 = [BL2 BL2 BL2 BL2 BL2 BL2]';
sec7 = [BL3 BL3 BL3 BL3 BL3 BL3]';
sec8 = [BL4 BL4 BL4 BL4 BL4 BL4]';

% secI = [sec1 sec2 sec3 sec4 sec5 sec6 sec7 sec8];
secI = [sec1 sec2 sec3 sec4];

%% Secuencia a enviar

sec = secD;
% sec = secI;

%% Visualizaciòn
clf;
figure(1);
axis([-0.4 0.4 -0.4 0.4 -0.4 0.4]); %set(gca,'Zdir', 'reverse')
hold on;
patch([L/2 L/2 -L/2 -L/2], [-W/2 W/2 W/2 -W/2], [0.1 0.1 0.1 0.1],'FaceColor', 'r', 'FaceAlpha', 0.5);

for i=1:6
   legs(i).plot(-q0, 'nobase', 'noshadow', 'notiles'); %CD
%    legs(i).plot(-qg4, 'nobase', 'noshadow', 'notiles'); %CI
end
hold off

%% Conexión
for i=1:1
    try
        esp32 = esp32_connect('192.168.50.42');
%         esp32 = esp32_connect('192.168.2.105');
        disp("Server connected.");
    catch
        disp("Error conecting to esp32 server.");
    end
    
    buff = "{m1: " + sec(1,i) + ", m2: " + sec(2,i) + ", m3: " + sec(3,i) + ", m4: " + sec(4,i) + ", m5: " + sec(5,i) + ", m6: " + sec(6,i) + ", m7: " + sec(7,i) + ", m8: " + sec(8,i) + ", m9: " + sec(9,i) + ", m10: " + sec(10,i) + ", m11: " + sec(11,i) + ", m12: " + sec(12,i) + ", m13: " + sec(13,i) + ", m14: " + sec(14,i) + ", m15: " + sec(15,i) + ", m16: " + sec(16,i) + ", m17: " + sec(17,i) + ", m18: " + sec(18,i) + "}";
    m = read(esp32, 11, "string");
    disp(m);
    write(esp32, buff, "string");
    r = read(esp32, 7, "string");
    disp(r);
    pause(1);
end 