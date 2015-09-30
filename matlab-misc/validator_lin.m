clear
clc
%K is the length of the password, must by divisible by 2
K = 500;
assert(mod(K, 2) == 0);
assert(K >= 10);
MODULUS = 255;

%these are the character values possible
POSSIBLE_VALS = [65:90, 97:122];

%there are only 6 bytes determined in output
A = zeros(6, K);
%reduced rank solution vector
b = zeros(6, 1);

%two are left half checksum
b(1,1) = 110; %byte a == 0x6e
b(2,1) = 208; %byte b == 0xd0
%these two rows every even checksum
%ATTENTION, order of these are swapped
b(3,1) = 0; %byte a == 0x00
b(4,1) = 0; %byte b == 0x00

%next two are right half checksum
b(5,1) = 13; % byte a = 0x0d
b(6,1) = 240; %byte b = 0xf0

%instatiate the matrix
for ii = 1:(K/2)
	%left size check sum
	A(2,ii) = K/2 - ii + 1;
	A(1,ii) = 1;
	%even bytes checksum
	A(3, ii*2 - 1) = 1;
	A(4, ii*2 - 1) = K/2 - ii + 1;


	%right half checksum
	A(6,ii+(K/2)) = K/2 - ii + 1;
	A(5, ii+(K/2)) = 1;
end

disp(A) 
%% some tests that the matrix is of same form as checksum

%test for 100 random passwords
tic
for ii = 1:10000
	% draw some random indices from the range
	r = randi([1, length(POSSIBLE_VALS)], 1, K);
	%get the indices and generate the password
	pass_1 = POSSIBLE_VALS(r);

	even_1 = pass_1([1:2:length(pass_1)]);
	left_1 = pass_1(1:(K/2));
	right_1 = pass_1((K/2)+1:K);

	[left_A_1, left_B_1] = challenge_checksum(left_1, MODULUS);
	[right_A_1, right_B_1] = challenge_checksum(right_1, MODULUS);
	[even_A_1, even_B_1] = challenge_checksum(even_1, MODULUS);
	%assemble into the same form as the matrix rows are arranged
	cksum_B = [left_A_1, left_B_1, even_A_1, even_B_1, right_A_1, right_B_1].';

	guess_B = mod(A * pass_1.', MODULUS);
	assert( isequal(guess_B, cksum_B ))
end
toc
disp('Matrix is equivalent to checksums')


%NOTE, now we just solve this using gauss elimination on Z_bar(255) (finite field)
augmented = A;
augmented(:,K+1)  = b(:,1)

for ii = 1:6
	disp(ii)
	first_index = find(augmented(ii,:));
	if augmented(ii, first_index(1)) ~= 1
		first_elm = augmented(ii,first_index(1));
		[d,u,v] = gcd(first_elm, MODULUS);
		% if d != 1 then modular inverse does not exist
		if d ~= 1
			error('Modular inverse does not exist')
		end
		tmp_rw = augmented(ii,:) * u;
		tmp_rw = mod(tmp_rw, MODULUS);
		augmented(ii, :) = tmp_rw(:)
	end
	if ii < 6
		%sweep down
		for jj = (ii+1):6
			first_elm = augmented(jj, first_index(1));
			tmp_rw = augmented(jj,:) - first_elm * augmented(ii,:);
			tmp_rw = mod(tmp_rw, MODULUS);
			augmented(jj,:) = tmp_rw(:);
		end
	end

end
disp('========================')
%sweep back on the lower rows
for jj = 6:-1:2
	first_index = find(augmented(jj,:));
	for ii = (jj-1): -1 : 1
		if augmented(ii, first_index(1)) ~= 0
			%do R_ii
			first_elm = augmented(ii, first_index(1));
			tmp_rw = augmented(ii,:) - first_elm*augmented(jj,:);
			tmp_rw = mod(tmp_rw, MODULUS);
			augmented(ii,:) = tmp_rw(:);

		else
			disp('skipping row')
		end
	end
end

%%extract the reduced matrix and test that it is equivalent to the check sum



%compute with letters are determined by the others
% the determined letters are the columns with a leading 1
determined_letter_index = zeros(1,6);
for ii = 1:6
	first_index = find(augmented(ii,:));
	determined_letter_index(ii) = first_index(1);
end

all_indices = 1:K;

undetermined_indices = setdiff(all_indices, determined_letter_index);


%collect all of the undetermined indices into one matrix 
% then we generate several thousand random guesses and check
% that the system is equivalent to the checksum

D = augmented(:,undetermined_indices)
Target = augmented(:, end);
tic
possible_solution = [];
disp('Starting reduced matrix validation')
for ii = 1:100000
	% draw some random indices from the range
	r = randi([1, length(POSSIBLE_VALS)], 1, length(undetermined_indices));
	independent_vals  = POSSIBLE_VALS(r);
	dependent_vals = mod(Target - (D * independent_vals.'), MODULUS);
	pass_1 = zeros(1, K);
	pass_1(determined_letter_index) = dependent_vals(:);
	pass_1(undetermined_indices) = independent_vals(:);
	%get the indices and generate the password
	%we only actually need to check the dependent values
	validator_outer = dependent_vals(dependent_vals>=65&dependent_vals<=122);
	validator_inner = validator_outer(validator_outer>90&validator_outer<97);
	%there are only 6 free characters
	if(length(validator_outer) == 6)
		if(length(validator_inner) == 0)
			disp('========\====|=====/==')
			disp('======\==\=|=|==/=/===')
			disp('==---You Found it---==')
			disp('=====/===/==|\==\=====')
			disp('====/===/===|=\==\====')
			disp('')
			possible_solution(end+1,:) = pass_1(:);
		end
	end
	
	guess_hash = mod(A * pass_1.', MODULUS);
	assert( isequal(guess_hash, b));

end
toc
disp('Reduced Matrix generates desired checksum')

disp('Valid Passwords:')
disp('====================')
[r,c] = size(possible_solution);
for ii = 1:r
	disp(char(possible_solution(ii,:)))
end
