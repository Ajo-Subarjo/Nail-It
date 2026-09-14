shader_type canvas_item;

uniform float saturation : hint_range(0.0, 2.0) = 1.0;

void fragment() {
		vec4 tex = texture(TEXTURE, UV);
		float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
		
		vec3 result = mix(vec3(gray), tex.rgb, saturation);
		COLOR = vec4(result, tex.a);
}
