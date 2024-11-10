class_name FadingEffect
extends Node2D

func initalize(start_pos : Vector2, end_pos : Vector2, anim_length : float):
	position = start_pos
	var pos_tween : Tween = get_tree().create_tween()
	var trans_tween : Tween = get_tree().create_tween()
	rotation = position.angle_to_point(end_pos) + PI / 2.0
	pos_tween.tween_property(self, "position", end_pos, anim_length)
	trans_tween.tween_property(self, "modulate", Color(modulate, 0.0), anim_length)
	trans_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	pos_tween.finished.connect(self.queue_free)
