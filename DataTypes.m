%% DATATYPES Lecture File 9/17/2013

% This script file will illustrate examples of advanced Matlab data
% containers

% We will go over advantages, disadvantages and potential uses for:
% 1. Cell Array
% 2. Struct Array
% 3. Dataset Array

%% First a brief intro to import Excel files

% These are the three possible output arguments of 'xlsread'
[matrix_of_numbers,...
 cellArray_of_strings,...
 cellArray_of_all] = xlsread('HospitalData_HF.xlsx');

% Note that all outputs have the same dimensions
% In the matrix string columns are filled with NaNs
% The cell array of strings leaves number columns empty
% Note that the matrix of numbers does not have column headings

%%
% Matlab's generic import tool
importXLS = importdata('HospitalData_HF.xlsx');

%%
clear all; clc

%%

% Load sample dataset
load carbig % matlab data set

% other sample data sets http://www.mathworks.com/help/stats/_bq9uxn4.html

%% Let's start by examining one of the variables in the carbig dataset
% Most of you are familiar with vectors and matricies, 
% Briefly review a vector of strings

% Is there a vector of strings in the workspace?

% Let's use 'whos'
whos
% What is the class of Mfg?

%% There are different strategies for determining variable type:

% I can see that the 'Mfg' variable in the workspace has an icon that says
% 'abc': this identifies 'Mfg' as a char/string variable type
% To identify the variable type in the command window we can use
% 'whos' or 'class'

% Let's make some generic variables
a = 'a'; % single letter
b = 'some string'; % string of characters
c = 1; % single numeric
d = pi; % matlab numeric
num = 17; e = num; % inherited numeric from variable assignment
clc
%% 'whos' will display the class of all variables in workspace

whos('a','b','c','d','e')
class(Mfg)

%% Mfg is a vector of strings, let's look at the first 10 rows

Mfg(1:10,:)

% Working with an array of strings can be tricky

%% Let's look at some examples

% Example 1
% What's the actual length of the word
chevrolet = length('chevrolet')

%% Length of chevrolet from string vector

lengthOfchev = length(Mfg(1,:))

% Although individual strings are of different lengths (e.g. chevrolet and
% buick), all rows of a character/string vector inherit the length of the 
% longest row (padded with blanks).

% One way to rid a vector of strings of their blanks is to use a Cell Array

%% CELL ARRAYS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One way to make a vector or matrix of strings easier to manipulate is
% with the use of a cell array, but they also have many additional
% advantages

% Cell arrays are essentially indexed data containers
clc
%% What happens when we convert Mfg to a cell array

MfgCellarray = cellstr(Mfg);

% Let's see if the class of these two variables are different now
MfgClass = class(Mfg)
MfgCAClass = class(MfgCellarray)

%% Quick note on accessing cells in Cell Arrays '{}'

% We're going to want to analyze chevrolet again; how do extract it?

chevCA_1 = MfgCellarray(1) % Using paratheses

%%

chevCA_2 = MfgCellarray{1} % Using curly brackets

% What gives?

% Let's try class and length to see the difference

%% Length Test

length(chevCA_1)
length(chevCA_2)
%% Class Test

class(chevCA_1)
class(chevCA_2)

% Notes:

% Using paraentheses will extract the cell of interest
% However, using curly brackets will extract the contents of the cell


%% Back to our original question: Examine cell array elements

% How do they differ from their string vector counterparts?

lengthOfchev2 = length(MfgCellarray{1})

% string variables in individual cells eliminate leading and trailing blanks 

% The big advantage of a cell array is the ability to combine different data types

%% Let's combine the car names and the horsepower numeric array
clc
%% Convert Horsepower matrix to cell array

% I could insert the entire horsepower numeric vector into a single cell of
% an cell array, but I want to align the numbers with their respective car
% names so I will use a function 'num2cell' which converts each numeric
% value to a single cell

horsepowerCA1 = {Horsepower}

%% What I really want is a cell for each numeric value 
% Use the function num2cell
horsepowerCA = num2cell(Horsepower)
%%

clc

%% Is there a class difference between Horsepower and horsepowerCA

original_HP = class(Horsepower)
new_HP = class(horsepowerCA)
%% You can also check speific properties with is* functions

% http://www.mathworks.com/help/matlab/ref/is.html?searchHighlight=is+functions

is_it_a_cell = iscell(Horsepower)
is_it_a_vec = isvector(Horsepower)

%% Combine car names cell array and horsepower cell array

% ONE ADVANTAGE is the ability to align different variable types in a
% matrix like format; easier for indexing

% I am going to horizontally concatenate these two cell arrays using the
% function 'horzcat'

carArray = horzcat(horsepowerCA, MfgCellarray);

% Examine first 5 rows of cell array
upperVals = carArray(1:5,1:2)

% This is helpful for maintaining the alignment/organization of your
% observations. Each cell row will contain an observation whereas each
% column will contain a different variable. Very helpful when looping
% through multiple variables.

%%

clc

%% Another advantage of cell arrays is the capacity to hold differently sized vectors

cell1 = rand(1,100);
cell2 = rand(1,10);
cell3 = rand(1,4000);
cell4 = Mfg;

% Examine new cell array of engines separated in horsepower categories

CellArray = {cell1 , cell2 , cell3 , cell4} % observe that each cell has a different sized vector

%% One more example
stuff = struct;
cell1 = {1:10};
cell2 = 'hello world';
cell3 = (1:10)';
cell4 = stuff; stuff.name = 'John'; stuff.age = 25; 

CA2 = {cell1,cell2 ; cell3,cell4}

%% Disadvantages of cell arrays

% 1. Cannot keep implicit track of data information (i.e. row/column
% headings)

% 2. Can be cumbersome to work with for data analysis; 
% better for extraction/orgization/storage

clc

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

%% Easy to add new levels to existing structures

carsStruct(1).price = 20000
carsStruct(2).price = 25000

%% New struct

carsStruct(1)

%% Different datasets in each structure element

mouse(1).name = 'Case56';
mouse(1).group = 'control';
mouse(1).data = [178; 185; 171];

mouse(2).name = 'Case63';
mouse(2).group = 'water deprived';
mouse(2).data = [68; 118; 172];
clc
%% Examine 1 level from new struct

mouse(1)

%% Access field names of structures

% Easy way to access levels of a struct array is to use the function
% fieldnames

structFnames = fieldnames(mouse)

%% Dynamic field names for structures

% This next example will:
% 1. Show you the long way to construct a struct array from a cell array
% 2. Introduce to the use of dynamic fieldnames which can be very useful

% First let's create an unlabled cell array
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
    for i2 = 1:length(carData)
        SomecarData.(MfgCellarray{i}).(VarNames{i2}) = carData{i2}
    end
end

%% Simple way to convert from cell array to structure array

% use cell2struct function 
AllcarData2 = cell2struct(carData,VarNames,2)


%% DATASET ARRAYs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

clc
%% Compare dataset and cell array

carDataCA = horzcat(num2cell(Acceleration),num2cell(Cylinders),num2cell(Displacement),cellstr(Mfg));
carDataDS = dataset(Acceleration,Cylinders,Displacement,MfgCellarray);

carDataCA_small = carDataCA(1:10,:)
carDataDS_small = carDataDS(1:10,:) % Notice that dataset assumes variable names to be column headings

% Extract column names to own variable OR
% How to make it more useful: dataset array


%% Let's say that was not the case

var1 = Acceleration; var2 = Cylinders; var3 = Displacement; var4 = MfgCellarray;

NocolsCA = dataset(var1(1:10,:),var2(1:10,:),var3(1:10,:),var4(1:10,:))

%% Explicitly change column headings 

NocolsCA.Properties.VarNames = VarNames

% if you have 2013a can use this function
% dataSet2 = cell2dataset(NocolsCA,'VarNames',VarNames)

%% What can we do with a dataset array
clc
%% 1. Use '.' dot notation to access different variables

carDataDS_small.MfgCellarray

%% 2. Index on a subset of data in one variable

dataout = carDataDS(carDataDS.Cylinders == 4,:)

%% 3. Quick load an Excel sheet as a dataset

dataset('XLSFile','hospital.xls','ReadObsNames',true)

%% 4. Convert variables to nominal (i.e. categorically discrete)
load('hospital');
hospitalDS = hospital;

hostop = hospitalDS(1:5,:)

% What kind of variable type does the Smoker column contain?

%% 5. Define how the discrete values should be interpreted 
hospitalDS.Smoker = nominal(hospitalDS.Smoker,{'no','yes'})


%% 6. Use a series of conditionals to extract data

% Let's say we want to run a study on a particular demographic

DemoGr = hospitalDS.Sex == 'Male' & (hospitalDS.Age > 35 & hospitalDS.Age < 45) & hospitalDS.Smoker == 'no';

%% Index on new variable

hospitalDS(DemoGr,:)

%% 7. Add the new variable to our existing dataset array

hospitalDS.DemoGr = DemoGr

%%
clc
%% Structure and dataset combination STEP 1

% In this block of code I'm going to first determine the number of unique
% cylinder types so that I can get the number of different groups for my
% structure array.  To accomplish this I will use the 'unique' function
% which operates on both numeric and character/string variables
uniqueCylinders = unique(carDataDS.Cylinders)

% As you can see, the result is the unqiue values from the vector
% Now we know two useful pieces of information:
% 1. The number of unqiue groups (important for 'for-looping' purposes)
% 2. The identity of the unique groups


%% STEP 2

% First let's initialize an empty structure array
CarCylTypes = struct;
%%
% We know that the number of layers we want to add to the structure is
% equivalent to the number of unique cylinder groups

% PUESDO-CODE
% for iterator = 1:number of unique groups

for ci = 1:length(uniqueCylinders)
    
    % Looking ahead I know that I want to name each layer of the structure
    % by the cylinder identity, but I don't want to hard code that value 
    % because it could change with a different list of engines, so rather than hard
    % code the structure layer names, I will use the dynamic fieldname
    % feature combined with my list of unique cylinder groups
    
    % This line will make the structure code cleaner. I'm going to convert
    % the unique cylinder group number (a numeric variable) to a
    % string variable so that I can use it as structure layer name. I'm
    % going to use the function 'num2str', which simply converts a numeric
    % variable to a string variable. 
    cylString = num2str(uniqueCylinders(ci));
    

    
    CarCylTypes.(strcat('Cyl_',cylString)) = carDataDS(carDataDS.Cylinders == uniqueCylinders(ci),:)
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

% Fix mouse data set



