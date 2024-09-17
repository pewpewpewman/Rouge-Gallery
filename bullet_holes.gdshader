shader_type canvas_item;

const int MAX_BULLET_HOLES = 32;

uniform float bulletHoleSize;
uniform vec2 shotLocations[MAX_BULLET_HOLES];
uniform vec2 imageScale;

void fragment()
{
	for (int i = 0; i < MAX_BULLET_HOLES; i++)
	{
		if (length(imageScale * (shotLocations[i] - UV)) < bulletHoleSize)
		{
			COLOR.a = 0.0f;
		}
	}
}