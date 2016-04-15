%------------------------------------------------------------------------
% Program name  : Flight Path Simulation/Motion Tracking
% 
% Author        : Oliver Salmeron
%
% Version       : 1.2
%
% Description   : Matlab script for processing IMU [and GPS] data to simulate the flight motion and path. 
% 
% This program will open a text file containing flight data (roll,pitch,yaw,lat,lon,alt) to rotate a 3D
% object. The result is saved as a movie named 'flightSimulation.mp4'.
% This will help to visualize the motion tracking of a payload during the course of a flight.
%
% To look up a MATLAB command, highlight command and press F1.
%
% Steps Outline :
%   1. Generate Grid.
%   2. Generate Cylinder and Frame vectors.
%   3. Plot the Cylinder and Frame vectors.
%   4. Create a Group Object and Parent Surface.
%   5. Import 'flightData.txt' text file for reading.
%   6. Open/Close text file to read and exctract data.
%   7. Parse imported data into temporary variables.
%   8. Create Video File to write to.
%   9. Create a set of frames and write each frame to Video File.
%
%   Useful MATLAB Commands:
%       colormap
%       
%
%
%
% To do : Update script to integrate GPS data
%         Integrate MATLAB with Arduino for faster and easier testing
%           -Add ArduinoIO package to MATLAB
%         Update script to a function
%         Update to read a csv file (instead of import text file)?
%
%         Color maps: colormap(gray), colormap hsv, colormap copper
%-------------------------------------------------------------------------

%% 1. Generate Grid

clf
myaxes = axes('xlim',[-1.5 1.5],'ylim',[-1.5 1.5],'zlim',[-1.5 1.5]);
view(3)
grid on
hold on
xlabel('x')
ylabel('y')
zlabel('z')

% Additional Grid options
%axis square        % Adjusts plot axes to square
%axis equal         % Adjusts plot axes to equal
%axis off           % Removes axes grid

%% 2. Generate the Cylinder and frame vectors.

% draw the three coloured frame lines
Lx = line([0 1.25],[0,0],[0,0],'color',[1,0,0]);
Ly = line([0 0],[0,1.25],[0,0],'color',[0,1,0]);
Lz = line([0 0],[0,0],[0,1.25],'color',[0,0,1]);
	
set([Lx,Ly,Lz],'linewidth',3)
    
% add text for x,y and z for each frame line
tX = text('position',[.7 0 .1],'string','x','fontw','b');
tY = text('position',[ 0 .7 .1],'string','y','fontw','b');
tZ = text('position',[.05 0.05 .7],'string','z','fontw','b');
	
% draw the three base frame axis lines for reference
line([0 1.5],[0,0],[0,0],'color',[0,0,0],'linewidth',1);
line([0 0],[0,1.5],[0,0],'color',[0,0,0],'linewidth',1);
line([0 0],[0,0],[0,1.5],'color',[0,0,0],'linewidth',1);
	
% add text for x0,y0 and z0 for each base frame line
text('position',[1.3 0 .1],'string','x_0','fontw','b');
text('position',[ 0 1.3 .1],'string','y_0','fontw','b');
text('position',[.05 0.05 1.3],'string','z_0','fontw','b');

% add text to display altitude

% create Cylinder
[X,Y,Z] = cylinder([0.75 0.75]);	

% create Sphere
[S1,S2,S3] = sphere;

    
%% 3. Plot the shapes/Create the object
% Plot the cylinder (Body)
	
h(1) = surf(X.*0.5,Y.*0.5,Z.*0.5);
h(2) = surf(-X.*0.5,-Y.*0.5,-Z.*0.5);

% Plot the Sphere (Bottom)
h(9)  = surf(S1.*0.375,S2.*0.375,S3.*0.375-0.5);

% Plot the Circle (Lid)
h(10) = surf(S1.*0.375,S2.*0.375,S3.*0+0.5);
h(11) = mesh(S1.*0.1,S2.*0.1,S3.*0.05+0.5);

%Set the colormap (lots to look up)
colormap(gray)

% Plot the Base and Frame Vectors
h(3) = Lx;
h(4) = Ly;
h(5) = Lz;

h(6) = tX;
h(7) = tY;
h(8) = tZ;

% plot origin point
plot3(0,0,0,'x','markersize',20,'color','k')

%% 4. Create a group object and parent surface 
    
set(h,'Clipping','off');
combinedobject = hgtransform('parent',myaxes);
set(h, 'parent', combinedobject)
drawnow

%% 5. Import 'flightData' text file for reading. 

% Use the Import tool from the home tab to visually select data to extract from a
% file and generate script.

%Initialize variables.

% Only the filename needs to be updated with the correct full file path.
filename = 'C:\Users\Oliver\Desktop\MATLAB Functions\Flight Path Processing\flightData.txt';
delimiter = '\t';
startRow = 2;
    
% Format string for each line of text:
    %   column1: double (%f)
    %	column2: double (%f)
    %   column3: double (%f)
    %	column4: double (%f)
    %   column5: double (%f)
    %	column6: double (%f)
    %   column7: double (%f)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';

%% 6. Open/Close text file to read and extract data

% Open the text file.
fileID = fopen(filename,'r');
    
% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    
% Close the text file.
fclose(fileID);
   
    % To include COM port for serial interface, use the command line below.
    % This would help for live testing of code. If used, comment out the
    % File Import section.
    
    %a= arduino('com3');        % Select COM port


%%  7. Parse imported data into temporary variables.

% Allocate imported array to column variable names
Time = dataArray{:, 1};
roll = dataArray{:, 2};
pitch = dataArray{:, 3};
yaw = dataArray{:, 4};
lat = dataArray{:, 5};
lon = dataArray{:, 6};
alt = dataArray{:, 7};
    
% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
    
%% 8. Create Video File to write to.
v = VideoWriter('flightSimulation.mp4','MPEG-4')         % Create an mp4 file type and display properties
open(v);
%axis tight manual
set(gca,'nextplot','replacechildren');

%% 9. Create a set of frames and write each frame to Video File.
    radians_degree = pi/180;    % Conversion factor from Degrees to Radians.
    feet_meter = 3.28084;        % Conversion factor from Meters to Feet (1m=3.28ft)
    
for Time = 7550:7708     % Update limit of while loop to Max Time
    % Read GPS values (lat,lon,alt-->lat,lon,a).
    %lat = lat(Time);
    %lon = lon(Time);


    
    
    % Read Euler angles (roll,pitch,yaw-->r,p,y).
    r = roll(Time);         % r <-- roll reading
    p = pitch(Time);        % p <-- pitch reading
    y = yaw(Time);          % y <-- yaw reading
     
    % Convert Euler angles to (X,Y,Z) axes rotations in radians.
    X = r*radians_degree;   % X <-- r
    Y = p*radians_degree;   % Y <-- p
    Z = y*radians_degree;   % Z <-- y
   
    % Rotate object in steps.
    Rot = makehgtform('xrotate',X,'yrotate',Y,'zrotate',Z);
    set(combinedobject,'Matrix',Rot)
    
    % Convert alt to feet and plot as title
    %a = alt(Time);
    %alt = a*feet_meter;
    %plot3(0,0,1,text(0,0,1,['alt: ',int2str(alt)]));
    
    drawnow;
    %pause(0.0001);        % Set the plot rate
    

    
    axis([-1 1 -1 1 -1 1])  % Set the axis for each frame of the loop for recording a movie
    frame = getframe;       
    writeVideo(v,frame);    % Record Movie of the frames   
   
    Time=Time+1;            % Increment the for loop
end

close(v);