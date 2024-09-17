extends Control

#Children References
@onready var DebugInfo : Label = $DebugInfo

func _process(delta: float) -> void:
	DebugInfo.set_text("FPS %d" % Engine.get_frames_per_second())
