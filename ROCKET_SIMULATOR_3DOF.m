%{
Jonathan A. Bartik
Last Updated 5-27-2026
3DOF Rocket Simulator

This rocket simulator reflects over 6 months of work - I couldn't have done
it without you, Dr. Rahman. Some notes:

1. 'flightAngles' (line 21) -> Enter as many different launch angles (in 
   deg, from vertical, >= 0) as you wish. The simulator will report the 
   runtime for each and the total runtime.
2. 'thrustData' (line 24) -> This is where the csv file for the thrust data
   is read. You can try "BBVCmore.csv" or "BBVCless.csv", both data I made
   up. "BBVC.csv" is the original sustainer data from NASA.
%}

clear
close all

%% Conditions
flightAngles = [0,1,2,3]; % CHANGE THESE! As many as you want! :)

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