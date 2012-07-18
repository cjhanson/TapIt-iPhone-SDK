"											\n\
#ifdef GL_ES								\n\
precision lowp float;						\n\
#endif										\n\
\n\
varying vec4 v_fragmentTint;				\n\
varying vec4 v_fragmentColor;				\n\
varying vec2 v_texCoord;					\n\
\n\
uniform sampler2D CC_Texture0;				\n\
\n\
void main()									\n\
{											\n\
//Assumes incoming texture color was premultiplied with alpha											\n\
\n\
//Unmultiply alpha																						\n\
vec3 t_color3	= (texture2D(CC_Texture0, v_texCoord).rgb / texture2D(CC_Texture0, v_texCoord).a);			\n\
\n\
//mix the texture color with our tint color (shades as opaque paint)									\n\
vec3 color		= (t_color3 * (1.0 - v_fragmentTint.a)) + (v_fragmentTint.rgb * v_fragmentTint.a);		\n\
\n\
float alpha	= texture2D(CC_Texture0, v_texCoord).a * v_fragmentColor.a;									\n\
\n\
//multiply alpha																						\n\
gl_FragColor = vec4((color * v_fragmentColor.rgb)*alpha, alpha);										\n\
}																										\n\
";