shader_type canvas_item;

uniform sampler2D texture_albedo;  // Assign a texture in the Inspector

void fragment() {
    vec4 tex_color = texture(texture_albedo, UV);
    COLOR = tex_color;
}