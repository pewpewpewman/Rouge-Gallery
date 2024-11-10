class_name Hud
extends Control

#Children References
@onready var debug_info : Label = $DebugInfo
@onready var ammo_indicator: TextureRect = $AmmoIndicator

#Assets
var unusued_round_text : Texture2D = preload("res://Menus/Hud Assets/unused_round.png")
var used_round_text : Texture2D = preload("res://Menus/Hud Assets/used_round.png")
var bullet_indicator_scene : PackedScene = preload("res://Menus/bullet_indicator.tscn")

#Timer Element Vars	
@onready var timer : Control = $Timer
@onready var min_text_ref : TextureRect =$Timer/Minute
@onready var sec_tens_tex_ref : TextureRect = $Timer/SecondTens
@onready var sec_ones_tex_ref : TextureRect = $Timer/SecondOnes
@onready var num_sprite_width : int = min_text_ref.texture.atlas.get_width() / 10

#Other Vars
var starting_max_ammo : int = 0

func _ready() -> void:
	if starting_max_ammo <= 0:
		printerr("HUD was not correctly given max starting ammo! (Or starting ammo is less than one in which case wtf is wrong with you???)")
	update_max_ammo(starting_max_ammo)

func _process(_delta : float) -> void:
	debug_info.set_text("FPS %d" % Engine.get_frames_per_second())
	#ammo_indicator.rotation += delta

func update_timer(time: float) -> void:
	#input is total seconds
	var minutes : int = floori(time / 60.0)
	var seconds : float = time - minutes * 60.0
	var second_tens : int = floori(seconds / 10.0)
	var seconds_ones = floori(seconds) % 10
	
	if (minutes > 9): 
		printerr("WARNING: More than 9 minutes is not currently supported for HUD")
	
	min_text_ref.texture.region.position.x = minutes * num_sprite_width
	sec_tens_tex_ref.texture.region.position.x = second_tens * num_sprite_width
	sec_ones_tex_ref.texture.region.position.x = seconds_ones * num_sprite_width

func update_max_ammo(ammount : int) -> void:
	#Clear any existing bullets
	if ammo_indicator.get_child_count() > 0:
		ammo_indicator.get_children().map(queue_free)
	
	var ammo_indicator_size = ammo_indicator.size
	var new_slot_text : Sprite2D
	var new_slot_text_size : Vector2
	var rot : float
	var dist_from_center : float
	for i : int in starting_max_ammo: 
		new_slot_text = bullet_indicator_scene.instantiate()
		new_slot_text_size = new_slot_text.get_rect().size
		rot = TAU * (i / float(starting_max_ammo))
		
		new_slot_text.scale = (ammo_indicator_size / 4.0) / new_slot_text_size
		dist_from_center = ammo_indicator_size.x / 3.0
		new_slot_text.position = ammo_indicator_size * 0.5 + dist_from_center * Vector2(sin(-rot), -cos(-rot))
		ammo_indicator.add_child(new_slot_text)

func progress_chamber(current_ammo : int, max_ammo : int, shotCooldown : float) -> void:
	var shot_bullet : Sprite2D = ammo_indicator.get_child(max_ammo-current_ammo - 1)
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	shot_bullet.texture = used_round_text
	tween.tween_property(ammo_indicator, "rotation", ammo_indicator.rotation + TAU / max_ammo, shotCooldown)

func reload_chamber(current_ammo : int, max_ammo : int, oneReloadTime : float) -> void:
	var shot_bullet : Sprite2D = ammo_indicator.get_child(- current_ammo)
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var cleanup_rot : Callable = func(x : Sprite2D):
		x.rotation = 0
	tween.tween_property(ammo_indicator, "rotation", ammo_indicator.rotation - TAU / max_ammo, oneReloadTime)
	shot_bullet.texture = unusued_round_text
	
	if current_ammo == max_ammo:
		tween.tween_callback(cleanup_rot.bind(ammo_indicator))
