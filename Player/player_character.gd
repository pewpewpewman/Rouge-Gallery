#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var reticle : Sprite2D = $Reticle
@onready var firingArea : Area2D = $FiringArea
@onready var firingHitboxShape : CollisionShape2D = $FiringArea/FiringHitboxShape
@onready var reticleRing : Sprite2D = $ReticleRing
@onready var shotCooldown : Timer = $ShotCooldown

#General Purpose Vars
var canShoot : bool = true
var shotCooldownTime : float = 1.0 #measureed in seconds

#Item Vars
var itemCollection : Array[ItemBase] = []

func _ready() -> void:
	shotCooldown.timeout.connect(_on_shot_cooldown)
	
	ItemDataBase.pick_up_item(self, ItemBase.ItemID.SUGARY_SWEETS)


func _process(delta : float) -> void:
	var ReticleRingScale : float = shotCooldown.time_left / shotCooldownTime
	reticleRing.scale = Vector2(ReticleRingScale, ReticleRingScale)

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position
	elif(canShoot && event.is_action_pressed("fire_gun")):
		GameplaySignals.player_shot.emit(self)
		shotCooldown.start(shotCooldownTime)
		canShoot = false

func _on_shot_cooldown() -> void:
	canShoot = true
