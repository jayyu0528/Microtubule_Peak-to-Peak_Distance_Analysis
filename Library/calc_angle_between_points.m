function [angle_deg, angle_rad] = calc_angle_between_points(x1,y1,x2,y2)

angle_rad = atan( (y2-y1) / (x2-x1) ); % value in radian

if (x2-x1) < 0
    angle_rad = angle_rad + pi;
end

angle_deg = angle_rad ./ pi .* 180;