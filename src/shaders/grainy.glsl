extern number time;
extern number strength;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    float grain = fract(sin(dot(screenCoord.xy + time, vec2(12.9898,78.233))) * 43758.5453);
    grain = (grain - 0.5) * strength;

    vec4 pixel = Texel(tex, texCoord);
    pixel.rgb += grain;
    return pixel * color;
}