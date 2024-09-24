class_name MainMenu
extends Control

#Children References
@onready var playButton: Button = $PlayButton
@onready var optionsButton: Button = $OptionsButton
@onready var highScoresButton: Button = $HighScoresButton
@onready var creditsButton: Button = $CreditsButton
@onready var quitButton: Button = $QuitButton


#Sub Menus
var options : Control = preload("res://Menus/Main Menu/options_menu.tscn").instantiate()
var quit : Control = preload("res://Menus/Main Menu/quit_screen.tscn").instantiate()
var roundSetup: Control = preload("res://Menus/Main Menu/round_setup.tscn").instantiate()
var highScores : Control = preload("res://Menus/Main Menu/high_scores_menu.tscn").instantiate()

#Signal for main to respond to the round starting
signal roundStarted

func _ready() -> void:
	playButton.pressed.connect(on_play_pressed)
	optionsButton.pressed.connect(on_options_pressed)
	highScoresButton.pressed.connect(on_high_scores_pressed)
	creditsButton.pressed.connect(on_credits_pressed)
	quitButton.pressed.connect(on_quit_pressed)

func on_play_pressed() -> void:
	roundStarted.emit()
	print("play pressed")
	
func on_options_pressed() -> void:
	print("options pressed")

func on_high_scores_pressed() -> void:
	print("high scores pressed")

func on_quit_pressed() -> void:
	print("quit pressed")

func on_credits_pressed() -> void:
	print("credits pressed")
