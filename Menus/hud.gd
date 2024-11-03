class_name Hud
extends Control

#Children References
@onready var debugInfo : Label = $DebugInfo
@onready var ammoIndicator: TextureRect = $AmmoIndicator

#Assets
var unusedRoundText : Texture2D = preload("res://Menus/Hud Assets/unused_round.png")
var usedRoundText : Texture2D = preload("res://Menus/Hud Assets/used_round.png")
var bulletIndicatorScene : PackedScene = preload("res://Menus/bullet_indicator.tscn")

#Timer Element Vars	
@onready var timer : Control = $Timer
@onready var minTexRef : TextureRect =$Timer/Minute
@onready var secTensTexRef : TextureRect = $Timer/SecondTens
@onready var secOnesTexRef : TextureRect = $Timer/SecondOnes
@onready var numSpriteWidth : int = minTexRef.texture.atlas.get_width() / 10

#Other Vars
var startingMaxAmmo : int = 0

func _ready() -> void:
	if startingMaxAmmo <= 0:
		printerr("HUD was not correctly given max starting ammo! (Or starting ammo is less than one in which case wtf is wrong with you???)")
	update_max_ammo(startingMaxAmmo)

func _process(_delta : float) -> void:
	debugInfo.set_text("FPS %d" % Engine.get_frames_per_second())
	#ammoIndicator.rotation += delta

func update_timer(time: float) -> void:
	#input is total seconds
	var minutes : int = floori(time / 60.0)
	var seconds : float = time - minutes * 60.0
	var secondTens : int = floori(seconds / 10.0)
	var secondsOnes = floori(seconds) % 10
	
	if (minutes > 9): 
		printerr("WARNING: More than 9 minutes is not currently supported for HUD")
	
	minTexRef.texture.region.position.x = minutes * numSpriteWidth
	secTensTexRef.texture.region.position.x = secondTens * numSpriteWidth
	secOnesTexRef.texture.region.position.x = secondsOnes * numSpriteWidth

func update_max_ammo(ammount : int) -> void:
	#Clear any existing bullets
	if ammoIndicator.get_child_count() > 0:
		ammoIndicator.get_children().map(queue_free)
	
	var ammoIndicatorSize = ammoIndicator.size
	var newSlotText : Sprite2D
	var newSlotTextSize : Vector2
	var rot : float
	var dist_from_center : float
	for i : int in startingMaxAmmo: 
		newSlotText = bulletIndicatorScene.instantiate()
		newSlotTextSize = newSlotText.get_rect().size
		rot = TAU * (i / float(startingMaxAmmo))
		
		newSlotText.scale = (ammoIndicatorSize / 4.0) / newSlotTextSize
		dist_from_center = ammoIndicatorSize.x / 3.0
		newSlotText.position = ammoIndicatorSize * 0.5 + dist_from_center * Vector2(sin(-rot), -cos(-rot))
		ammoIndicator.add_child(newSlotText)

func progress_chamber(currentAmmo : int, maxAmmo : int, shotCooldown : float) -> void:
	var shotBullet : Sprite2D = ammoIndicator.get_child(maxAmmo-currentAmmo - 1)
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	shotBullet.texture = usedRoundText
	tween.tween_property(ammoIndicator, "rotation", ammoIndicator.rotation + TAU / maxAmmo, shotCooldown)

func reload_chamber(currentAmmo : int, maxAmmo : int, oneReloadTime : float) -> void:
	var shotBullet : Sprite2D = ammoIndicator.get_child(currentAmmo - 1)
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var cleanup_rot : Callable = func(x : Sprite2D):
		x.rotation = 0
	tween.tween_property(ammoIndicator, "rotation", ammoIndicator.rotation + TAU / maxAmmo, oneReloadTime)
	shotBullet.texture = unusedRoundText
	
	if currentAmmo == maxAmmo:
		tween.tween_callback(cleanup_rot.bind(ammoIndicator))
