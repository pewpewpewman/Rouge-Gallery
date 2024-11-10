shader_type canvas_item;

const int MAX_BULLET_HOLES = 32;

uniform float bullet_hole_size;
uniform vec2 shot_locations[MAX_BULLET_HOLES];
uniform vec2 image_scale;

void fragment()
{
	for (int i = 0; i < MAX_BULLET_HOLES; i++)
	{
		if (length(image_scale * (shot_locations[i] - UV)) < bullet_hole_size)
		{
			COLOR.a = 0.0f;
		}
	}
}