% =========================================================================
% 3DOF Rocket Flight Dynamics Simulator
%
% Author: Jonathan A. Bartik
% Created: February 2026
%
% Copyright (c) 2026 Jonathan A. Bartik
% All Rights Reserved
% =========================================================================

function plot3DOFresults(results, i, timespan)
%{
    This is the plotting function. When called, it produces the plots from
    the massive databank 'results' produced by ROCKET_SIMULATOR_3DOF.m.
%}

colors = {
    [0.0000, 0.4470, 0.7410]  % blue
    [0.8500, 0.3250, 0.0980]  % orange
    [0.4660, 0.6740, 0.1880]  % green
    [0.4940, 0.1840, 0.5560]  % purple
    [0.9290, 0.6940, 0.1250]  % yellow
    [0.3010, 0.7450, 0.9330]  % cyan
    [0.6350, 0.0780, 0.1840]  % dark red
    [0.2500, 0.2500, 0.2500]  % dark gray
    [0.7500, 0.2500, 0.2500]  % maroon
    [0.2500, 0.7500, 0.2500]  % bright green
    [0.2500, 0.2500, 0.7500]  % strong blue
    [0.7500, 0.7500, 0.2500]  % olive
    [0.7500, 0.2500, 0.7500]  % magenta
};

legendEntries = strings(1, i);

% Altitude vs Distance with flight angles
figure; 
hold on;
dist_lim = 0;
for k = 1:i
    [maxAlt, idx] = max(results(k).altitude);
    apogee = (maxAlt / 1000);
    maxDist = max(results(k).distance);
    range = (maxDist / 1000);
    if range > dist_lim
        dist_lim = range;
    end
    plot(results(k).distance/1000, results(k).altitude/1000, ...
        'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5);
    plot(results(k).distance(idx)/1000, results(k).altitude(idx)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(results(k).angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm Apogee | %.2fkm Dist.', ...
                               results(k).angle, apogee, range);
    else
        legendEntries(k) = sprintf('%.2f°: %.2fkm Apogee | %.2fkm Dist.', ...
                               results(k).angle, apogee, range);
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize', 28);
xlabel("Distance (km)",'FontSize', 30)
ylabel("Altitude (km)",'FontSize', 30)
xlim([0 dist_lim*1.05])
legend(legendEntries, 'FontSize', 20, 'Location', 'best')
grid on

% Altitudes vs time with flight angles
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    altitude = results(k).altitude;
    time = results(k).time;

    [maxAlt, idx] = max(altitude);
    apogee_km = maxAlt / 1000;
    plot(time, altitude/1000, ...
        'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5);
    plot(time(idx), altitude(idx)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm apogee at %.2fs', ...
                               angle, apogee_km, time(idx));
    else
        legendEntries(k) = sprintf('%.2f°: %.2fkm apogee at %.2fs', ...
                               angle, apogee_km, time(idx));
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
xlabel("Time (s)","FontSize",30)
xlim(timespan)
ylabel("Altitude (km)","FontSize",30)
legend(legendEntries, 'FontSize', 20, 'Location', 'best')
grid on


% Distance vs Time
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    distance = results(k).distance;
    time = results(k).time;
    [maxDist, idxDist] = max(distance);
    range_km = maxDist / 1000;
    plot(time, distance/1000, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(time(idxDist), distance(idxDist)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm range over %.1fs', ...
                               angle, range_km, time(idxDist));
    else
        legendEntries(k) = sprintf('%.2f°: %.2fkm range over %.1fs', ...
                               angle, range_km, time(idxDist));
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
xlabel("Time (s)","FontSize",30)
xlim(timespan)
ylabel("Distance (km)","FontSize",30)
legend(legendEntries, 'FontSize', 20, 'Location', 'best')
grid on

% Angle of Attack
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    alpha = results(k).alpha;
    time = results(k).time;
    plot(time, alpha, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf("%d°",angle);
    else
        legendEntries(k) = sprintf('%.2f°', angle);
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
xlabel("Time (s)")
ylabel("Angle of attack (rad)")
legend(legendEntries, 'FontSize', 20, 'Location', 'best')
grid on

% Flight Path Angle
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    gamma = results(k).gamma;
    time = results(k).time;
    plot(time, gamma, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf("%d°",angle);
    else
        legendEntries(k) = sprintf("%.2f°",angle);
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
xlabel("Time (s)","FontSize",30)
xlim(timespan)
ylabel("Flight path angle (rad)","FontSize",30)
legend(legendEntries, 'FontSize', 20, 'Location', 'best')
grid on

% Velocity vs time
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    velocity = sqrt(results(k).vert_velocity.^2 + results(k).horiz_velocity.^2);
    time = results(k).time;
    [~, idxApogee] = max(results(k).altitude);
    [maxAscentVel, iAscent] = max(velocity(1:idxApogee));
    tAscent = time(iAscent);
    [maxDescentVel, iDescRel] = max(velocity(idxApogee:end));
    iDescent = iDescRel + idxApogee - 1;
    tDescent = time(iDescent);
    plot(time, velocity, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(tAscent, maxAscentVel, 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
        , colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
    plot(tDescent, maxDescentVel, 's', 'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    else
        legendEntries(k) = sprintf('%.2f°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    end
end
hold off;
xlabel("Time (s)","FontSize",30)
ylabel("Velocity (m/s)","FontSize",30)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
legend(legendEntries, 'Location', 'best', 'FontSize', 20)
grid on

% Vertical Velocity vs Time
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    vert_velocity = results(k).vert_velocity;
    time = results(k).time;
    [maxV, a] = max(vert_velocity);
    [minV, b] = min(vert_velocity);
    plot(time, vert_velocity, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(time(a), maxV, 'o', 'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    plot(time(b), minV, 's', 'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxV, abs(minV));
    else
        legendEntries(k) = sprintf('%.2f°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxV, abs(minV));
    end
end
hold off;
xlabel("Time (s)","FontSize",30)
xlim(timespan)
ylabel("Vertical Velocity (m/s)","FontSize",30)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
legend(legendEntries, 'Location', 'best', 'FontSize', 20)
grid on

% Horizontal Veloicty vs Time
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    horiz_velocity = results(k).horiz_velocity;
    time = results(k).time;
    plot(time, horiz_velocity, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf("%d°",angle);
    else
        legendEntries(k) = sprintf("%.2f°",angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",30)
xlim(timespan)
ylabel("Horizontal Velocity (m/s)","FontSize",30)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
legend(legendEntries, 'Location', 'best', 'FontSize', 20)
grid on

% Fuel mass (same for all angles)
figure; 
hold on;
fuelMass = results(1).fuel_mass;
time = results(1).time;
[minMf, j] = min(fuelMass);
plot(time, fuelMass, 'color', colors{3}, 'LineWidth', 5)
plot(time(j), minMf, 'o', ...
    'MarkerSize', 15, ...
    'MarkerFaceColor', colors{3}, ...
    'MarkerEdgeColor', 'k', ...
    'HandleVisibility', 'off');
legend("Burnout at " + time(j) + "s", 'FontSize', 20);
hold off;
xlabel("Time (s)","FontSize",30)
ylabel("Fuel Mass (kg)","FontSize",30)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
grid on
xlim(timespan)
ylim([-1 1010])

% Pitch Attitude vs time
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    pitch = results(k).pitch_attitude;
    time = results(k).time;
    plot(time, wrapToPi(pitch),'color',colors{mod(k-1,13) + 1},'LineWidth',5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf("%d°", angle);
    else
        legendEntries(k) = sprintf("%.2f°", angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",30)
ylabel("Pitch Attitude (rad)","FontSize",30)
ylim([-pi pi])
yticks([-pi -pi/2 0 pi/2 pi])
yticklabels(["-\pi" "-\pi/2" "0" "\pi/2" "\pi"])
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
legend(legendEntries, 'Location', 'best','FontSize', 20)
grid on

% Pitching Rate vs time
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    pitchRate = results(k).pitch_rate;
    time = results(k).time;
    plot(time, pitchRate,'color',colors{mod(k-1,13) + 1},'LineWidth',3.5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf("%d°", angle);
    else
        legendEntries(k) = sprintf("%.2f°", angle);
    end
end
hold off;
xlabel("Time (s)")
ylabel("Pitching rate (rad/s)")
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',28);
legend(legendEntries, 'Location', 'best','FontSize', 20)
grid on
end