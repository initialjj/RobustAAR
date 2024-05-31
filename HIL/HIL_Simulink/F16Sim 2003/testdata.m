% mass = 636.94*14.59428;    %kg
% Inertia=[9496,0,-982.0;0,55814.0,0;-982.0,0,63100.0]*1.35583; %kg.m^2
% 
% S_ref=300.0*0.3048^2;%Reference area (m)
% b_ref=30.0*0.3048;%Reference span (m)
% d_ref=11.32*0.3048;%Reference length or mean chord length (m)
% 
% x_cg=0.35*11.32;%Center of Gravity
% x_ref=0.30*11.32;%Center if Pressure
% 
% beta=0;
% pqr=[0,0,0];
% altitude=3000;
% airSpeed=120;
fi_flag=1;
mass = 636.94;    %kg
Inertia=[9496,0,-982.0;0,55814.0,0;-982.0,0,63100.0]; %kg.m^2
aaa=0.115609526503456;
S_ref=300.0;%Reference area (m)
b_ref=30.0;%Reference span (m)
d_ref=11.32;%Reference length or mean chord length (m)

x_cg=0.35*11.32;%Center of Gravity
x_ref=0.30*11.32;%Center if Pressure

beta=0;
pqr=[0,0,0];
altitude=9843;
airSpeed=393.720000000000;
trim_state=[0;0;9843;0;aaa;0;393.720000000000;0.115609526503456;0;0;0;0];
xme_0=[0,0,-trim_state(3)];%Initial position in inertial axes [Xe,Ye,Ze]:
Vmw=[airSpeed*cos(aaa),0,airSpeed*sin(aaa)];%Initial velocity in body axes [U,v,w]:
Euler_0=[0,aaa,0];%Initial Euler orientation [roll, pitch, yaw]:
pm_0=[0,0,0];%Initial body rotation rates [p,q,r]:
%alpha0=trim_state(8)*180/pi;%Initialize LF_state with -alpha0 value in degrees

altitude=trim_state(3);%(ft)
velocity=trim_state(7);%(ft/s)

alpha0=trim_state(8)*180/pi;
if (fi_flag == 1)
    % Calculating qbar, ps and steady state leading edge flap deflection:
    % (see pg. 43 NASA report)
    rho0 = 2.377e-3; tfac = 1 - 0.703e-5*altitude;
    temp = 519*tfac; 
    if (altitude >= 35000) 
        temp = 390; 
    end;
    rho = rho0*tfac^4.14;
    qbar = 0.5*rho*velocity^2;
    ps = 1715*rho*temp;
    
    dLEF = 1.38*alpha0 - 9.05*qbar/ps + 1.45;
    
elseif (fi_flag== 0)
    dLEF = 0.0;
end

% Verify that the calculated leading edge flap
% have not been violated.
if (dLEF > 25)
    dLEF = 25;
elseif (dLEF < 0)
    dLEF = 0;
end;

trim_thrust=2279.08519954656;
trim_ele=-2.97973164860638;
trim_ail=0.00874607850103852;
trim_rud=0.0680302158182712;
trim_control=[trim_thrust;trim_ele;trim_ail;trim_rud];
trim_state=[0;0;0;0;aaa;0;393.720000000000;0.115609526503456;0;0;0;0];
trim_state1=[trim_state;trim_control;0;0];

% Kp=[0	0	0	0	-9.646865162	0	0.261378724	-0.258820207	0	0	-5.345537529	0	0.000273926	0.021726033	0	0	0	0
% 0	0	0	0	-21.31023018	0	0.347608294	3.20634313	0	0	-12.94812208	0	0.000438866	0.05360637	0	0	0	0
% 0	0	0	-1.434909249	0	-1.369601197	0	0	-0.100164088	-0.743064144	0	-3.213700113	0	0	0.013108596	0.002455715	0	0
% 0	0	0	-0.295690905	0	-0.35240965	0	0	-0.227038694	-0.110802249	0	-1.225550863	0	0	0.002455715	0.001448419	0	0
% ];
% 
% Kp(:,7)=Kp(:,7)*1.5;





% linearized model : x_dot = A * x + B * u
%   
%   ----State Variables --------                          
%01      x = [ npos  ( ft )        - north position              
%02            epos  ( ft )        - east position    
%03            h     ( ft )        - height 
%04            phi   ( rad )       - Euler angle  (roll)   
%05            theta ( rad )       - Euler angle  (pitch)     
%06            psi   ( rad )       - Euler angle  (yaw)  
%07            Vt    ( ft/sec)     - total speed   
%08            alpha ( rad )       - angle of attack   
%09            beta  ( rad )       - sideslip angle 
%10            p     ( rad/sec )   - roll rate   
%11            q     ( rad/sec )   - pitch rate
%12            r     ( rad/sec )   - yaw rate              
%13            Thr   ( - )         - throttle actuator  
%14            Ele   ( - )         - elevon actuator    
%15            Ail   ( - )         - aileron actuator  
%16            Rud   ( - )         - rudder actuator  
%17            Q     ( ft )        - dynamic pressure  
%18            Ps    ( ft )        - static pressure   
%          ];            
%                                                         
%   ---- Control Variables --------                       
%      u = [ delta_t   ( lbs )     - throttle setting  1000~19000   
%            delta_e   ( deg )     - elevon deflection  +-30    
%            delta_a   ( deg )     - aileron deflection +-30    
%            delta_r   ( deg )     - rudder deflection  +-30
%           ];   


A=[0	0	0	0	-2.55E-09	0	1	0	0	0	0	0	0	0	0	0	0	0
0	0	0	-45.41645538	0	393.72	0	0	393.72	0	0	0	0	0	0	0	0	0
0	0	0	0	393.72	0	0	-393.72	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	1	0	0.116127357	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	1.006720201	0	0	0	0	0	0
0	0	0.000111135	0	-32.17	0	-0.018054928	-8.065022573	-0.513279483	0	-1.846855155	0	0.001559526	0.000437475	0	0	0.04140394	0
0	0	2.52E-06	0	3.76E-15	0	-0.000409721	-0.667371723	0.002506663	0	0.927561102	0	-4.60E-07	-0.001426346	0	0	0.000310857	0
0	0	2.97E-08	0.081162385	0	0	-2.41E-06	-0.001504132	-0.172588697	0.116271401	0	-0.987379385	0	0	0.000195154	0.000491154	-8.31E-06	0
0	0	-1.46E-12	0	0	0	2.37E-10	1.466101862	-17.70621848	-2.011595253	0	0.673466992	0	-0.000591216	-0.304265853	0.05827256	-0.00373523	0
0	0	7.98E-12	0	0	0	-1.30E-09	-0.742601	0.023953046	0	-0.850870526	0	0	-0.086580984	0	0	-0.012064992	0
0	0	4.94E-10	0	0	0	-8.03E-08	-0.014838266	3.542187625	-0.051673814	0	-0.286518102	0	0.001061005	-0.012608703	-0.029299811	0.000276073	0
0	0	0	0	0	0	0	0	0	0	0	0	-1	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	-20.2	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	-20.2	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	-20.2	0	0
0	0	-4.70E-05	0	0	0	-0.031623327	1162.76729	0	0	0	0	0	0	0	0	-7.352941176	10.14705882
0	0	0	0	0	0	0	-415.3944015	0	0	0	0	0	0	0	0	0	-7.25
];

B=[0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
0	0	0	0
1	0	0	0
0	20.2	0	0
0	0	20.2	0
0	0	0	20.2
0	0	0	0
0	0	0	0
];

%%%���һ��Ϊxd,h,yd
C=[1,zeros(1,17);
    0,0,1,zeros(1,15);
    0,1,zeros(1,16)];

%%% change throttle input delta_t's range to 1~19
%%% to make sure four inputs have the same orders of magntiude
B(:,1)=B(:,1)*1000;



%%-------------------Longitudinal equation-------------------------------%%

% linearized model : x_lon_dot = A_lon * x_lon + B_lon * u_lon
%   
%   ----State Variables --------  
%   01.npos , 02.h , 03.theta , 04.Vt , 05.alpha , 06.q , 07.Thr , 08.Ele
%                                                         
%   ---- Control Variables --------  
%   delta_t delta_e
%
%   ---- Output --------  
%   C_lo_xd_h  -  npos , h
%

A_lon=A([1,3,5,7,8,11,13,14],[1,3,5,7,8,11,13,14]);
B_lon=B([1,3,5,7,8,11,13,14],1:2);
C_lon_xd_h=[1 zeros(1,7);
    0 1 zeros(1,6)];

%����ϵͳ���󣬼���h��xd����������
AA_lon=[A_lon,zeros(8,2);-C_lon_xd_h,zeros(2,2)];
BB_lon=[B_lon;zeros(2,2)];
Q_lon=diag([4 2 10 0 10 10 0 0 1 1]);

%%%RԽ����Ӧ��������ԽС������Խ������Ӧʱ��Խ��
R_lon=diag([50 50]);
[k_lon,p_lon,e_lon]=lqr(AA_lon,BB_lon,Q_lon,R_lon);

Kp_lon=k_lon(:,1:8);
Ki_lon=-k_lon(:,9:10);


%%-------------------lateral equation-------------------------------%%

% linearized model : x_la_dot = A_la * x_la + B_la * u_la
%   
%   ----State Variables --------  
%   01.epos , 02.phi , 03.psi , 04.beta , 05.p , 06.r , 07.Ail , 08.Rud 
%                                                         
%   ---- Control Variables --------  
%   delta_a delta_r
%
%   ---- Output --------  
%   C_la_yd  -  epos
%

A_la=A([2,4,6,9,10,12,15,16],[2,4,6,9,10,12,15,16]);
B_la=B([2,4,6,9,10,12,15,16],3:4);
C_la_yd=[1 zeros(1,7)];

%����ϵͳ���󣬼���h��xd����������
AA_la=[A_la,zeros(8,1);-C_la_yd,zeros(1,1)];
BB_la=[B_la;zeros(1,2)];
Q_la=diag([10 2 4 4 2 2 0 0 4]);

%%%RԽ����Ӧ��������ԽС������Խ������Ӧʱ��Խ��
R_la=diag([500 500]);
[k_la,p_la,e_la]=lqr(AA_la,BB_la,Q_la,R_la);

eig(AA_la-BB_la*k_la)

Kp_la=k_la(:,1:8);
Ki_la=-k_la(:,9);


%%-------------------total equation-------------------------------%%
Kp=zeros(4,18);
Kp(1:2,[1,3,5,7,8,11,13,14])=Kp_lon;
Kp(3:4,[2,4,6,9,10,12,15,16])=Kp_la;

Kp(:,13)=zeros(4,1);

Ki=zeros(4,3);
Ki(1:2,1:2)=Ki_lon;
Ki(3:4,3)=Ki_la;