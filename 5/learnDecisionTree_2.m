%% learnDecisionTree_2
% 
% Inputs: 
%       examples            - set of examples [X1, ..., Xn,Class]
%       attribute           - attribute descriptions
%                             an [n x 1] vector of structs with fields: 
%                                   'id'    - a unique id number
%                                   'name'  - human understandable name of attribute
%                                   'value' - possible attribute values
%
%                             Example: attribute(1) = 
%                                      id: 1
%                                      name: 'Clump Thickness'
%                                      value: [1 2 3 4 5 6 7 8 9 10]
%        depth              - The maximum depth of the tree
% 
% Outputs:
%       tree                - Decision Tree


function tree = learnDecisionTree(examples, attribute, default, depth)

end