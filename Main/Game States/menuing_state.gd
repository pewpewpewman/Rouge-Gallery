class_name MenuingState
extends GameStateBase

#Menus
var sub_menu_picker : PackedScene = preload("res://Menus/Main Menu/sub_menu_select.tscn")
var options_menu_scene : PackedScene = preload("res://Menus/Main Menu/options_menu.tscn")
var high_score_menu_scene : PackedScene = preload("res://Menus/Main Menu/high_scores_menu.tscn")
var quit_screen_scene : PackedScene = preload("res://Menus/Main Menu/quit_screen.tscn")
var round_setup_scene : PackedScene = preload("res://Menus/Main Menu/round_setup.tscn")
var credits_scene : PackedScene = preload("res://Menus/Main Menu/credits_screen.tscn")

var current_menu : Control

signal start_round

func state_enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_on_sub_menu()
	start_round.connect(main_ref._on_game_start)
	#print("Entered Menuing State")

func state_exit() -> void:
	if current_menu != null:
		current_menu.queue_free()
	#print("Exited Menuing State")

##MENU CONNECTION FUNCS##
func _on_sub_menu() -> void:
	if current_menu != null: 
		current_menu.queue_free()
	current_menu = sub_menu_picker.instantiate()
	current_menu.get_node("OptionsButton").pressed.connect(_on_options)
	current_menu.get_node("HighScoresButton").pressed.connect(_on_high_score)
	current_menu.get_node("QuitButton").pressed.connect(_on_quit)
	current_menu.get_node("PlayButton").pressed.connect(_on_round_setup)
	current_menu.get_node("CreditsButton").pressed.connect(_on_credits)
	add_child(current_menu)

func _on_options() -> void:
	if current_menu != null: 
		current_menu.queue_free()
	current_menu = options_menu_scene.instantiate()
	current_menu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
	add_child(current_menu)

func _on_high_score() -> void:
	if current_menu != null:
		current_menu.queue_free()
	current_menu = high_score_menu_scene.instantiate()
	current_menu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
	add_child(current_menu)

func _on_quit() -> void:
	if current_menu != null:
		current_menu.queue_free()
	current_menu = quit_screen_scene.instantiate()
	add_child(current_menu)
	current_menu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
	current_menu.get_node("QuitGame").pressed.connect(get_tree().quit)

func _on_round_setup() -> void:
	if current_menu != null:
		current_menu.queue_free()
	current_menu = round_setup_scene.instantiate()
	add_child(current_menu)
	current_menu.get_node("StartRound").pressed.connect(start_round.emit)
	current_menu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)

func _on_credits() -> void:
	if current_menu != null:
		current_menu.queue_free()
	current_menu = credits_scene.instantiate()
	add_child(current_menu)
	current_menu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
