%------------------------------------------------------------------------
% Program name  : Flight Path Simulation/Motion Tracking
% 
% Author        : Oliver Salmeron
%
% Description   : Matlab script for processing IMU [and GPS] data to simulate the flight path and motion. 
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
% To do : Update script to integrate GPS data
%         Integrate MATLAB with Arduino for faster and easier testing
%           -Add ArduinoIO package to MATLAB
%         Update script to a function
%         Update to read a csv file (instead of import text file)?
%-------------------------------------------------------------------------
