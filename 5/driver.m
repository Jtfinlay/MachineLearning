load breast_cancer_dataset;
tree = learnDecisionTree(train_set, attribute, 0);
print_tree(tree)

% Training Data
train = zeros(size(train_set(:,1)));
for i=1:size(train_set,1),
   train(i) = classify(tree,train_set(i,:))==train_set(i,end);
end
fprintf('Train: %d / %d\n', sum(train), length(train));

% Testing Data
test = zeros(size(test_set(:,1)));
for i=1:size(test_set,1),
   test(i) = classify(tree,test_set(i,:))==test_set(i,end);
end
fprintf('Test: %d / %d\n', sum(test), length(test));

