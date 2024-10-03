#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var reticle : Sprite2D = $Reticle
@onready var reticleRing : Sprite2D = $ReticleRing
@onready var shotCooldown : Timer = $ShotCooldown
@onready var reloadTimer: Timer = $ReloadTimer

#Shooting Vars
var canShoot : bool = true
var shotCooldownTime : float = 0.5 #measureed in seconds
var shotReceivers : Array[Node]

#Ammo Vars
var maxAmmo : int = 6
var currentAmmo : int = maxAmmo
var totalReloadTime : float = 1.5

func _ready() -> void:
	shotCooldown.timeout.connect(_on_shot_cooldown)
	reloadTimer.timeout.connect(reload)
	
	##Item pickup connections
	ItemDataBase.itemDict[BaseItem.ItemID.SUGARY_SWEETS].on_pickup.connect(_on_sugary_sweet_pickup)
	
	##Item loss connections
	ItemDataBase.itemDict[BaseItem.ItemID.SUGARY_SWEETS].on_loss.connect(_on_sugary_sweet_loss)	

	for i : int in 6: 
		#ItemDataBase.pick_up_item(BaseItem.ItemID.UNPOPPED_KERNAL)
		#ItemDataBase.pick_up_item(BaseItem.ItemID.SUGARY_SWEETS)
		pass

func _process(delta : float) -> void:
	var ReticleRingScale : float = shotCooldown.time_left / shotCooldownTime
	reticleRing.scale = Vector2(ReticleRingScale, ReticleRingScale)
	#if (canShoot && Input.is_action_pressed("fire_gun")):
		#fire_shot()

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position
	elif(canShoot && event.is_action_pressed("fire_gun")):
		fire_shot()

func _on_area_player_overlap(obj : Node) -> void:
	print(obj)


func fire_shot() -> void:
		#handle unpopped kernals
		var unpoppedKernalRef : BaseItem = ItemDataBase.itemDict[BaseItem.ItemID.UNPOPPED_KERNAL]
		for i : int in unpoppedKernalRef.extraShotCount:
			var shotMag : float = randf_range(0.0, unpoppedKernalRef.extraShotRadius)
			var shotDeg : float = randf_range(0, 2.0 * PI)
			var shotX : float = shotMag * cos(shotDeg)
			var shotY : float = shotMag * sin(shotDeg)
			GameplaySignals.player_shot.emit(self.position + Vector2(shotX, shotY))
			
		#main shot routine
		GameplaySignals.player_shot.emit(self.global_position)
		currentAmmo -= 1
		GameplaySignals.bullet_used.emit(currentAmmo, maxAmmo, shotCooldownTime)
		canShoot = false
		shotCooldown.start(shotCooldownTime)

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
