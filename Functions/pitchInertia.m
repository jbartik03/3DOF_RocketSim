function inertia = pitchInertia(m_dry, R, Lt, mf, xAft, CGrocket)
% Body
Iy_body = (1/12)*m_dry*(3*R^2 + Lt^2); 
% Fuel cell
Iy_fuel = mf.*(xAft - CGrocket).^2;
% Total
inertia = Iy_body + Iy_fuel;
end