class_name MenuingState
extends GameStateBase

func state_enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#Add Menu
	mainRef.mainMenu = (load("res://Menus/Main Menu/main_menu.tscn") as PackedScene).instantiate()
	add_child(mainRef.mainMenu)
	mainRef.mainMenu.roundStarted.connect(mainRef._on_game_start)
	print("Entered Menuing State")

func state_exit() -> void:
	mainRef.mainMenu.queue_free()
	print("Exited Menuing State")

func _process(_delta : float) -> void:
	pass
