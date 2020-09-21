function fn_3D_image_plot_new (PROBE,num_el)
%% fn_3d_image_plot_new
%
% This function is entirely dedicated towards plotting the 3d wedge viewer,
% the data used did not contain a squint angle however a seperate section
% dedicated to having a squint angle can be found in this code as well.
%
% This code makes use of the Probe MFMC group and all datasets contained
% within, this code also requires the two wedge based datasets in order for
% the wedge to be plotted
%
% A user interface allowing the user to choose between a full 3d plot
% (including the wedge) or a plot of simply plot the elements is hence found
%
% The 3D wedge plot is set to equal axis as a default, if bothersome the
% equal axis may be commented out [indicated in the code]
%
%
%
%% Set up initial menu to choose what plot is required
grid on
axis([-0.035 0.035 -0.01 0.01 0 0.1])
%axis([-0.035 0.035 -0.035 0.035 0 0.1])
hold on,
choose = questdlg('Would you like the  full 3d plot including the wedge or only the elements to be plotted?',...
'Menu',... 
'Wedge 3D-Plot', 'Elements-plot', 'dnf');



%% points defining wedge surface (PCS Y coordinate for surface point = 0 [NO SQUINT])
if strcmp(choose,'Wedge 3D-Plot')
if PROBE.WEDGE_SURFACE_POINT(2) == 0
%finding angle of incidence in terms of x axis
angle_incidence = atan (PROBE.WEDGE_SURFACE_NORMAL(1)/PROBE.WEDGE_SURFACE_NORMAL(3));

%For vertical height from wedge base to surface point
height_vert = cos(angle_incidence) * PROBE.WEDGE_SURFACE_POINT(3);

%so as gradient m=tan(theta)
m = tan(-angle_incidence);

%Point of intersection of wedge coordinate (x)
%using pythagorous
x_wedge_point = height_vert * tan(-angle_incidence);

%Prepandicular line (vertical HEIGHT line)
A=[0,0,0];
B=[0,0,height_vert];
X = [A(1), B(1)];
Y = [A(2), B(2)];
Z = [A(3),B(3)];
line(X,Y,Z);

%LINE TO INTERSECTION POINT (PREPANDICULAR TO PROBE)
A=[0,0,height_vert];
B=[x_wedge_point,0,0];
X = [A(1), B(1)];
Y = [A(2), B(2)];
Z = [A(3),B(3)];
line(X,Y,Z);

%These dimensions represent the wedge surface, are adjustable and are purely to improve the display of
%the elements
%Simply adjust the coordinates as deemend neceassary or comment out if unneeded
p1 = [-0.02 -0.006 height_vert];
p2 = [-0.02 0.006 height_vert];
p3 = [0.02 0.006 height_vert];
p4 = [0.02 -0.006 height_vert];
X = [p1(1) p2(1) p3(1) p4(1)];
Y = [p1(2) p2(2) p3(2) p4(2)];
%Using z = mx + c to plot the varying z coordinates for the four points
Z = [(m*(p1(1)) + height_vert) (m*(p2(1)) + height_vert) (m*(p3(1)) + height_vert) (m*(p4(1)) + height_vert)];
patch(X, Y, Z, 'c');


end


%% points defining wedge surface (PCS Y coordinate for surface point ~= 0 [SQUINT])
if PROBE.WEDGE_SURFACE_POINT(2) ~= 0;
%finding angle of incidence in terms of x axis
angle_incidence = atan (PROBE.WEDGE_SURFACE_NORMAL(1)/PROBE.WEDGE_SURFACE_NORMAL(3));

%Squint angle
angle_squint = atan (PROBE.WEDGE_SURFACE_NORMAL(2)/PROBE.WEDGE_SURFACE_NORMAL(3))

%For vertical height from wedge base to surface point
height_vert = cos(angle_incidence) * PROBE.WEDGE_SURFACE_POINT(3); 

%so as gradient m=tan(theta)
m_ia = tan(-angle_incidence);
m_sa = tan (angle_squint)

%Point of intersection of wedge coordinates (x) and (y)
%using pythagorous
x_wedge_point = height_vert * tan(-angle_incidence);
y_wedge_point = height_vert * tan(angle_squint);

%Prepandicular line (vertical HEIGHT line)
A=[0,0,0];
B=[0,0,height_vert];
X = [A(1), B(1)];
Y = [A(2), B(2)];
Z = [A(3),B(3)];
line(X,Y,Z);

%LINE TO INTERSECTION POINT (PREPANDICULAR TO PROBE)
A=[0,0,height_vert];
B=[x_wedge_point,y_wedge_point,0];
X = [A(1), B(1)];
Y = [A(2), B(2)];
Z = [A(3),B(3)];
line(X,Y,Z);


%These dimensions represent the wedge surface, are adjustable and are purely to improve the display of
%the elements
%Simply adjust the coordinates as deemend neceassary or comment out if unneeded
p1 = [-0.02 -0.006 height_vert];
p2 = [-0.02 0.006 height_vert];
p3 = [0.02 0.006 height_vert];
p4 = [0.02 -0.006 height_vert];
X = [p1(1) p2(1) p3(1) p4(1)];
Y = [p1(2) p2(2) p3(2) p4(2)];

%Using z = mx + c to plot the varying z coordinates for the four points
Z = [(m_ia*(p1(1)) + height_vert) (m_ia*(p2(1)) + height_vert) (m_ia*(p3(1)) + height_vert) (m_ia*(p4(1)) + height_vert)];

%Using z = mz(n) + c to plot the varying z coordinates for the four points
%along the y axis
Z = [(m_sa *Z(1) + height_vert) (m_sa *Z(2) + height_vert) (m_sa * Z(3) + height_vert) (m_sa*Z(4) + height_vert)];
patch(X, Y, Z, 'c');


end
    
%% For each element
for el = 1:num_el
    
    % location of centre of each element:
    x = PROBE.ELEMENT_POSITION(1,el);
    y = PROBE.ELEMENT_POSITION(2,el);
    z = PROBE.ELEMENT_POSITION(3,el);
    
    % 4 points that define the size of each element

    p1 = [x-PROBE.ELEMENT_MINOR(1,1) y-PROBE.ELEMENT_MAJOR(2,1) height_vert];
    p2 = [x+PROBE.ELEMENT_MINOR(1,1) y-PROBE.ELEMENT_MAJOR(2,1) height_vert];
    p3 = [x+PROBE.ELEMENT_MINOR(1,1) y+PROBE.ELEMENT_MAJOR(2,1) height_vert];
    p4 = [x-PROBE.ELEMENT_MINOR(1,1) y+PROBE.ELEMENT_MAJOR(2,1) height_vert];

    X = [p1(1) p2(1) p3(1) p4(1)];
    Y = [p1(2) p2(2) p3(2) p4(2)];
    Z = [(m*(p1(1)) + height_vert) (m*(p2(1)) + height_vert) (m*(p3(1)) + height_vert) (m*(p4(1)) + height_vert)];

    if PROBE.WEDGE_SURFACE_POINT(2) ~= 0
        Z = [(m_sa *Z(1) + height_vert) (m_sa *Z(2) + height_vert) (m_sa * Z(3) + height_vert) (m_sa*Z(4) + height_vert)];
    end
    
patch(X, Y, Z, 'k');

xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis')
lbl = '3D Probe viewer [Full 3D plot]';
title(lbl);

% COMMENT OUT this option if the 3d plot is bothersome with equal axis's
%axis equal

end   
end

%% Element only plot
if strcmp(choose,'Elements-plot')
for el = 1:num_el
    
    % location of centre of each element:
    x = PROBE.ELEMENT_POSITION(1,el);
    y = PROBE.ELEMENT_POSITION(2,el);
    z = PROBE.ELEMENT_POSITION(3,el);
    
    % 4 points that define the size of each element

    p1 = [x-PROBE.ELEMENT_MINOR(1,1) y-PROBE.ELEMENT_MAJOR(2,1) 0];
    p2 = [x+PROBE.ELEMENT_MINOR(1,1) y-PROBE.ELEMENT_MAJOR(2,1) 0];
    p3 = [x+PROBE.ELEMENT_MINOR(1,1) y+PROBE.ELEMENT_MAJOR(2,1) 0];
    p4 = [x-PROBE.ELEMENT_MINOR(1,1) y+PROBE.ELEMENT_MAJOR(2,1) 0];

    X = [p1(1) p2(1) p3(1) p4(1)];
    Y = [p1(2) p2(2) p3(2) p4(2)];
    Z = [p1(3) p2(3) p3(3) p4(3)];
    
patch(X, Y, Z, 'c');

xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis')
lbl = '3D Probe viewer [Element only plot]';
title(lbl);
end

end
