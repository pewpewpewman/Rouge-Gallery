#Component for making bullet holes appear in sprites
#To use this component, connect a shootable component and a canvas item you want hole to appear in
extends BulletHoleComponent

#Component Connections
var holeVictimSprite : Sprite2D
@export var shootableComponent : ShootableComponent

func _ready() -> void:
	super._ready()
	assert(shootableComponent != null, "Bullet hole component needs a valid shootable component!")
	assert(holeVictim is Sprite2D, "Bullet Component for sprites must use a sprite")
	shootableComponent.was_shot.connect(_on_was_shot)
	holeVictimSprite = holeVictim as Sprite2D
	holeVictimSprite.material.set_shader_parameter(imageScaleStringName, holeVictimSprite.global_scale)

#it deeplt hurts my soul to do this, but for some reason _set() is not affected by it's attached object being changed
func _process(delta: float) -> void:
	holeVictimSprite.material.set_shader_parameter(imageScaleStringName, holeVictimSprite.get_rect().size * holeVictimSprite.global_scale)

func _on_was_shot(player : PlayerCharacter) -> void:
	var holeVictimSize : Vector2 = holeVictimSprite.get_rect().size * holeVictimSprite.global_scale / Vector2(holeVictimSprite.hframes, holeVictimSprite.vframes)
	
	# player.global_position - holeVictimSprite.global_position gets you a vector pointing to where on the sprite the shot occured
	# .roated(-holeVictimSprite.global_rotation) is to correct the difference vector so we're basically working in unrotated space
	# + holeVictimSize * 0.5 undoes the fact godot uses the center as the position, the pointing vector now starts from the top left, just like UVs
	# / holeVictimSize normalizes the pointing vector, just like UVs
	#TODO: correct for skewing, although i dont think ill need it
	
	var shotLocation : Vector2 = ((player.global_position - holeVictimSprite.global_position).rotated(-holeVictimSprite.rotation) + holeVictimSize * 0.5) / holeVictimSize
	shotLocations[shotLocationIndex % MAX_BULLET_HOLES] = shotLocation
	shotLocationIndex += 1
	holeVictimSprite.material.set_shader_parameter(shotLocationsStringName, shotLocations)
