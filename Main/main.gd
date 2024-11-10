#This script does global game management
extends Node

#Children References
@onready var in_round_state : InRoundState = $InRoundState
@onready var menuing_state : MenuingState = $MenuingState

#Game States
var current_state : GameStateBase

func change_state(stateToChange : GameStateBase):
	if current_state != null: #checking each time might be bad - doesnt matter, state doesnt change super often
		current_state.process_mode = Node.ProcessMode.PROCESS_MODE_DISABLED
		current_state.state_exit()
	current_state = stateToChange
	stateToChange.state_enter()
	current_state.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	change_state(menuing_state)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("fullscreen_game"):
			var window_state : bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			if window_state:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_game_start() -> void:
	change_state(in_round_state)

func _on_game_end() -> void:
	change_state(menuing_state)

func _process(_delta: float) -> void:
	pass
