#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var outer : Sprite2D = $Outer
@onready var inner : Sprite2D = $Inner
@onready var shotCooldown : Timer = $ShotCooldown
@onready var reloadTimer: Timer = $ReloadTimer

#Shooting Vars
var canShoot : bool = true
var shotCooldownTime : float = 1 #measureed in seconds
var shotReceivers : Array[Node]
var highestZIndex : int = -50

#Ammo Vars
var maxAmmo : int = 6
var currentAmmo : int = maxAmmo
var totalReloadTime : float = 3

func _ready() -> void:
	shotCooldown.timeout.connect(_on_shot_cooldown)
	reloadTimer.timeout.connect(reload)
	
	#Shooting connections
	GameplaySignals.in_shot_range.connect(_on_in_shot_range)
	
	
	##Item pickup connections
	ItemDataBase.itemDict[BaseItem.ItemID.SUGARY_SWEETS].on_pickup.connect(_on_sugary_sweet_pickup)
	
	##Item loss connections
	ItemDataBase.itemDict[BaseItem.ItemID.SUGARY_SWEETS].on_loss.connect(_on_sugary_sweet_loss)

	for i : int in 20: 
		#ItemDataBase.pick_up_item(BaseItem.ItemID.UNPOPPED_KERNAL)
		#ItemDataBase.pick_up_item(BaseItem.ItemID.SUGARY_SWEETS)
		pass

func _process(_delta : float) -> void:
	pass
	#if (canShoot && Input.is_action_pressed("fire_gun")):
		#firing_routine()

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position
	elif(canShoot && event.is_action_pressed("fire_gun")):
		firing_routine()

func _on_in_shot_range(zIndex : int):
	highestZIndex = max(highestZIndex, zIndex)

func fire_shot(location : Vector2) -> void:
	GameplaySignals.search_aimed_objects.emit(location)
	GameplaySignals.found_highest_z.emit(highestZIndex) #this is basically actually putting the trigger and firing
	highestZIndex = -50

func firing_routine() -> void:
		#handle unpopped kernals
		var unpoppedKernalRef : BaseItem = ItemDataBase.itemDict[BaseItem.ItemID.UNPOPPED_KERNAL]
		for i : int in unpoppedKernalRef.extraShotCount:
			var shotMag : float = randf_range(0.0, unpoppedKernalRef.extraShotRadius)
			var shotDeg : float = randf_range(0, 2.0 * PI)
			var shotX : float = shotMag * cos(shotDeg)
			var shotY : float = shotMag * sin(shotDeg)
			fire_shot(self.global_position + Vector2(shotX, shotY))
			
		#main shot routine
		fire_shot(self.global_position)
		currentAmmo -= 1
		GameplaySignals.bullet_used.emit(currentAmmo, maxAmmo, shotCooldownTime)
		canShoot = false
		shotCooldown.start(shotCooldownTime)
		
		#Reticle Animation
		var reticleTween : Tween = get_tree().create_tween()
		var animFunc : Callable = func animFunc(x : float) -> void:
			outer.rotation = x * TAU
			outer.scale = Vector2(0.1, 0.1) * (cos(x * TAU) + 5.0) / 6.0
		
		var cleanup : Callable = func cleanup() -> void:
			outer.rotation = 0
			outer.scale = Vector2(0.1, 0.1)
		
		reticleTween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		reticleTween.tween_method(animFunc, 0.0, 1.0, shotCooldownTime)
		reticleTween.finished.connect(cleanup)

 
func _on_shot_cooldown() -> void:
	if (currentAmmo == 0):
		reload()
	else:
		canShoot = true

func reload() -> void:
	if currentAmmo != maxAmmo:
		currentAmmo += 1
		GameplaySignals.bullet_reloaded.emit(currentAmmo, maxAmmo, totalReloadTime / maxAmmo)
		reloadTimer.start(totalReloadTime / maxAmmo)
	else:
		canShoot = true

##
## ITEM PICKUP RESPONSES
##

func _on_sugary_sweet_pickup() -> void:
	shotCooldownTime -= shotCooldownTime * 0.10

##
## ITEM LOSS RESPONSES
##

func _on_sugary_sweet_loss() -> void:
	shotCooldownTime += shotCooldownTime * 0.10
