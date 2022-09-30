% The Evolution Strategy Toolbox  
% Version 3.0   October-96
%
% Routines to call the evolution strategy
%    evolut      -  Start the evolution strategy with GUI
%    evolut1     -  Start the evolution strategy without GUI 
%
% Main programs
%    evolstr     -  Auxiliary program to call the main algorithm of the 
%                   evolution strategy 
%
%    esmut       -  Evolution Strategy's Mutation (main program)
%      esmutsa   -  Self-adaptation mutation
%      esmutint  -  Integer mutation (for integer variable)
%
%    esoptions   -  Options for Evolution Strategy
%
%    esreprod    -  Evolution Strategy's Reproduction (main program)
%      esarico   -  Arithmetical Crossover
%      eshxo     -  Heuristical Crossover
%      esintxo   -  Integer Crossover (for integer variable)
%      esrecint  -  Recombination extended intermediate 
%      esreclin  -  Recombination extended line 
%      esreclp   -  Recombination extended line plus 
%      esxovmp   -  Crossover with Multi-Parents
%
%    esselect    -  Evolution Strategy's Selection  (main program) 
%      esfselm   -  Select feasible individuals from current population
%                   consisting feasible and unfeasible individuals
%                   (by Multiobjective Optimization)
%      esfselmf  -  Select feasible individuals from a feasible population
%                   (by Multiobjective Optimization)
%      esfsels   -  Select feasible individuals from current population
%                   consisting feasible and unfeasible individuals
%                   (by Single-objective Optimization)
%      esfselsf  -  Select feasible individuals from a feasible population
%                   (by Single-objective Optimization)
%      esfselsr  -  Select feasible individuals by searching for
%                   a feasible region
%      esfselsu  -  Select unfeasible individuals by searching for 
%                   a feasible region
%      esusel    -  Select unfeasible an niche individuals
%                   (by Single-objective Optimization)
%
%    esredist    -  Redistribute the current population
%    mainprog    -  The main algorithm of the evolution strategy
%    noninfsl    -  Non-inferior individuals selection
%    obj2spl     -  Ranking the current population using objective values
%
%    setpopul    -  Program to generate the starting population
%
% Demonstration
%    demolist    -  List of the demonstration examples and their structures
%
%    The Banana Function:               
%       (r)ofun  -  Objective function (with)/without restrictions
%       cont     -  Contour
%
%    The Six Hump Camel Back Function:
%       (r)ofun1 -  Objective function (with)/without restrictions
%       cont1    -  Contour
%
%    Multi-Modal-Function:
%       (r)ofun2 -  Objective function (with)/without restrictions
%       (r)cont2 -  Contour
%                   (Case 1: The starting point is outside of the contour) 
%       (r)ofun21-  Objective function (with)/without restrictions
%       (r)cont21-  Contour
%                   (Case 2: The starting point is inside of the contour)
%    Multi-Objective-Function:
%       (r)ofun3 -  Bi-Objective function (with)/without restrictions
%       (r)cont3 -  Contour
%       ofun5    -  Three-Objective function without restrictions
%       rofun6   -  Osyczka's objective function
%       rofun10  -  Multiobjective Optimization with non-convex feasible region
%
%    Search for a feasible region
%       searchI  -  The I-th search problem
%
%                     
% Display
%    guidisp1    -  Generate the plot handles in the GUI
%    guidisp2    -  Refresh the plot data in the GUI
%    mcwdisp     -  Display the current results in the Matlab Command Window
%    esdialog    -  Dialog to obtained pareto-optimal set
%
% Utilities
%    bestfont    -  Choosing the best font for this computer
%    choice5     -  Generate a windows in the center of the screen.
%    dghelper    -  Help-Text for the window: 'Dialog to Pareto-optimal set'
%    diagscrl    -  Generate a scrollable dialog-window
%    esdoc       -  Routine for loading HTML documentation into a Web browser.
%    esmsg       -  Display message box
%    eshelper    -  Help-Text for the main window of the ES
%    eshlpfun    -  Display a multi-page help texts 
%    essave      -  GUI-based routine to input a file name for saving data
%    fcreate     -  Create new file name if the file exists in the MATLAB-path
%    fgenui      -  GUI for the creating a window to edit the optimization
%                   problem and convert it into the corresponding m-file 
%    funcgen     -  Generate the temporary objective function
%                   to call the given optimization problem
%    getset      -  Get a property and set other one of an figure object
%    grename     -  Open a window to change the file name
%    mat2text    -  Matrix to Text Conversion with a name
%    mrename     -  Change the file name directly from Matlab prompt
%    recpair     -  Generate a matrix of random integer number
%    smat2tex    -  Function to write a string matrix generated by uicontrol
%                   'edit' into a text-file
%    str2nums    -  Convert a string including a sign and decimal number
%                   into a decimal value
%    textent     -  Obtain independent text extent property
%    uh_isin     -  Check if a point is (in)outside of a box
%    uihelpmk    -  Routine to generate text helps for UICONTROL handles
%    vlchoice    -  Open a window to choose the weighting factors of each    
%                   criterium (objective function) or to choose the objective
%                   values for the dialogue with the achieved results
%    what2do     -  Open a dialog window to decide if the old data in a medium
%                   should be cleared or not

% All Rights Reserved
% Author: To Thanh Binh
% IFAT University of Magdeburg
% Germany
% Date: November 1996
