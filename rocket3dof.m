%{
Jonathan Alexander Bartik
March 14th, 2026
My 3DOF Rocket Simulator System

As good as RASAeroII - a coupled mathematical model for 3DOF rocket
trajectory and stability, proven as the minimal way to describe flight with
accurate stability results. 
%}
function dx = rocket3dof(t,x, thrustTime, thrustForce, rotation)

%% STATE VARIABLES
altitude       = x(1);
vert_velocity  = x(2);
horiz_velocity = x(4);
pitch_attitude = x(5);
pitching_rate  = x(6);
fuel_mass      = x(7);

%% Parameters
% Body Measurements
D = 0.44;         % Diameter in meters
R = D/2;          % Radius in meters
S = pi*((D/2)^2); % Reference area in meters squared
Lnose = 1.32;     % Nose length in meters squared
Lt = 8.89;        % Total length of rocket in meters

% Fin Measurements
finPos = 7.3254;  % Start of fin chord, measured aft of nose in meters
cr = 1.057;       % root chord in meters
ct = 0.49;        % tip chord in meters
s  = 0.41;        % fin span in meters
Nf = 4;           % number of fins, unitless

% Mass Parameters
m_dry = 586;      % Dry rocket mass in kg
m_f0 = 1008.34;   % Starting fuel mass in kg
Isp = 200;        % Specific impulse of BBVC motor in seconds
dryCG = 4.072;    % Dry center of gravity, measured aft of nose in meters
xAft = 5.144;     % Rear position of fuel cell in meters (from nose)
xFwd = 6.344;     % Front position of fuel cell in meters (from nose)

%% FORMULAS
% Independent
g = gravity(altitude);                                % Gravity
T = interp1(thrustTime, thrustForce, t, 'linear', 0); % Thrust interpolant
m = m_dry + fuel_mass;                                % Mass
a = sonic(altitude, 75);                              % Speed of sound
v = sqrt(horiz_velocity^2 + vert_velocity^2);         % Velocity
v_safe = max(v,1e-3);                                 % Prevent divide by 0
mach = abs(v)/a;                                      % Mach number

% Angles
base_wind = -0.06 + rotation;
rel_horiz_velocity = horiz_velocity + (base_wind/100);
base_lift = -0.55 * (rotation);
rel_vert_velocity = vert_velocity + (base_lift/2.5);
if v > 20
    gamma = atan2(rel_vert_velocity, rel_horiz_velocity);
else
    gamma = pitch_attitude;
end
alpha = wrapToPi(pitch_attitude-gamma);       % Angle of attack

% Geometry
CenterP = xCP(Lnose, finPos, mach, cr, ct, s, D, Nf);     % CP in meters
CenterG = xCG(m_dry, fuel_mass, m_f0, dryCG, xFwd, xAft); % CG in meters
ell = CenterP - CenterG;                   % Reference length
StabilityMargin = (CenterP - CenterG) / D;    % Static Margin
cnalpha = CNalpha(mach, cr, ct, s, D, Nf); % Normal Force Derivative
cmalpha = -0.7 * StabilityMargin * cnalpha;         % Stability Derivative
cmq = -1.5 * StabilityMargin * cnalpha;         % Damping Derivative
v_damp = max(v_safe, 5);                  % Prevent divide by 0
Cm = cmalpha * alpha + cmq * ( ...
    pitching_rate * ell / (2*v_damp));     % Pitching moment coefficient

% Drag
rho = airDensity(altitude);
dragCoefficient = DragCoefficient(mach,rho,v,D,Lnose,Lt,S,alpha,vert_velocity);
qbar = 0.5 * rho * v_safe^2;                           % Dynamic Pressure
DragForce = qbar * dragCoefficient * S;                % Drag Force
Iy = pitchInertia(m_dry, R, Lt, fuel_mass, xAft, CenterG); % Pitch Inertia

% Velocity component weights (accounting for launch)
if abs(horiz_velocity) < 1e-6  % Launch condition
    uy = 0;
    ux = sign(vert_velocity);
else                           % Flight condition
    uy = horiz_velocity / v;
    ux = vert_velocity  / v;
end
horiz_force = DragForce * -uy; % Horizontal Drag Force Component
vert_force  = DragForce * -ux; % Vertical Drag Force Component

% Torque consideration due to gravity
pitch_turn = 0;
if rotation <= 12
    val = (0.000706667*(rotation^3)) - ...
    (0.0186*(rotation^2)) + (0.117333*(rotation)) + 1;
else
    val = -0.025*rotation + 1.31333;
end
if altitude < 15000 && fuel_mass > 0 % Powered torquing condition
    pitch_turn = deg2rad(max(rotation-1, 0.002)) * (val - altitude/15000);
end

%% STATE EQUATIONS
% States
dx = zeros(7,1);
dx(1) = vert_velocity;                     % Vertical Velocity
dx(2) = (T*sin(pitch_attitude))/m - g...
    + vert_force/m;                        % Vertical Acceleration
dx(3) = horiz_velocity;                    % Horizontal Velocity
dx(4) = (T*cos(pitch_attitude))/m + ...    
    horiz_force/m;                         % Horizontal Acceleration
dx(5) = pitching_rate;                     % Pitching Rate
dx(6) = ((qbar * S * ell / Iy) * Cm)...    
    - pitch_turn;                          % Pitch Angular Acceleration
if fuel_mass <= 0
    dx(7) = 0;                             % Coasting (no fuel to burn)
else
    dx(7) = -T/(9.80665*Isp);              % Fuel burn rate
end

% Rail condition: freeze attitude for first 6m (20ft) of flight
if altitude < 6
    dx(5) = 0;
    dx(6) = 0;
end
end