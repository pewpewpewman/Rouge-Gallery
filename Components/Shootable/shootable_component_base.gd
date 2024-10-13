#Component for an object getting shot and setting signals to react
class_name ShootableBase
extends Node2D

#Owner reference
@export var componentOwner : Node2D
@export var bulletHoleComponent : BulletHoleComponent #needed so things with bullet holes let shots pass

#Signals
signal componentShot(shotLocation : Vector2)

func _ready() -> void:
	assert(componentOwner != null, "Shot detection component needs a valid owner")
	GameplaySignals.search_aimed_objects.connect(_on_search_aimed_objects)

func _on_search_aimed_objects(shotLocation : Vector2) -> void:
	if check_shot(shotLocation) && !check_bullet_holes(shotLocation):
		GameplaySignals.in_shot_range.emit(componentOwner.z_index)
		var highestZIndex : int = await GameplaySignals.found_highest_z
		if highestZIndex == componentOwner.z_index:
			componentShot.emit(shotLocation)

func check_bullet_holes(shotLocation : Vector2) -> bool:
	#returns true if the shot overlaps with a bullet hole
	if bulletHoleComponent != null:
		var bulletHoleRadius : float = bulletHoleComponent.holeRadius
		var shotLocations : PackedVector2Array = bulletHoleComponent.unnormalizedShotLocations
		for i : int in bulletHoleComponent.MAX_BULLET_HOLES:
			if Geometry2D.is_point_in_circle(shotLocation, shotLocations[i], bulletHoleRadius):
				return true
	return false

#func thats overriden in children
func check_shot(_shotLocation : Vector2):
	pass
