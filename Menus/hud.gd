class_name Hud
extends Control

#Children References
@onready var debugInfo : Label = $DebugInfo

#Timer Element Vars
@onready var timer : Control = $Timer
@onready var minTexRef : TextureRect = $Timer/Minute
@onready var secTensTexRef : TextureRect = $Timer/SecondTens
@onready var secOnesTexRef : TextureRect = $Timer/SecondOnes
@onready var numSpriteWidth : int = minTexRef.texture.atlas.get_width() / 10

var test : float = 0.0

func _ready() -> void:
	update_timer(134)

func _process(_delta: float) -> void:
	debugInfo.set_text("FPS %d" % Engine.get_frames_per_second())

func update_timer(time: float):
	#input is total seconds
	var minutes : int = floori(time / 60.0)
	var seconds : float = time - minutes * 60.0
	var secondTens : int = floori(seconds / 10.0)
	var secondsOnes = floori(seconds) % 10
	
	if (minutes > 9):
		printerr("WARNING: More than 9 minutes is not currently supported for HUD")
	
	minTexRef.texture.region.position.x = minutes * numSpriteWidth
	secTensTexRef.texture.region.position.x = secondTens * numSpriteWidth
	secOnesTexRef.texture.region.position.x = secondsOnes * numSpriteWidth
