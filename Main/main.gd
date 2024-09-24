#This script does global game management
extends Node

#Children References
@onready var inRoundState : InRoundState = $InRoundState
@onready var menuingState : MenuingState = $MenuingState

#Main Scenes
var hud : Hud
var playerCharacter : PlayerCharacter
var stage : Stage
var mainMenu : MainMenu = (preload("res://Menus/Main Menu/main_menu.tscn") as PackedScene).instantiate()

#Game States
var currentState : GameStateBase

#General Variables
var totalPoints : int = 0

func change_state(stateToChange : GameStateBase):
	if currentState != null: #checking each time might be bad - doesnt matter, state doesnt change super often
		currentState.process_mode = Node.ProcessMode.PROCESS_MODE_DISABLED
		currentState.state_exit()
	currentState = stateToChange
	stateToChange.state_enter()
	currentState.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	change_state(menuingState)
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

func _on_game_start() -> void:
	change_state(inRoundState)

func _on_game_end() -> void:
	change_state(menuingState)

func _process(_delta: float) -> void:
	pass

func _on_target_shot(target : BaseTarget) -> void:
	totalPoints += target.pointValue
	hud.get_node("ScoreCounter").set_text("Score: %d" % totalPoints)
