class_name InRoundState
extends GameStateBase

#Main Scenes
var stageHudComposite : CanvasLayer
var hud : Hud
var playerCharacter : PlayerCharacter
var stage : Stage

#General Variables
var totalPoints : int = 0

func state_enter() -> void:
	#Add Gameplay Elements
	stageHudComposite = (load("res://Main/StageHudComposite.tscn") as PackedScene).instantiate()
	add_child(stageHudComposite)
	hud = stageHudComposite.get_node("./Hud")
	stage = stageHudComposite.get_node("./SubViewportContainer/StageViewport/Stage")
	playerCharacter = stageHudComposite.get_node("./PlayerCharacter")
	hud.startingMaxAmmo = playerCharacter.maxAmmo
	
	stage.game_over.connect(mainRef._on_game_end)
	GameplaySignals.bullet_used.connect(hud.progress_chamber)
	GameplaySignals.bullet_reloaded.connect(hud.reload_chamber)
	GameplaySignals.target_shot.connect(_on_target_shot)
	print("Entered Round State")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func state_exit() -> void:
	#Remove Gameplay Elements
	stage.queue_free()
	hud.queue_free()
	playerCharacter.queue_free()
	print("Exited Round State")

func _process(_delta : float) -> void:
	pass
	hud.update_timer(stage.roundDurationTime.time_left)

func _on_target_shot(target : BaseTarget) -> void:
	totalPoints += target.pointValue
	hud.get_node("ScoreCounter").set_text("Score: %d" % totalPoints)
