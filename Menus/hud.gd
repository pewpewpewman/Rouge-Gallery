class_name Hud
extends Control

#Children References
@onready var debugInfo : Label = $DebugInfo
@onready var ammoIndicator: Sprite2D = $AmmoIndicator

#Assets
var unusedRoundText : Texture2D = preload("res://Menus/Hud Assets/unused_round.png")
var usedRoundText : Texture2D = preload("res://Menus/Hud Assets/used_round.png")
var bulletIndicatorScene : PackedScene = preload("res://Menus/bullet_indicator.tscn")

#Timer Element Vars	
@onready var timer : Control = $Timer
@onready var minTexRef : TextureRect = $Timer/Minute
@onready var secTensTexRef : TextureRect = $Timer/SecondTens
@onready var secOnesTexRef : TextureRect = $Timer/SecondOnes
@onready var numSpriteWidth : int = minTexRef.texture.atlas.get_width() / 10

func _ready() -> void:
	for i : int in 6:
		var newSlotText : Sprite2D = bulletIndicatorScene.instantiate()
		var rot = TAU * i / 6.0
		newSlotText.position = ammoIndicator.get_rect().size.x / 3.0 * Vector2(sin(-rot), -cos(-rot))
		newSlotText.get_node("Label").text = str(i)
		ammoIndicator.add_child(newSlotText)

func _process(delta : float) -> void:
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

##REDO LIKE ALL OF THIS AND ADD BEING ABLE TO SHOOT WHILE NOT FULLY LOADED
#func update_chamber(numBullets : int, _maxAmmo : int, timeToShoot : float) -> void:
	#var maxAmmo : int = ammoIndicator.get_child_count()
	#ammoIndicator.get_child(-maxAmmo + numBullets + 1).texture = usedRoundText
	#for i : int in maxAmmo:
		#var childRef : TextureRect = ammoIndicator.get_child(i)
		#var finalRot = childRef.rotation + TAU / maxAmmo
		#var tween : Tween = get_tree().create_tween()
		#tween.tween_property(childRef, "rotation", finalRot, timeToShoot)
#
#func reload_chamber(reloaded : int, _maxAmmo : int, timeToReload : float) -> void:
	#await get_tree().create_timer(1.0).timeout
	#
	#var maxAmmo : int = ammoIndicator.get_child_count()
	#ammoIndicator.get_child(-reloaded + 1).texture = unusedRoundText
	#
	#for i : int in maxAmmo:
		#var childRef : TextureRect = ammoIndicator.get_child(i)
		#var finalRot = childRef.rotation + TAU / maxAmmo
		#var tween : Tween = get_tree().create_tween()
		#tween.tween_property(childRef, "rotation", finalRot, timeToReload)

func progress_chamber(currentAmmo : int, maxAmmo : int, shotCooldown : float) -> void:
	var shotBullet : Sprite2D = ammoIndicator.get_child(maxAmmo-currentAmmo - 1)
	var tween : Tween = get_tree().create_tween()
	shotBullet.texture = usedRoundText
	tween.tween_property(ammoIndicator, "rotation", ammoIndicator.rotation + TAU / maxAmmo, shotCooldown)

func reload_chamber(currentAmmo : int, maxAmmo : int, oneReloadTime : float) -> void:
	var shotBullet : Sprite2D = ammoIndicator.get_child(currentAmmo - 1)
	var tween : Tween = get_tree().create_tween()
	var cleanup_rot : Callable = func(x : Sprite2D):
		x.rotation = 0
	tween.tween_property(ammoIndicator, "rotation", ammoIndicator.rotation + TAU / maxAmmo, oneReloadTime)
	shotBullet.texture = unusedRoundText
	
	if currentAmmo == maxAmmo:
		tween.tween_callback(cleanup_rot.bind(ammoIndicator))
