shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod : hint_range(0.0, 5.0) = 0.8;

uniform vec2 hole_center = vec2(0.5, 0.55); // normalized (0 to 1)
uniform vec2 hole_radius = vec2(0.15, 0.2); // ellipse radius (width, height)
uniform float feather = 0.5; // softness of the edge

void fragment() {
    vec2 uv = SCREEN_UV;

    // Sample the screen using mipmaps
    vec4 scene_color = texture(SCREEN_TEXTURE, uv, lod);

    // Convert to ellipse distance
    vec2 delta = (uv - hole_center) / hole_radius;
    float dist = length(delta);

    // Smooth hole edge: inside = 0.0, outside = 1.0
    float alpha = smoothstep(1.0 - feather, 1.0, dist);

    // Dark overlay color (you can tweak this)
    vec4 overlay_color = vec4(0.0, 0.0, 0.0, 0.75);

    // Blend overlay with screen using alpha falloff
    COLOR = mix(scene_color, overlay_color, alpha);
}
