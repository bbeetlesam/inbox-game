extern number strength;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = texture_coords * 2.0 - 1.0;
    vec2 offset = uv * length(uv) * strength; // barrel distortion magic
    uv += offset;
    uv = (uv + 1.0) / 2.0;

    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
        return vec4(0.0);

    return Texel(tex, uv) * color;
}