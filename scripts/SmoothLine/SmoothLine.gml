/**
 * A line equation that infers y from x, or x from y depending on the angle.
 * @param {real} _angle
 * @param {real} _delta
 */
function SmoothLine(_angle, _delta) constructor {
	// @ignore
	angle = _angle;
	// @ignore
	delta = _delta;
	
	/**
	 * @param {real} _angle
	 * @param {real} _delta
	 * @ignore
	 */
	set = function(_angle, _delta) {
		angle = get_cleaned_angle(_angle);
		delta = _delta;
	};
	
	/**
	 * Returns if y is inferred from x, or x is inferred from y.
	 *
	 * @ignore
	 */
	infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
	/**
	 * Get the x magnitude given the current angle and delta.
	 *
	 * @ignore
	 */
	get_magnitude_x = function() {
		return snap_cos(angle) * delta;
	};
	
	/**
	 * Get the y magnitude given the current angle and delta.
	 *
	 * @ignore
	 */
	get_magnitude_y = function() {
		return snap_sin(angle) * delta;
	};
	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 *
	 * @ignore
	 */
	slope = function() {
		if (delta == 0) return 0;
		return infer_y_from_x() ? get_magnitude_y() / get_magnitude_x() : get_magnitude_x() / get_magnitude_y();
	}
	
	// @ignore
	get_copy = function() {
		return new SmoothLine(angle, delta);
	};
	
	/**
	 * @param {real} _start_x
	 * @param {real} _start_y
	 */
	get_x = function(_start_x, _start_y) {
		if (delta == 0) return _start_x;
		if (infer_y_from_x()) {
			var _x = round_to_correct(_start_x + get_magnitude_x());
			return round_towards(_x, _start_x);
		}
		
		// derive x position from linear line function of y
		var _y_diff = get_y() - _start_y;
		var _x = round_to_thousandths(slope() * _y_diff + _start_x);
		return round_towards(_x, _start_x);
	};
}