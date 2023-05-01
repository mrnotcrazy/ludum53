shader_type canvas_item;

uniform float star_count : hint_range(0, 1000) = 300;
uniform vec4 viewport_bounds = vec4(0, 0, 1152, 648);
uniform float min_star_size : hint_range(0, 2) = 0.5;
uniform float max_star_size : hint_range(0, 10) = 3;
uniform float upward_speed : hint_range(-100, 100) = -10.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_pos = uv * (viewport_bounds.zw - viewport_bounds.xy) + viewport_bounds.xy;
    float seed = 0.0;
    
    for (int i = 0; i < 3; i++) {
        seed += sin(float(i) * 4567.0);
    }

    float total_intensity = 0.0;

    for (int i = 0; i < int(star_count); i++) {
        vec2 star_pos = vec2(fract(sin(seed + float(i) * 789.0) * 43758.0), fract(cos(seed + float(i) * 987.0) * 54785.0 + TIME * upward_speed / viewport_bounds.w));
        float dist = distance(screen_pos, star_pos * (viewport_bounds.zw - viewport_bounds.xy) + viewport_bounds.xy);
        float size = mix(min_star_size, max_star_size, fract(sin(seed + float(i) * 321.0) * 41563.0));
        float intensity = smoothstep(size, 0.0, dist);
        total_intensity += intensity;
    }
    
    COLOR = vec4(vec3(total_intensity), 1.0);
}
