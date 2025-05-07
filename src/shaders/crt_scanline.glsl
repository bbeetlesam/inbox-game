extern float scanlineIntensity;
extern float resolution;

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
    float y = mod(screenCoords.y, 5.0);
    float line = mix(1.0, scanlineIntensity, y);

    vec4 pixel = Texel(texture, texCoords);
    return mix(pixel, pixel * line, 0.5) * color;
}
