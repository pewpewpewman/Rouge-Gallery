#Component for making bullet holes appear in ui elements
#To use this component, connect a shootable component and a canvas item you want hole to appear in
class_name BulletHoleUIComponent
extends BulletHoleComponent

var hole_victim_ui : Control

func _ready() -> void:
	super._ready()
	assert(hole_victim is Control, "Bullet Component for UI must use a UI node")
	hole_victim_ui = hole_victim as Control
	
	hole_victim_ui.gui_input.connect(_on_gui_input)
	hole_victim_ui.resized.connect(_on_resized)

	#I have no clue why you have to multiply by 5 for the scaling to work, but its good enough
	hole_victim_ui.material.set_shader_parameter(image_scale_string_name, (hole_victim_ui.scale * hole_victim_ui.size.normalized() * 5.0))

func _on_gui_input(event : InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):

		var hole_victim_size : Vector2 = hole_victim_ui.size * hole_victim_ui.scale
		print(hole_victim_ui.size)
		
		# player.global_position - hole_victim_ui.global_position gets you a vector pointing to where on the sprite the shot occured
		# .roated(-hole_victim_ui.global_rotation) is to correct the difference vector so we're basically working in unrotated space
		# / hole_victim_size normalizes the pointing vector, just like UVs
		#TODO: correct for skewing, although i dont think ill need it
		
		var shot_location : Vector2 = (event.global_position - hole_victim_ui.global_position).rotated(-hole_victim_ui.rotation) / hole_victim_size
		shot_locations[shot_location_index % MAX_BULLET_HOLES] = shot_location
		shot_location_index += 1
		hole_victim_ui.material.set_shader_parameter(shot_locations_string_name, shot_locations)

func _on_resized():
	hole_victim_ui.material.set_shader_parameter(image_scale_string_name, hole_victim_ui.scale * hole_victim_ui.size.normalized())
