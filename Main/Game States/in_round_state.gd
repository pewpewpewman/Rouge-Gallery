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
	print("Entered Round State")
	stageHudComposite = (load("res://Main/StageHudComposite.tscn") as PackedScene).instantiate()
	hud = stageHudComposite.get_node("./Hud")
	stage = stageHudComposite.get_node("./SubViewportContainer/StageViewport/Stage")
	playerCharacter = stageHudComposite.get_node("./PlayerCharacter")
	hud.startingMaxAmmo = playerCharacter.maxAmmo
	
	stage.game_over.connect(mainRef._on_game_end)
	GameplaySignals.bullet_used.connect(hud.progress_chamber)
	GameplaySignals.bullet_reloaded.connect(hud.reload_chamber)
	GameplaySignals.target_shot.connect(_on_target_shot)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	add_child(stageHudComposite)


func state_exit() -> void:
	#Remove Gameplay Elements
	stage.queue_free()
	hud.queue_free()
	playerCharacter.queue_free()
	print("Exited Round State")

func _process(_delta : float) -> void:
	hud.update_timer(stage.roundDurationTime.time_left)

func _on_target_shot(target : BaseTarget) -> void:
	totalPoints += target.pointValue * (1 + playerCharacter.numHolePasses)
	hud.get_node("ScoreCounter").set_text("Score: %d" % totalPoints)
