class_name TargetStand
extends PathFollow2D

var tween : Tween
var lifetime : float

func _ready() -> void:
	if (get_parent() is Path2D):
		assert(lifetime != 0, "Target stand lifetime must be set before creation")
	tween = create_tween()
	tween.tween_property(self, "progress_ratio", 1, lifetime)
	#tween.finished.connect(queue_free)
