shader_type canvas_item;

uniform float shield_intensity: hint_range(0, 1) = 0.5;
uniform vec4 shield_color = vec4(0.0, 0.5, 1.0, 1.0);
uniform float shield_border : hint_range(0, 1) = 0.1;
uniform float shield_fade : hint_range(0, 1) = 0.5;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    
    float dist_to_center = distance(UV, vec2(0.5));
    float mask = smoothstep(shield_border, shield_border - shield_fade, dist_to_center);
    
    base_color.rgb = mix(base_color.rgb, shield_color.rgb, shield_intensity * base_color.a);
    base_color.a *= mask;

    COLOR = base_color;
}