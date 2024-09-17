#Component for making bullet holes appear in ui elements
#To use this component, connect a shootable component and a canvas item you want hole to appear in
extends BulletHoleComponent

var holeVictimUI : Control

func _ready() -> void:
	super._ready()
	assert(holeVictim is Control, "Bullet Component for UI must use a UI node")
	holeVictimUI = holeVictim as Control
	
	holeVictimUI.gui_input.connect(_on_gui_input)
	holeVictimUI.resized.connect(_on_resized)

	#I have no clue why you have to multiply by 5 for the scaling to work, but its good enough
	holeVictimUI.material.set_shader_parameter(imageScaleStringName, (holeVictimUI.scale * holeVictimUI.size.normalized() * 5.0))

func _on_gui_input(event : InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed):

		var holeVictimSize : Vector2 = holeVictimUI.size * holeVictimUI.scale
		print(holeVictimUI.size)
		
		# player.global_position - holeVictimUI.global_position gets you a vector pointing to where on the sprite the shot occured
		# .roated(-holeVictimUI.global_rotation) is to correct the difference vector so we're basically working in unrotated space
		# / holeVictimSize normalizes the pointing vector, just like UVs
		#TODO: correct for skewing, although i dont think ill need it
		
		var shotLocation : Vector2 = (event.global_position - holeVictimUI.global_position).rotated(-holeVictimUI.rotation) / holeVictimSize
		shotLocations[shotLocationIndex % MAX_BULLET_HOLES] = shotLocation
		shotLocationIndex += 1
		holeVictimUI.material.set_shader_parameter(shotLocationsStringName, shotLocations)

func _on_resized():
	holeVictimUI.material.set_shader_parameter(imageScaleStringName, holeVictimUI.scale * holeVictimUI.size.normalized())
