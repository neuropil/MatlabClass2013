function [OutFile] = TextFileSearch2013(OutForm)






% FUNCTION CALL OUT 'nargin' : number of arguments in (i.e. how many input
% arguments)

% This conditional allows us to set a default if '0' input arguments are
% used
if nargin == 0;
    OutForm = 'string'; % default 
end

%%

% Bring up user dialog to navigate to file; only reveal files with .txt
[filename, pathname] = uigetfile('*.txt');

%%

% Change directory to the file location
cd(pathname);


%%

% Goal of this function is to find and extract the information regarding
% which electrode channels were disabled, so we know which data to exclude.


%----------------------------------------------------------------%
% Examine text file
%----------------------------------------------------------------%

% double click 'CheetahLogFile.txt' in Current Folder

% Take a look at the complexity of this text file.  We want to search it
% for just a few key pieces of information and extract those data into
% matlab for later use

%%

%----------------------------------------------------------------%
% Load text file
%----------------------------------------------------------------%

% FUNCTION CALL OUT 'fopen' : opens file for read access

fileToexamine = fopen(filename); % default permission 'r' = read

%%

%----------------------------------------------------------------%
% Create a cell array with each line of text file
%----------------------------------------------------------------%

% PSEUDO CODE

% Using a while loop

% 1. While the current text file line is not the end of the file 
% 2. Load the next line and store it in the cell of an array
% 3. While inside the loop increment the cell array row index

% FUNCTION CALL OUT 'fgetl' : displays one line at a time
% FUNCTION CALL OUT 'feof' : indicates whether the file is on the last line

lines_of_textfile = {}; % Initialize a cell array of unknown dimensions
count = 0; % Initialize a counter for the 'while' loop
while ~feof(fileToexamine); % '~' is the naught notation (e.g. 0 in boolean)
% The while loop will enter the loop as long as the condition is met.  That
% is, as long as the fileToexamine is NOT on the last line the while loop
% will execute.  The function 'feof' outputs a boolean 1 = last line and 0
% = not last line.  Without the '~', calling 'feof' on the any line but the
% last line of the file would result in a 0 which would cause the while
% loop to exit before it's started!
    count = count + 1; % Don't forget to increment your counter!!!
    text_line = fgetl(fileToexamine); % temporary extraction of the current line displayed.
    % Think of text_line as a place holder.
    lines_of_textfile{count, 1} = text_line;
    % Now were sticking our place holder 'text_line' into our growing array
    % of text file lines.
end

%%

%----------------------------------------------------------------%
% Now that we have the text file data in Matlab, close text file
%----------------------------------------------------------------%

% FUNCTION CALL OUT 'fclose' : close current open file

fclose(fileToexamine);

%%

%----------------------------------------------------------------%
% Create index of lines with DISABLED channel/lead information 
%----------------------------------------------------------------%

% Goal: get index of line numbers that contain 'Disabled' leads

% FUNCTION CALL OUT 'isempty' : test whether variable is empty
% FUNCTION CALL OUT 'strfind' : find a string pattern

indexOfDisabledLeads = false(length(lines_of_textfile),1);
% using false fills the vector with boolean 0's, so the 0's mean false
for textfI = 1:length(lines_of_textfile)
    % We're going to loop through all the lines contained in our cell array
    if isempty(strfind(lines_of_textfile{textfI},'DISABLED'))
        % if we don't find the string 'DISABLED' we want to indicate that
        % this line is false for our index of lines of interest
        indexOfDisabledLeads(textfI,1) = 0;
    else
        % if we do find a string match then we want to indicate that this
        % line is true for our index
        indexOfDisabledLeads(textfI,1) = 1;
    end
end

%%

% ADVANCED SHORT CUT ------------------------------------------------!!!!! 
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% FUNCTION CALL OUT 'cellfun' : function that operates on cell array

% indexOfDisabledLeads2 = ~cellfun('isempty', strfind(lines_of_textfile,'DISABLED'));

% Cellfun can use other general functions: 'isreal', 'islogical', 'ndims',
% 'prodofsize','isclass'
% Cellfun is primarily used in conjunction with anonymous functions
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%%

%----------------------------------------------------------------%
% Using index extract text lines of interest into a variable (cell array
%----------------------------------------------------------------%

% We're going to use our 
linesOfinterest = lines_of_textfile(indexOfDisabledLeads,:);

%%

%----------------------------------------------------------------%
% Now we're ready to get our data!!
%----------------------------------------------------------------%

% Let's look at a single line to plan how to extract what we want

sampleLine = linesOfinterest{1}

% PUESDO CODE

% We want to find the Tetrode number and Lead number that was disabled
% 1. Loop through each extracted line using the index of lines and search
% for the string values 'TT' which indicate tetrode and 'has' which will
% occurs right after the Channel/lead number.
% 2. Put tetrode number and lead number into a cell array or dataset

% FUNCTION CALL OUT 'sum' : Sums all elements of a vector or matrix
% FUNCTION CALL OUT 'strcat' : Concatenates string variables

% Cannot search for numbers since they will change line by line and there
% are multiple numbers per line, so find a string anchor/landmark from
% consistency.

LeadsOut = cell(sum(indexOfDisabledLeads),1); % Initialize empty cell array
for dc = 1:sum(indexOfDisabledLeads) % Iterate from 1 to the total number of disabled leads
    tempLine = linesOfinterest{dc}; % Use for loop iterator to extract each disabled line
    LeadsOut{dc,1} = cell2mat(regexpi(tempLine,'TT+[1-9]','match')); % Extract tetrode number
    LeadsOut{dc,2} = strcat('Lead_',cell2mat(strtrim(regexpi(tempLine,'\s[1-9]\s','match')))); % Extract lead/channel number
end
  
%%

%----------------------------------------------------------------%
% Organize data for ouput
%----------------------------------------------------------------%

% FUNCTION CALL OUT 'sortrows' : sorts vector/matrix data by selected
% column

% SWITCH/CASE % Looks for one choice among options

% FUNCTION CALL OUT 'sortrows' : sorts vector/matrix data by selected

switch OutForm % Input argument that we selected Outform = a chosen case
    
    case 'string' % case 1
        LeadsOutSort = sortrows(LeadsOut,1); % Reorder tetrodes 1-4
        OutFile = LeadsOutSort; % Assign resorted cell array to output variable
        
        
    case 'dataset' % case 2

        versionCheck = ['Release R' version('-release')];
        
        if strcmp(versionCheck, 'Release R2013a') % checks to see what version of Matlab you have running
        
        % Matlab 2013a has new functions to with dataset arrays    
            LeadsOutSort = sortrows(LeadsOut,1); % Reorder tetrodes 1-4
            datasetI = zeros(length(LeadsOutSort),2); % Initialize empty matrix
            for i = 1:length(LeadsOutSort)
                datasetI(i,1) = str2double(LeadsOutSort{i,1}(3)); % Extract tetrode number (i.e. string) and convert to number
                datasetI(i,2) = str2double(LeadsOutSort{i,2}(6)); % Extract lead number (i.e. string) and convert to number
            end
            OutFile = mat2dataset(datasetI,'VarNames',{'Tetrode','Lead'}); % Create dataset array with column titles
            
        else

            LeadsOutSort = sortrows(LeadsOut,1); % Reorder tetrodes 1-4
            Tetrode = cell(size(LeadsOutSort,1),1); % Initialize empty matrix
            Lead = cell(size(LeadsOutSort,1),1); % Initialize empty matrix
            for i = 1:size(LeadsOutSort,1)
                Tetrode{i,1} = str2double(LeadsOutSort{i,1}(end)); % Extract tetrode number (i.e. string) and convert to number
                Lead{i,1} = str2double(LeadsOutSort{i,2}(end)); % Extract lead number (i.e. string) and convert to number
            end
            OutFile = dataset(Tetrode,Lead); % Create dataset array with column titles
        end  
end
%----------------------------------------------------------------%
% Dataset option: choose output suited to your needs
%----------------------------------------------------------------%



