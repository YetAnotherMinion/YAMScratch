%% piecewise_interpolator: function description
function [out_func] = piecewise_interpolator(x_vals, y_vals)
	%we expect the input x_vals to be sorted in increasing order
	B = sort(x_vals)
	assert(all(x_vals == B))
	%vectors should be same
	assert(length(x_vals) == length(y_vals))
	assert(length(x_vals) >= 2)
	minimum = x_vals(1);
	maximum = x_vals(end);

	seven = 6;
	function [out] = segment(target_x)
		if target_x < minimum || target_x > maximum
			throw(MException('Foo:Bar', 'Some human-readable message'))
		end

		out = seven;
	end
	out_func = @segment;

end


