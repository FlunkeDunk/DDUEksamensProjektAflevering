shader_type canvas_item;

uniform bool enabled;
uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 50) = 1.0;
uniform vec4 modulate: source_color = vec4(1);
void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
	outline = round(outline);
	
	vec4 color = texture(TEXTURE, UV);
	if(color.a > 0.5){
		color.a = 1.0;
	} else {
		color.a = 0.0;
	}
	if(enabled){
		vec4 finalColor = mix(color * modulate, line_color, outline - color.a);
		COLOR = finalColor;
	} else{
		COLOR = color * modulate;
	}
		
}