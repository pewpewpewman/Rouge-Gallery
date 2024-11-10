class_name ScoreMultFadingEffect
extends FadingEffect

@onready var sprite_series : HBoxContainer = $SpriteSeries

enum MultTypes
{
	PENETRATION,
	STREAK
}

func initalize_with_mult_data(start_pos : Vector2, end_pos : Vector2, anim_length : float, number : float, type : MultTypes):
	super.initalize(start_pos, end_pos, anim_length)
	$SpriteSeries/Ones.texture.region.position.x = 100 * (floori(number))
	$SpriteSeries/Tenths.texture.region.position.x = 100 * (floori((number * 10)) % 10)
	$SpriteSeries/Hundredths.texture.region.position.x = 100 * (floori((number * 100)) % 100)
	
	sprite_series.position += 0.5 * -sprite_series.size
	
	match type:
		MultTypes.PENETRATION:
			$SpriteSeries/Type.texture = load("res://Fading Effects/penetration.png")
		MultTypes.STREAK:
			$SpriteSeries/Type.texture = load("res://Fading Effects/streak.png")
		_:
			printerr("Score mult fade needs valid score mult type")
