%% modele 1/4 voiture
% Author: Mohamed Amine Borni
%
%%
clear ; close all ; clc
%% Parametres
% Voiture
Ms   = 1120;                         % Masse suspendue                          [kg]
Mu   = 45;                          % Masse non suspendue                       [kg]
Ks  = 20000;                        % raideur du ressort de suspension          [N/m]
Kt  = 150000;                       % raideur du pneu                           [N/m]
Cs  = 1000;                        % coe?cient de frottement de l’amortisseur   [N.s/m]
Ct  = 0;                           % coe?cient d’amortissement du pneu
% Animation modele
L0_s    = 0.8;                      % Suspension détendue à ressort             [m]
L0_u    = 0.6;                      % Pneu détendu à ressort                    [m]
h_s     = 0.4;                      % Hauteur du bloc suspendu                  [m]
h_u     = 0.2;                      % Hauteur du bloc non suspendu              [m]
a       = 0.8;                      % Largeur des blocs                         [m]
l_win   = 2.2;                      % Analyse de la fenêtre de longueur         [m]
% Video
playback_speed = 0.2;               % Vitesse de lecture
tF      = 2;                        % Dernier temps                             [s]
fR      = 30/playback_speed;        % Fréquence d'images                        [fps]
dt      = 1/fR;                     % Résolution temporelle                     [s]
time    = linspace(0,tF,tF*fR);     % Temps                                     [s]
%% Route
x_r_1_total = 1.1;                  % Distance du premier obstacle  [m]
dx_r_1 = 0.1;                       % resolution                    [m]
x_r_1 = 0:dx_r_1:x_r_1_total;
z_r_1 = zeros(1,length(x_r_1));
R_r = 0.15;                         % Rayon                         [m]
th_r = 0:0.01:pi;
x_r_2 = -R_r*cos(th_r) + x_r_1_total+R_r;
z_r_2 = R_r*sin(th_r);
x_r_3_total = 5;                    % Distance of the last stretch  [m]
dx_r_2 = 0.1;                       % resolution                    [m]
x_r_3 = x_r_1_total+2*R_r:dx_r_2:x_r_1_total+2*R_r+x_r_3_total;
z_r_3 = zeros(1,length(x_r_3));
% concaténation 
X_r = [x_r_1 x_r_2(2:end) x_r_3(2:end)];
Z_r = [z_r_1 z_r_2(2:end) z_r_3(2:end)];

%% Simulation
%  State space model
A = [ 0               1         0        -1            ;
      -Ks/Ms           -Cs/Ms     0        Cs/Ms          ;
      0               0         0        1             ;
      Ks/Mu            Cs/Mu      -Kt/Mu    -(Cs/Mu+Ct/Mu)  ];
B = [ 0     ;
      1/Ms   ;
      0     ;
      -1/Mu  ];
C = [ 1 0 0 0 ; 
      0 0 1 0 ];
D = [0 ; 0];
sys = ss(A,B,C,D);

% Donnee
vel = 2;                            % Vitesse longitudinale de la voiture [m/s]
lon_pos = vel*time;                 % Position longitudinale de la voiture [m]
u_vet = interp1(X_r,Z_r,lon_pos)';
[y,time,x] = lsim(sys,u_vet,time);
% Position verticale absolue de la masse suspendue
z_s = y(:,2) + L0_u + L0_s; 
% Position verticale absolue de la masse non suspendue 
z_u = y(:,1) + L0_u; 

%% Animation
color = cool(7); % Colormap
figure
set(gcf,'Position',[50 50 640 640])     % Social
v = VideoWriter('quarter_car_model.mp4','MPEG-4');
v.Quality   = 100;
open(v);
for i=1:length(time)
    cla
    % Position instantanée
    x_inst = vel*time(i);
    % Route passant
    set(gca,'xlim',[x_inst-l_win/2    x_inst+l_win/2],'ylim',[-0.1 -0.1+l_win])
    hold on ; grid on ; box on 
    plot([-10 X_r],[0 Z_r],'k','LineWidth',3)
    
    set(gca,'FontName','Verdana','FontSize',16)
    title(["Suspension voiture",strcat('Temps=',num2str(time(i),'%.3f'),' s (vitesse d animation=',num2str(playback_speed),')')])
    
    % masse suspendue
    fill([x_inst-a/2 x_inst+a/2 x_inst+a/2 x_inst-a/2],[z_s(i) z_s(i) z_s(i)+h_s z_s(i)+h_s],color(4,:),'LineWidth',2)
    
    % masse non suspendu
    fill([x_inst-a/2 x_inst+a/2 x_inst+a/2 x_inst-a/2],[z_u(i) z_u(i) z_u(i)+h_u z_u(i)+h_u],color(1,:),'LineWidth',2)
    
    % Ressort
    plotSpring(L0_u,L0_s,h_u,u_vet,z_s,z_u,i,x_inst)
    
    % Amortisseur
    plotDamper(L0_s,h_u,z_s,z_u,i,x_inst)
   
    % Pneu
    plot(x_inst,u_vet(i),'ko','MarkerFacecolor','k','MarkerSize',20)
    
    xlabel('x [m]')
    ylabel('z [m]')
    
    frame = getframe(gcf);
    
end
close(v);
function plotSpring(L0_u,L0_s,h_u,u_vet,z_s,z_u,i,x_inst)
    rodPct      = 0.11;     % Length rod percentage of total L0 
    springPct   = 1/3;      % Spring pitch percentage of total gap
    spring_wid  = 3;        % Spring line width
    
    % Spring 1 and 2 length without rods
    L_s = (z_s - (z_u+h_u)) - 2*rodPct*L0_s;
    L_u = (z_u - u_vet)     - 2*rodPct*L0_u;
    
    % Spring sprung suspension geometry
    c_s = x_inst-0.2;       % Longitudinal position
    w_s = 0.1;              % Width
    
    % Spring unsprung tire geometry 
    c_u = x_inst;           % Longitudinal position
    w_u = 0.1;              % Width
    % Spring unsprung tire 
    spring_u_X = [ 
                c_u                                             % Start
                c_u                                             % rod
                c_u+w_u                                         % Part 1   
                c_u-w_u                                         % Part 2
                c_u+w_u                                         % Part 3
                c_u-w_u                                         % Part 4
                c_u+w_u                                         % Part 5
                c_u-w_u                                         % Part 6
                c_u                                             % Part 7
                c_u                                             % rod/End
                ];
    
	spring_u_Z = [ 
                u_vet(i)                                        % Start
                u_vet(i)+  rodPct*L0_u                          % rod
                u_vet(i)+  rodPct*L0_u                          % Part 1 
                u_vet(i)+  rodPct*L0_u+  springPct*L_u(i)       % Part 2
                u_vet(i)+  rodPct*L0_u+  springPct*L_u(i)       % Part 3
                u_vet(i)+  rodPct*L0_u+2*springPct*L_u(i)       % Part 4
                u_vet(i)+  rodPct*L0_u+2*springPct*L_u(i)       % Part 5
                u_vet(i)+  rodPct*L0_u+3*springPct*L_u(i)       % Part 6
                u_vet(i)+  rodPct*L0_u+3*springPct*L_u(i)       % Part 7
                u_vet(i)+2*rodPct*L0_u+3*springPct*L_u(i)       % rod/End
               ]; 
           
    % Spring sprung suspension
    spring_s_X = [ 
                c_s                                             % Start
                c_s                                             % rod
                c_s+w_s                                         % Part 1   
                c_s-w_s                                         % Part 2
                c_s+w_s                                         % Part 3
                c_s-w_s                                         % Part 4
                c_s+w_s                                         % Part 5
                c_s-w_s                                         % Part 6
                c_s                                             % Part 7
                c_s                                             % rod/End
                ];
    
	spring_s_Z = [ 
                z_u(i)+h_u                                      % Start
                z_u(i)+h_u +   rodPct*L0_s                      % rod
                z_u(i)+h_u +   rodPct*L0_s                      % Part 1 
                z_u(i)+h_u +   rodPct*L0_s +   springPct*L_s(i) % Part 2
                z_u(i)+h_u +   rodPct*L0_s +   springPct*L_s(i) % Part 3
                z_u(i)+h_u +   rodPct*L0_s + 2*springPct*L_s(i) % Part 4
                z_u(i)+h_u +   rodPct*L0_s + 2*springPct*L_s(i) % Part 5
                z_u(i)+h_u +   rodPct*L0_s + 3*springPct*L_s(i) % Part 6
                z_u(i)+h_u +   rodPct*L0_s + 3*springPct*L_s(i) % Part 7
                z_u(i)+h_u + 2*rodPct*L0_s + 3*springPct*L_s(i) % rod/End
               ];
    % PLOT
    plot(spring_u_X,spring_u_Z,'k','LineWidth',spring_wid)
    plot(spring_s_X,spring_s_Z,'k','LineWidth',spring_wid)
        
end
function plotDamper(L0_2,h1,z_s,z_u,i,x_inst)
 
    rodLowerPct = 0.1;      % Length lower rod percentage of total gap 
    rodUpperPct = 0.4;      % Length upper rod percentage of total gap
    cylinderPct = 0.4;      % Length cylinder porcentagem of total gap
    damper_line_wid  = 3;   % Damper line width
    
    % Damper geometry
    c = 0.2+x_inst;         % Longitudinal position
    w= 0.05;                % Width
    % rod attached to unsprung mass
    rod_1_X = [c c];
    rod_1_Z = [z_u+h1 z_u+h1+rodLowerPct*L0_2];
    
    % Damper base cylinder - rod - base 
    c_X =   [   
                c-w
                c-w
                c+w
                c+w
            ];
    c_Z =   [
                z_u(i) + h1 + rodLowerPct*L0_2 + cylinderPct*L0_2
                z_u(i) + h1 + rodLowerPct*L0_2 
                z_u(i) + h1 + rodLowerPct*L0_2 
                z_u(i) + h1 + rodLowerPct*L0_2 + cylinderPct*L0_2
            ];
    
    % rod attached to sprung mass
    rod2X = [c c];
    rod2Z = [z_s z_s-rodUpperPct*L0_2];
    % Piston inside cylinder
    pistonX = [c-0.8*w c+0.8*w];
    pistonZ = [z_s-rodUpperPct*L0_2 z_s-rodUpperPct*L0_2];
    
    % Iteration values
    rod1Zval = rod_1_Z(i,:);
    rod2Zval = rod2Z(i,:);
    pistonZVal = pistonZ(i,:);
    % PLOT
    % rods
    plot(rod_1_X,rod1Zval,'k','LineWidth',damper_line_wid)
    plot(rod2X,rod2Zval,'k','LineWidth',damper_line_wid)
    % Damper parts
    plot(pistonX,pistonZVal,'k','LineWidth',damper_line_wid)
    plot(c_X,c_Z,'k','LineWidth',damper_line_wid)
end