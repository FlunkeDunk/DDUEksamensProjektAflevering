shader_type canvas_item;

uniform bool enabled  = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR += float(enabled) * vec4(1.0, 1.0, 1.0, 0.0);
}
