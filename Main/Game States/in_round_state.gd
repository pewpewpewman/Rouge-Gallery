class_name InRoundState
extends GameStateBase

#Main Scenes
var stage_hud_composite : CanvasLayer
var hud : Hud
var player_character : PlayerCharacter
var stage : Stage

#Instanced Scene
var score_mult_fade : PackedScene = preload("res://Fading Effects/score_mult_fading_effect.tscn")

#General Variables
var total_points : int = 0

func state_enter() -> void:
	#Add Gameplay Elements
	print("Entered Round State")
	stage_hud_composite = (load("res://Main/stage_hud_composite.tscn") as PackedScene).instantiate()
	hud = stage_hud_composite.get_node("./Hud")
	stage = stage_hud_composite.get_node("./SubViewportContainer/StageViewport/Stage")
	player_character = stage_hud_composite.get_node("./PlayerCharacter")
	hud.starting_max_ammo = player_character.max_ammo
	hud.get_node("ScoreCounter").set_text("Score: %d \n Streak: %d" % [total_points, player_character.hit_streak])
	stage.game_over.connect(main_ref._on_game_end)
	GameplaySignals.bullet_used.connect(hud.progress_chamber)
	GameplaySignals.bullet_reloaded.connect(hud.reload_chamber)
	GameplaySignals.object_shot.connect(_on_object_shot)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	add_child(stage_hud_composite)


func state_exit() -> void:
	#Remove Gameplay Elements
	stage.queue_free()
	hud.queue_free()
	player_character.queue_free()
	print("Exited Round State")

func _process(_delta : float) -> void:
	hud.update_timer(stage.round_duration_time.time_left)

func _on_object_shot(object : Node) -> void:
	if object != null && object is BaseTarget:
		var streak_mult = player_character.hit_streak / 5.0
		var pent_mult = 1 + player_character.num_hole_passes
		total_points += object.point_value * streak_mult * pent_mult
		if player_character.hit_streak > 0:
			var fade_effect_streak : ScoreMultFadingEffect = score_mult_fade.instantiate()
			stage.add_child(fade_effect_streak)
			fade_effect_streak.initalize_with_mult_data(player_character.position + Vector2(10, -10), player_character.position + Vector2(100 + randi_range(30, 50), -250), 1.5, streak_mult, ScoreMultFadingEffect.MultTypes.STREAK)
		if player_character.num_hole_passes > 0:
			var fade_effect_pent : ScoreMultFadingEffect = score_mult_fade.instantiate()
			stage.add_child(fade_effect_pent)
			fade_effect_pent.initalize_with_mult_data(player_character.position + Vector2(-10, -10), player_character.position + Vector2(-100 - randi_range(30, 50), -250), 1.5, pent_mult, ScoreMultFadingEffect.MultTypes.PENETRATION)
	hud.get_node("ScoreCounter").call_deferred("set_text", "Score: %d \n Streak: %d" % [total_points, player_character.hit_streak])
