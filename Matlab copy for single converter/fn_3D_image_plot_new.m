function fn_3D_image_plot_new (PROBE,num_el)

%PROBE.ELEMENT_MAJOR = [0 0.005 0];
% Minor dimension is half of the width, i.e. from the centre of element to
% the end, so creating seperate variable (_half)

PROBE.ELEMENT_MINOR_HALF = PROBE.ELEMENT_MINOR/2;
PROBE.ELEMENT_MINOR_HALF(1,:) = PROBE.ELEMENT_MINOR_HALF(1,:) - (0.5e-4); %Accounting for pitch can be adjusted
PROBE_HEIGHT = 2;
grid on
axis([-0.035 0.035 -0.01 0.01 0 0.1])
hold on,


%% points defining wedge surface (PCS Y coordinate for surface point = 0 [NO SQUINT])
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

    p1 = [x-PROBE.ELEMENT_MINOR_HALF(1,1) y-PROBE.ELEMENT_MAJOR(2,1) height_vert];
    p2 = [x+PROBE.ELEMENT_MINOR_HALF(1,1) y-PROBE.ELEMENT_MAJOR(2,1) height_vert];
    p3 = [x+PROBE.ELEMENT_MINOR_HALF(1,1) y+PROBE.ELEMENT_MAJOR(2,1) height_vert];
    p4 = [x-PROBE.ELEMENT_MINOR_HALF(1,1) y+PROBE.ELEMENT_MAJOR(2,1) height_vert];

    X = [p1(1) p2(1) p3(1) p4(1)];
    Y = [p1(2) p2(2) p3(2) p4(2)];
    Z = [(m*(p1(1)) + height_vert) (m*(p2(1)) + height_vert) (m*(p3(1)) + height_vert) (m*(p4(1)) + height_vert)];

    if PROBE.WEDGE_SURFACE_POINT(2) ~= 0
        Z = [(m_sa *Z(1) + height_vert) (m_sa *Z(2) + height_vert) (m_sa * Z(3) + height_vert) (m_sa*Z(4) + height_vert)];
    end
    
patch(X, Y, Z, 'b');
    
end   
    
end
