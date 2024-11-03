class_name MenuingState
extends GameStateBase

#Menus
var subMenuPickerScene : PackedScene = preload("res://Menus/Main Menu/sub_menu_select.tscn")
var optionsMenuScene : PackedScene = preload("res://Menus/Main Menu/options_menu.tscn")
var highScoreMenuScene : PackedScene = preload("res://Menus/Main Menu/high_scores_menu.tscn")
var quitScreenScene : PackedScene = preload("res://Menus/Main Menu/quit_screen.tscn")
var roundSetupScene : PackedScene = preload("res://Menus/Main Menu/round_setup.tscn")
var creditsScene : PackedScene = preload("res://Menus/Main Menu/credits_screen.tscn")

var currentMenu : Control

signal start_round

func state_enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_on_sub_menu()
	start_round.connect(mainRef._on_game_start)
	print("Entered Menuing State")

func state_exit() -> void:
	if currentMenu != null:
		currentMenu.queue_free()
	print("Exited Menuing State")

func _process(_delta : float) -> void:
	pass

##MENU CONNECTION FUNCS##
func _on_sub_menu() -> void:
	if currentMenu != null: 
		currentMenu.queue_free()
	currentMenu = subMenuPickerScene.instantiate()
	currentMenu.get_node("OptionsButton").pressed.connect(_on_options)
	currentMenu.get_node("HighScoresButton").pressed.connect(_on_high_score)
	currentMenu.get_node("QuitButton").pressed.connect(_on_quit)
	currentMenu.get_node("PlayButton").pressed.connect(_on_round_setup)
	currentMenu.get_node("CreditsButton").pressed.connect(_on_credits)
	add_child(currentMenu)

func _on_options() -> void:
	if currentMenu != null: 
		currentMenu.queue_free()
	currentMenu = optionsMenuScene.instantiate()
	currentMenu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
	add_child(currentMenu)

func _on_high_score() -> void:
	if currentMenu != null:
		currentMenu.queue_free()
	currentMenu = highScoreMenuScene.instantiate()
	currentMenu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
	add_child(currentMenu)

func _on_quit() -> void:
	if currentMenu != null:
		currentMenu.queue_free()
	currentMenu = quitScreenScene.instantiate()
	add_child(currentMenu)
	currentMenu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
	currentMenu.get_node("QuitGame").pressed.connect(func () : get_tree().quit())

func _on_round_setup() -> void:
	if currentMenu != null:
		currentMenu.queue_free()
	currentMenu = roundSetupScene.instantiate()
	add_child(currentMenu)
	var startRoundEmit : Callable = func start_round_emit() -> void:
		start_round.emit()
	currentMenu.get_node("StartRound").pressed.connect(startRoundEmit)
	currentMenu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)

func _on_credits() -> void:
	if currentMenu != null:
		currentMenu.queue_free()
	currentMenu = creditsScene.instantiate()
	add_child(currentMenu)
	currentMenu.get_node("ReturnToMain").pressed.connect(_on_sub_menu)
