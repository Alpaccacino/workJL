%% READ ME
% Kör koden först för att definera alla variabler. Efter det kan man
% simulera i simulink

%
clc
clear
close all

% Definera parametrar

g = 9.82;                           %tyngdacceleration

r_sfar = 0.25;                      %sfärens radie
r_hjul = 0.05;                      %hjulens radie

m_sfar = 3.2;                       %skalets massa
m_innan = 8.0;%8.8 används i dagsläget %byt till riktig %"vagnens" massa. testa 2.0,8.0,16.0

l_sfar = (2/3)*m_sfar*(r_sfar)^2;    %Tröghet
mc = 2/3*r_sfar;                    %centrums massa, position från centrum av sfären (uppskattad)

M_sfar = 0;
M_hjul = 0;

Theta_1 = 0;
Theta_2 = 0;
I_inre = 0;

% DC-Motor experiment

%Ej riktiga värden! Endast för test!

J = 0.01;           %moment of inertia of the rotor     0.01 kg.m^2
b = 0.1;            %motor viscous friction constant    0.1 N.m.s
Ke = 0.01;          %electromotive force constant       0.01 V/rad/sec
Kt = 0.01;          %motor torque constant              0.01 N.m/Amp
R = 1;              %electric resistance                1 Ohm
L = 0.5;            %electric inductance                0.5 H

%% L(s)
clc

syms s K Kp Ki Kd N 

% K = 5.237;
% Kp = 5;
% Ki = 18.10;
% Kd = 0.26;
% N = 157;


Fs = Kp + Ki/s + Kd*N/(1+N/s);
Gs = (K)/(s^3 + s^2 + 104.7*s + 104.7);

Ls = Fs*Gs;

Karekv = K*(Kp + Ki/s + Kd*N/(N/s + 1)) + s^3 + s^2 + 104.7*s + 104.7 %?

% karekv1 = det(karekv);
% roots = root(karekv1);

%% räkning 
clc

syms s
b=[1 158.7 262.4 1.662*10^4 1.652*10^4 0 0];
a=[240.9 4224 1.495*10^4 0];
[r,p,k]=residue(b,a);
c1=1.0*10^3;
F=((c1*-3.0257/(s+12.6147))+(c1*0.2049/(s+4.9196))+k);
ilaplace(F);

% Lb=s^6 + 158.7*s^5 + 262.4*s^4 + 1.662*10^4*s^3 + 1.652*10^4*s^2;
% La=240.9*s^3 + 4224*s^2 + 1.495*10^4*s;
% L=Lb/La;
L=tf([240.9 4224 1.495*10^4 0],[1 158.7 262.4 1.662*10^4 1.652*10^4 0 0])

subplot(2,1,1)
step(L)
subplot(2,1,2)
impulse(L)

%%
clc

Gs=tf([5.237 0],[1 1 104.7 104.7 0])

subplot(2,1,1)
step(Gs)
subplot(2,1,2)
% impulse(Gs)
bode(Gs)