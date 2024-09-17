#This script does global game management
extends Node

#Children References
@onready var HUD : Control = $Hud

#General Variables
var totalPoints : int = 0

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	#var mainMenuScene : Control = (load("res://Menus/main_menu.tscn") as PackedScene).instantiate()
	#add_child(mainMenuScene)
	GameplaySignals.target_shot.connect(_on_target_shot)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("fullscreen_game"):
			var windowState : bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			if windowState:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _process(delta: float) -> void:
	pass

func _on_target_shot(target : BaseTarget) -> void:
	totalPoints += target.pointValue
	HUD.get_node("ScoreCounter").set_text("Score: %d" % totalPoints)
