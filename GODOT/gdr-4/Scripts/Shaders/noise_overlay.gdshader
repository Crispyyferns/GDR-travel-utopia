shader_type canvas_item;

uniform float time;
uniform float intensity = 1.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

float rand(vec2 co) {
	return fract(sin(dot(co.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = SCREEN_UV * vec2(128.0);
	float noise = rand(uv + time * 10.0);
	vec3 noise_color = vec3(noise) * intensity;
	COLOR = vec4(noise_color, opacity);
}
