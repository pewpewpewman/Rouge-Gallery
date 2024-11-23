#Component for an object getting shot and setting signals to react
class_name ShootableBase
extends Node

#Owner reference
@export var component_owner : Node2D
@export var bullet_hole_component : BulletHoleComponent #needed so things with bullet holes let shots pass

#Signals
signal component_shot(shot_location : Vector2)

func _ready() -> void:
	assert(component_owner != null, "Shot detection component needs a valid owner")
	GameplaySignals.search_aimed_objects.connect(_on_search_aimed_objects)

func _on_search_aimed_objects(shot_location : Vector2) -> void:
	if check_shot(shot_location):
		if !check_bullet_holes(shot_location):
			GameplaySignals.in_shot_range.emit(component_owner.z_index)
		var highest_z_index : int = await GameplaySignals.found_highest_z
		if highest_z_index == component_owner.z_index:
			component_shot.emit(shot_location) #used for component owner communication
			GameplaySignals.object_shot.emit(component_owner) #used for global shot communication
		elif highest_z_index < component_owner.z_index:
			GameplaySignals.through_hole_bonus.emit()

func check_bullet_holes(shot_location : Vector2) -> bool:
	#returns true if the shot overlaps with a bullet hole
	if bullet_hole_component != null:
		var bullet_hole_radius : float = bullet_hole_component.hole_radius
		var shot_locations : PackedVector2Array = bullet_hole_component.unnormalized_shot_locations
		for i : int in bullet_hole_component.MAX_BULLET_HOLES:
			if Geometry2D.is_point_in_circle(shot_location, shot_locations[i], bullet_hole_radius):
				return true
	return false

#func thats overriden in children
func check_shot(_shotLocation : Vector2):
	pass
