shader_type canvas_item;

const int MAX_BULLET_HOLES = 32;

global uniform float bulletHoleSize;
uniform vec2 shotLocations[MAX_BULLET_HOLES];

void fragment()
{
	for (int i = 0; i < MAX_BULLET_HOLES; i++)
	{
		if (length(shotLocations[i] - UV) < bulletHoleSize)
		{
			COLOR.a = 0.0f;
		}
	}
}