function fn_3D_image_plot (PROBE,num_el)


PROBE.ELEMENT_MAJOR = [0 0.005 0];
% Minor dimension is half of the width, i.e. from the centre of element to
% the end, so creating seperate variable (_half)

PROBE.ELEMENT_MINOR_HALF = PROBE.ELEMENT_MINOR/2;
%PROBE.ELEMENT_MINOR_HALF(1,1) = PROBE.ELEMENT_MINOR_HALF(1,1) - (0.5e-4); %Accounting for pitch can be adjusted
PROBE_HEIGHT = 2;
grid on
axis([-0.02 0.02 -0.01 0.01 0 2.5])
hold on,



%for wedge
%centre of wedge found my avg of first and last dimensions of elements
%centre_x_w =  (PROBE.ELEMENT_POSITION(1,1)+ PROBE.ELEMENT_POSITION(1,num_el))/2;
%centre_x_y =  (PROBE.ELEMENT_POSITION(2,1)+ PROBE.ELEMENT_POSITION(2,num_el))/2;
%z_w = PROBE.WEDGE_HEIGHT;
%points to define the coordinates of the wedge
 %p1 = [centre_x_w-(PROBE.WEDGE_LENGTH/2) centre_x_y-(PROBE.WEDGE_WIDTH/2) z_w];
 %p2 = [centre_x_w+(PROBE.WEDGE_LENGTH/2) centre_x_y-(PROBE.WEDGE_WIDTH/2) z_w];
 %p3 = [centre_x_w+(PROBE.WEDGE_LENGTH/2) centre_x_y+(PROBE.WEDGE_WIDTH/2) z_w];
 %p4 = [centre_x_w-(PROBE.WEDGE_LENGTH/2) centre_x_y+(PROBE.WEDGE_WIDTH/2) z_w];
%wedge angle not needed as the z component for p3 and p4 wil change with the
%introduction of an angle introducing the slope
%X = [p1(1) p2(1) p3(1) p4(1)];
%Y = [p1(2) p2(2) p3(2) p4(2)];
%Z = [p1(3) p2(3) p3(3) p4(3)];
%patch (X, Y, Z, 'r'); %wedge in red


% Check if wedge exists:
if (isfield(PROBE, 'WEDGE_SURFACE_POINT') || isfield(PROBE, 'WEDGE_SURFACE_NORMAL'))
   

% For each element
for el = 1:num_el
    
    % location of centre of each element:
    x = PROBE.ELEMENT_POSITION(1,el);
    y = PROBE.ELEMENT_POSITION(2,el);
    z = PROBE.ELEMENT_POSITION(3,el);
    
    % 4 points that define the size of each element

    p1 = [x-PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) z];
    p2 = [x+PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) z];
    p3 = [x+PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) z];
    p4 = [x-PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) z];

    X = [p1(1) p2(1) p3(1) p4(1)];
    Y = [p1(2) p2(2) p3(2) p4(2)];
    Z = [p1(3) p2(3) p3(3) p4(3)];
    patch(X, Y, Z);
    
end


% draw the probe itself:
% Side 1:
x = PROBE.ELEMENT_POSITION(1,1);
y = PROBE.ELEMENT_POSITION(2,1);
z = PROBE.ELEMENT_POSITION(3,1);

PROBE_P1 = [x-PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) z];
PROBE_P2 = [x-PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) z];
PROBE_P3 = [x-PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];
PROBE_P4 = [x-PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];

X = [PROBE_P1(1) PROBE_P2(1) PROBE_P3(1) PROBE_P4(1) PROBE_P1(1)];
Y = [PROBE_P1(2) PROBE_P2(2) PROBE_P3(2) PROBE_P4(2) PROBE_P1(2)];
Z = [PROBE_P1(3) PROBE_P2(3) PROBE_P3(3) PROBE_P4(3) PROBE_P1(3)];
s1 = patch(X,Y,Z,'black');
% make side mostly translucent
alpha(s1,0.05);

%Side 2:
x1 = PROBE.ELEMENT_POSITION(1,1);
x2 = PROBE.ELEMENT_POSITION(1,num_el);
y = PROBE.ELEMENT_POSITION(2,1);
z = PROBE.ELEMENT_POSITION(3,1);

PROBE_P1 = [x1-PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) z];
PROBE_P2 = [x2+PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) z];
PROBE_P3 = [x2+PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];
PROBE_P4 = [x1-PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];

X = [PROBE_P1(1) PROBE_P2(1) PROBE_P3(1) PROBE_P4(1) PROBE_P1(1)];
Y = [PROBE_P1(2) PROBE_P2(2) PROBE_P3(2) PROBE_P4(2) PROBE_P1(2)];
Z = [PROBE_P1(3) PROBE_P2(3) PROBE_P3(3) PROBE_P4(3) PROBE_P1(3)];
s2 = patch(X,Y,Z,'black');
alpha(s2,0.05);



%Side 3:
x1 = PROBE.ELEMENT_POSITION(1,1);
x2 = PROBE.ELEMENT_POSITION(1,num_el);
y = PROBE.ELEMENT_POSITION(2,1);
z = PROBE.ELEMENT_POSITION(3,1);

PROBE_P1 = [x1-PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) z];
PROBE_P2 = [x2+PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) z];
PROBE_P3 = [x2+PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];
PROBE_P4 = [x1-PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];

X = [PROBE_P1(1) PROBE_P2(1) PROBE_P3(1) PROBE_P4(1) PROBE_P1(1)];
Y = [PROBE_P1(2) PROBE_P2(2) PROBE_P3(2) PROBE_P4(2) PROBE_P1(2)];
Z = [PROBE_P1(3) PROBE_P2(3) PROBE_P3(3) PROBE_P4(3) PROBE_P1(3)];
s3 = patch(X,Y,Z,'black');
alpha(s3,0.05);

% Side 4:
x = PROBE.ELEMENT_POSITION(1,num_el);
y = PROBE.ELEMENT_POSITION(2,num_el);
z = PROBE.ELEMENT_POSITION(3,num_el);

PROBE_P1 = [x+PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) z];
PROBE_P2 = [x+PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) z];
PROBE_P3 = [x+PROBE.ELEMENT_MINOR_HALF(1) y+PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];
PROBE_P4 = [x+PROBE.ELEMENT_MINOR_HALF(1) y-PROBE.ELEMENT_MAJOR(2) PROBE_HEIGHT];

X = [PROBE_P1(1) PROBE_P2(1) PROBE_P3(1) PROBE_P4(1) PROBE_P1(1)];
Y = [PROBE_P1(2) PROBE_P2(2) PROBE_P3(2) PROBE_P4(2) PROBE_P1(2)];
Z = [PROBE_P1(3) PROBE_P2(3) PROBE_P3(3) PROBE_P4(3) PROBE_P1(3)];
s4 = patch(X,Y,Z,'black');
alpha(s4,0.05);
hold off

end
