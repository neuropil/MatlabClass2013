%% DATATYPES Lecture File 9/17/2013

% This script file will illustrate examples of advanced Matlab data
% containers

% We will go over advantages, disadvantages and potential uses for:
% 1. Cell Array
% 2. Struct Array
% 3. Dataset Array

% Load sample dataset
load carbig % matlab data set

% other sample data sets http://www.mathworks.com/help/stats/_bq9uxn4.html

%% Let's start by examining one of the variables in the carbig dataset
% Most of you are familiar with vectors and matricies, but what about a
% vector of strings

% Is there a vector of stings in the workspace?

% Let's use 'whos'
whos
% What is the class of Mfg?

%% There are different strategies for determining variable type:

% I can see that the 'Mfg' variable in the workspace has an icon that says
% 'abc': this identifies 'Mfg' as a char/string variable type
% To identify the variable type in the command window we can use
% 'whos' or 'class'

% Let's make some generic variables
a = 'a'; 
b = 'some string';
c = 1;
d = pi;
num = 17; e = num;
%% 'whos' will display the class of all variables in workspace

whos('a','b','c','d','e')
class(Mfg)

%% Mfg is a vector of strings, let's look at the first 10 rows

Mfg(1:10,:)

% Working with an array of strings can be tricky

% Although individual strings are of different lengths (e.g. chevrolet and
% buick), all rows of a character/string vector inherit the length of the 
% longest row (padded with blanks).

%% Let's look at some examples

% Example 1

chevrolet = length('chevrolet') % actual length of chevrolet string

chevVar = Mfg(1,:); % first string variable in Mfg string vector

% It doesn't matter if we extract the string from the string vector
% Length of string extracted from string vector
lengthOfchevVar = length(chevVar)
% Notice in the workspace how chevrolet is trailed by 6 spaces. 

% Length of string in string vector
lengthOfchev = length(Mfg(1,:))


%% Example 2

buick = length('buick')
buickvar = Mfg(2,:)

%% CELL ARRAYS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One way to make a vector or matrix of strings easier to manipulate is
% with the use of a cell array, but they also have many additional
% advantages

% Cell arrays are essentially indexed data containers

%% What happens when we convert Mfg to a cell array

MfgCellarray = cellstr(Mfg);

% Let's see if the class of these two variables are different now
class(Mfg)
class(MfgCellarray)

%% Examine cell array elements

% How do they differ from their string vector counterparts?

chevVar2 = MfgCellarray{1}

lengthofchevVar2 = length(chevVar2)
lengthofchevCellArray = length(MfgCellarray{1})

%% What about buick?

buickVar2 = MfgCellarray{2}
lengthOfbuickVar2 = length(buickVar2)

% sting variables in individual cells eliminate leading and trailing blanks 

% The big advantage of a cell array is the ability to combine different data types

% Let's combine the car names and the horsepower numeric array

%% Convert Horsepower matrix to cell array

% I could insert the entire horsepower numeric vector into a single cell of
% an cell array, but I want to align the numbers with their respective car
% names so I will use a function 'num2cell' which converts each numeric
% value to a single cell

horsepowerCA = num2cell(Horsepower);

%% Is there a class difference between Horsepower and horsepowerCA

class(Horsepower)
class(horsepowerCA)
%% You can also check speific properties with is* functions

% http://www.mathworks.com/help/matlab/ref/is.html?searchHighlight=is+functions

iscell(Horsepower)
isvector(Horsepower)

%% Combine car names cell array and horsepower cell array

% I am going to horizontally concatenate these two cell arrays using the
% function 'horzcat'

carArray = horzcat(horsepowerCA, MfgCellarray);

% Examine first 5 rows of cell array
upperVals = carArray(1:5,1:2)

%% Another advantage of cell arrays is the capacity to hold differently sized vectors

cell1 = rand(1,100);
cell2 = rand(1,10);
cell3 = rand(1,4000);
cell4 = Mfg;

%% Examine new cell array of engines separated in horsepower categories

CellArray = {cell1 , cell2 , cell3 , cell4} % observe that each cell has a different sized vector

%% One more example
stuff = struct;
cell1 = single(1);
cell2 = 'hello';
cell3 = (1:10)';
cell4 = stuff; stuff.name = 'John'; stuff.age = 25; 

CA2 = {cell1,cell2 ; cell3,cell4}

%%

cellplot(CA2,'legend')


%% Look at first cell and examine first cell container

horsePower_rowID{1}

% You now have a single variable with varying numbers of containers to
% perform analyses; this would not be possible in a matrix

%% Let's use one index to get 

% Disadvantages of cell arrays

% 1. Cannot keep implicit track of data information (i.e. row/column
% headings)
% 2. Can be cumbersome to work with for data analysis; better for extraction/orgization/storage


%% STRUCTURE ARRAYS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Allows you to package data either by case/variable/experiement

% Use '.' (dot notation) to access different branches/levels of structure

%% Example of a Case structure

% Create two cases with similar branch/level structure
carsStruct(1).name = MfgCellarray{1};
carsStruct(1).cylinders = Cylinders(1);
carsStruct(1).Model = cellstr(Model(1,:));
carsStruct(1).Weight = Weight(1);

carsStruct(2).name = MfgCellarray{2};
carsStruct(2).cylinders = Cylinders(2);
carsStruct(2).Model = cellstr(Model(2,:));
carsStruct(2).Weight = Weight(2);

%% Examine structure
% What do see in the command window when you request the struct

carsStruct

% We see the field names which can be interogated by dot notation
% what appears in command window?
% answer: fieldnames
%% Dot notation: Examine a field name

carsStruct.name

%% How about when we request a single case?

carsStruct(1)


%% Examine the second case in the stucture

carsStruct(2)

%% Different datasets in each structure element

mouse(1).name = 'Case56';
mouse(1).group = 'control';
mouse(1).test = [178; 185; 171];

mouse(2).name = 'Case63';
mouse(2).group = 'water deprived';
mouse(2).test = [68; 118; 172];

numanimals = numel(mouse);
for p = 1:numanimals
   figure
   bar(mouse(p).test)
   title(mouse(p).group)
   xlabel('Day')
end

%% Access field names of structures

structFnames = fieldnames(mouse)

%% Dynamic field names for structures

% Unlabeled cell array that contains car data of varying variable types

carData = {Acceleration,Cylinders,Displacement,Mfg}

%% Variable names for dynamic indexing

VarNames = {'Acceleration','Cylinders','Displacement','Mfg'}

%% Car data conversion to structure usind dynamic indexing

AllcarData = struct;
for i = 1:length(VarNames)
    AllcarData.(VarNames{i}) = carData{i}
end

%% There are different ways to cut up the data into a structure

SomecarData = struct;
for i = 1:10
    SomecarData.(MfgCellarray{i}).Accel = Acceleration(i)
    SomecarData.(MfgCellarray{i}).Cyli = Cylinders(i)
    SomecarData.(MfgCellarray{i}).Disp = Displacement(i)
    SomecarData.(MfgCellarray{i}).HP = Horsepower(i)
end

%% Simple way to convert from cell array to structure array

% use cell2struct function 
AllcarData2 = cell2struct(carData,VarNames,2);


%% DATASET ARRAYs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,~,cellArray] = xlsread('ClassXLs.xlsx')

% Complain about input

% Extract column names to own variable OR
% How to make it more useful: dataset array

%% Convert to dataset array

% If you have 2013a 

dataSet = cell2dataset(cellArray)

% This assumes that the first cell in each column is the column title

%% Let's say that was not the case
colNames = cellArray(1,1:end)
NocolsCA = cellArray(2:end,1:end)

% have to designate col names with 'VarNames' input argument
dataSet2 = cell2dataset(NocolsCA,'VarNames',colNames)

%% If you are not running Matlab 2013a
% Just include the vectors of all data you want concatentated into a
% dataset array the variable name will become the column name

dataSet3 = dataset(Acceleration,Cylinders,Displacement,MfgCellarray)

%% What can we do with a dataset array

% use '.' dot notation to access different variables

dataSet3.MfgCellarray

%% Index on a subset of data in one variable

dataout = dataSet3(dataSet3.Cylinders == 4,:)


%% One more example

load('hospital')

% Let's examine the dataset
hospital

%% Let's write this conditional together
% 
% NSyF = hospital.Sex == ? & hospital.Age ? 25 & hospital.Smoker == ?  
% 
% Extract smoker column

%% What class it the smoker column

class(hospital.Smoker)

%% Add the new variable to our existing dataset array

% Combine new logical dataset

hospital.NSyF = NSyF

%% Structure and dataset combination STEP 1

% In this block of code I'm going to first determine the number of unique
% cylinder types so that I can get the number of different groups for my
% structure array.  To accomplish this I will use the 'unique' function
% which operates on both numeric and character/string variables
uniqueCylinders = unique(dataSet3.Cylinders)

% As you can see, the result is the unqiue values from the vector
% Now we know two useful pieces of information:
% 1. The number of unqiue groups (important for 'for-looping' purposes)
% 2. The identity of the unique groups


%% STEP 2

% First let's initialize an empty structure array
CarCylTypes = struct;

% We know that the number of layers we want to add to the structure is
% equivalent to the number of unique cylinder groups

% PUESDO-CODE
% for iterator = 1:number of unique groups

for ci = 1:length(uniqueCylinders)
    
    % Looking ahead I know that I want to name each layer of the structure
    % by the cylinder identity, but I don't know what value will be and it
    % could change with a different list of engines, so rather than hard
    % code the structure layer names, I will use the dynamic fieldname
    % feature combined with my list of unique cylinder groups
    
    % This line will make the structure code cleaner. I'm going to convert
    % the unique cylinder group number (a numeric variable) to a
    % string variable so that I can use it as structure layer name. I'm
    % going to use the function 'num2str', which simply converts a numeric
    % variable to a string variable. 
    cylString = num2str(uniqueCylinders(ci));
    

    
    CarCylTypes.(strcat('Cyl_',cylString)) = dataSet3(dataSet3.Cylinders == uniqueCylinders(ci),:)
end

% These four lines of code performed a fairly complicated data orgaization
% task that will make it easier for me to examine/analyse those data.

%% Examples of data exploration in dataset array

% Don't have to remember column number for identification, just use name of
% variable
%% min
min(CarCylTypes.Cyl_4.Acceleration)
%% max
max(CarCylTypes.Cyl_4.Acceleration)
%% mean
mean(CarCylTypes.Cyl_4.Acceleration)
%% mean of index

% In this instance I am interested in obtaining the mean acceleration of
% the 4 cylinder car models for only those models that have a displacement
% of greater than 100. Utilizing the reference scaffolding of the structure 
% and dataset arrays I can do this very easily.

mean(CarCylTypes.Cyl_4.Acceleration(CarCylTypes.Cyl_4.Displacement > 100,:))

%% Any Questions??????
