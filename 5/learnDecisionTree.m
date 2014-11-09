%% learnDecisionTree
% The algorithm for this code was outlined in the lecture notes:
%       https://eclass.srv.ualberta.ca/pluginfile.php/1612285/mod_resource/content/3/6a-DecisionTree.pdf
% on slide number 30. 
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
% 
% Outputs:
%       tree                - Decision Tree


function tree = learnDecisionTree(examples, attribute, default)

    %% Here's a helpful structure for creating a tree in MATLAB
    %  Each node in the tree is struct with five fields. 
    %         'attribute'   - integer id of the attribute we split on
    %         'isleaf'      - is 'true' if the node is a leaf 
    %                         and 'false' otherwise
    %         'class'       - is 'null' if the node is not a leaf. 
    %                         If node is a leaf, class= '0' or '1'
    %         'children'    - Is 'null' if the node is a leaf. 
    %                         Otherwise, it is a cell {} where 
    %                         tree.children{i} is  the subtree when the 
    %                         tree.attribute takes on value tree.value(i).
    %                         Is 'null' if the node is a leaf.
    %         'value'       - a vector of values that the attribute can
    %                         take. Is 'null' if the node is a leaf.
    %         'num_1'       - The number of training examples in class = 1
    %                         at the node.
    %         'num_0'       - The number of training examples in class = 0
    %                         at the node.
    %         'num_tot'     - The total number of training examples at the
    %                         node.
    %
    %  Example (non-leaf node):
    % 
    %     attribute: [1x1 struct]
    %        isleaf: 0
    %         class: 'null'
    %      children: {1x10 cell}
    %         value: [1 2 3 4 5 6 7 8 9 10]
    %         num_1: 43
    %         num_0: 2
    %       num_tot: 45
    %         
    %  
    %  Example (leaf node):
    %  
    %     attribute: 'null'
    %        isleaf: 1
    %         class: '0'
    %      children: 'null'
    %         value: 'null'
    %         num_1: 43
    %         num_0: 2
    %       num_tot: 45
    
    tree = struct('attribute','null',...
                  'isleaf','null',...
                  'class',default,...
                  'children','null',...
                  'value','null',...
                  'num_1',-1,...
                  'num_0',-1,...
                  'num_tot',-1);             

    % If there are no examples to classify, return
    num_examples = size(examples(:,end),1);
    if num_examples == 0
      return
    end
    
    %% 1.) If all examples have the same classification, create a 
    %      tree leaf node with that classification and return
    class_labels = examples(:,end);
    if (size(unique(class_labels),1) == 1),
        tree.isleaf = 1;
        tree.class = unique(class_labels);
        tree.num_0 = (tree.class==0)*num_examples;
        tree.num_1 = (tree.class==1)*num_examples;
        tree.num_tot = num_examples;
        return
    end
        
    %% 2.) If attributes is empty, create a leaf node with the
    %      majority classification and return.
    
    if size(examples',1) <= 1,
        tree.isleaf = 1;
        tree.class = (sum(class_labels)>(size(examples,1)/2))*1; % majority
        tree.num_0 = size(class_labels,1)-sum(class_labels);
        tree.num_1 = sum(class_labels);
        tree.num_tot = size(class_labels,1);
        return
    end
       
    %% 3.) Find the best attribute -- the attribute with the highest information gain
    % 
    gains = zeros(size(examples(1,:))-1);
    for j=1:size(gains',1),
        gains(j) = gain(j, unique(examples(:,j)), examples);
    end
    best = max(gains);
    
    %% 4.) Make a non-leaf tree node with root 'best'
    % 
    tree.attribute = attribute(find(gains==best));
    tree.isleaf = 0;
    tree.value = tree.attribute.value;
    tree.num_0 = size(class_labels,1)-sum(class_labels);
    tree.num_1 = sum(class_labels);
    tree.num_tot = size(class_labels,1);
    
    
    %% 5.) For each value v_i that the best attribute can take, do the following:
    %     a.) examples_i <-- elements of examples where the best attribute has value v_i
    %     b.) subtree <-- recursive call to learnDecisionTree with inputs:
    %              examples_i
    %              all attributes but the best
    %              the majority value of the examples
    %     c.) add branch to tree with label vi and subtree
    %tree.children = zeros(size(unique(examples(:,tree.attribute))),1);
    tmp(size(tree.attribute.value),1) = struct;
    tree.children = tmp;
    for j=1:size(size(tree.attribute.value)),
        value = tree.attribute.value(j);
        value_rows = find(examples(:,find(gains==best))==value);
        examples_i = examples(value_rows,:);
        examples_i(:,(gains==best)) = [];
        
        tree.children(j) = learnDecisionTree(examples_i, attribute, default);
    end
 
    return
end

%% You may wish to write a function that...
%  Computes the information gain of the i-th attribute when given:
%        i                - the id of the attribute
%        attribute_vals   - the vector of possible values that attribute
%                           can take
%        examples         - the set of examples on which you'll compute
%                           the information gain
%% 
function value = gain(i, attribute_vals, examples)

    attribute = examples(:,i);
    classes = examples(:,end);
    
    value = 0;
    for j=1:size(attribute_vals),
       rows = find(attribute==attribute_vals(j));
       en = entropy(sum(classes(rows)), size(classes(rows),1)-sum(classes(rows)));
       value += en*size(rows,1)/size(classes,1);
    end
    %value *= -1;
end

%% You may wish to have an entropy function that...
%  Computes entropy when given:
%        p               - the number of class = 1 examples
%        n               - the number of class = 0 examples
%%
function en = entropy(p,n)

    p1 = p/(p+n);
    p2 = n/(p+n);

    en = -(p1.*log2(p1)+p2.*log2(p2));

end
