#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var reticle : Sprite2D = $Reticle
@onready var reticleRing : Sprite2D = $ReticleRing
@onready var shotCooldown : Timer = $ShotCooldown

#General Purpose Vars
var canShoot : bool = true
var shotCooldownTime : float = 1.0 #measureed in seconds

#Item Vars
var itemCollection : Array[ItemBase] = []

func _ready() -> void:
	shotCooldown.timeout.connect(_on_shot_cooldown)
	for i : int in 20: 
		#ItemDataBase.pick_up_item(self, ItemBase.ItemID.UNPOPPED_KERNAL)
		ItemDataBase.pick_up_item(self, ItemBase.ItemID.SUGARY_SWEETS)
		pass

func _process(delta : float) -> void:
	var ReticleRingScale : float = shotCooldown.time_left / shotCooldownTime
	reticleRing.scale = Vector2(ReticleRingScale, ReticleRingScale)
	if(canShoot && Input.is_action_pressed("fire_gun")):
		fire_shot()

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position
	#elif(canShoot && event.is_action_pressed("fire_gun")):
		#fire_shot()

func _on_shot_cooldown() -> void:
	canShoot = true

func fire_shot():
		#handle unpopped kernals
		var unpoppedKernalRef : UnpoppedKernel = ItemDataBase.itemDict[ItemBase.ItemID.UNPOPPED_KERNAL]
		for i : int in unpoppedKernalRef.extraShotCount:
			var shotMag : float = randf_range(0.0, unpoppedKernalRef.extraShotRadius)
			var shotDeg : float = randf_range(0, 2.0 * PI)
			var shotX : float = shotMag * cos(shotDeg)
			var shotY : float = shotMag * sin(shotDeg)
			GameplaySignals.player_shot.emit(self.position + Vector2(shotX, shotY))
		 
		#main shot routine
		GameplaySignals.player_shot.emit(self.	position)
		shotCooldown.start(shotCooldownTime)
		canShoot = false
