#This script does global game management
extends Node

#Children References
@onready var inRoundState : InRoundState = $InRoundState
@onready var menuingState : MenuingState = $MenuingState

#Game States
var currentState : GameStateBase

func change_state(stateToChange : GameStateBase):
	if currentState != null: #checking each time might be bad - doesnt matter, state doesnt change super often
		currentState.process_mode = Node.ProcessMode.PROCESS_MODE_DISABLED
		currentState.state_exit()
	currentState = stateToChange
	stateToChange.state_enter()
	currentState.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	change_state(menuingState)
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
