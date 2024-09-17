extends Control

#Children References
@onready var playButton : TextureButton = $PlayButton

func _ready():
	playButton.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	print("game starts woo!")

func _go_to_main_menu():
	pass
