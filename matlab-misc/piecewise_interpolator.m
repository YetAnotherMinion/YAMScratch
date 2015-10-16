%% piecewise_interpolator: function description
function [out_func] = piecewise_interpolator(x_vals, y_vals)
	%we expect the input x_vals to be sorted in increasing order
	B = sort(x_vals);
	assert(all(x_vals == B))
	%vectors should be same
	assert(length(x_vals) == length(y_vals))
	assert(length(x_vals) >= 2)
	minimum = x_vals(1);
	maximum = x_vals(end);

	seven = 6;
	function [out] = segment(target_x)
		%only makes physical sense for a scalar
		assert(isscalar(target_x))
		if target_x < minimum || target_x > maximum
			throw(MException('Interpolator:RangeError', 'Value not within interpolating range'))
		end
		%trivial cases
		if target_x == minimum
			out = y_vals(1);
			return
		elseif target_x == maximum
			out = y_vals(end);
			return
		end
		i_right = find(x_vals>target_x, 1);
		i_left = find(x_vals<target_x);
		i_left = i_left(end); %take the furthest right one that is less than
		out = ( (y_vals(i_right) - y_vals(i_left)) * (target_x - x_vals(i_left)) / ...
				(x_vals(i_right) - x_vals(i_left)) ) + y_vals(i_left);
	end
	out_func = @segment;

end


