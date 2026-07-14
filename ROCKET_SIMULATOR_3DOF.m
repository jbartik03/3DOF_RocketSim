% =========================================================================
% 3DOF Rocket Flight Dynamics Simulator
%
% Author: Jonathan A. Bartik
% Created: February 2026
%
% Copyright (c) 2026 Jonathan A. Bartik
% All Rights Reserved
% =========================================================================

clear
close all

%% Conditions
flightAngles = [0,1,2,3,4,5,6,7,8,9,10]; % Adjust launch angles here
% Thrust Data from CSV file
thrustData = readtable("BBVC.csv");
thrustTime = thrustData.time;
thrustForce = thrustData.thrust;

% Initial conditions
timespan = [0 440];
options = odeset('Events', @groundEvent);   
timerTotal = 0;

% Integration
for k = 1:length(flightAngles)
    angle = flightAngles(k);
    initial_pitch = pi/2 - deg2rad(angle);
    v0 = 1;
    x0 = [0, v0*sin(initial_pitch), 0, ...
          v0*cos(initial_pitch), initial_pitch, 0, 1008.34];
    tic
    [t,x] = ode45(@(t,x) rocket3dof(t,x,thrustTime, thrustForce, angle), ...
                  timespan, x0, options);
    endTimer = toc;
    timerTotal = timerTotal + endTimer;
    disp("Sim " + k + " took " + endTimer + " seconds.");
    results(k).angle = angle;
    results(k).time  = t;
    results(k).altitude   = x(:,1);
    results(k).vert_velocity = x(:,2);
    results(k).distance  = x(:,3);
    results(k).horiz_velocity = x(:,4);
    results(k).pitch_attitude = x(:,5);
    results(k).pitch_rate = x(:,6);
    results(k).fuel_mass = x(:,7);
    results(k).gamma = atan2(results(k).vert_velocity, results(k).horiz_velocity);
    results(k).alpha = results(k).pitch_attitude - results(k).gamma;
end
disp("Total runtime: " + timerTotal + " seconds.");

% Plots
plot3DOFresults(results,k,timespan);