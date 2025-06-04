extern number brightness; // scale 0.3 - 1.0

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texColor = Texel(texture, texture_coords);
    texColor.rgb *= brightness;
    return texColor * color;
}