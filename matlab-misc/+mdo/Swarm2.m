clear
clc
close all

L = 10;
result = [];

a = -log(1- 10^(-L));

reductions = [1:0.2:L-1];

for k = reductions
	b = -log(1- 10^(-L+k));;
	result(end+1) = (b - a) /a;
end

semilogy(reductions, result, 'bd-')
figure

score = []
for index = 1:length(reductions)
	k = reductions(index)
	score(end+1) =  -log(1-10^(-L+k)) / (result(index) + 1);
end
semilogy(reductions, score, 'bd-')

disp('done')
