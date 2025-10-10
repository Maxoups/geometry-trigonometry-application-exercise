shader_type canvas_item;


uniform vec4 original: source_color;
uniform vec4 replace: source_color;

const float precision = 0.2;


vec4 swap_color(vec4 color){
	if (distance(color, original) <= precision){
		return replace;
	}
	return color;
}


void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}