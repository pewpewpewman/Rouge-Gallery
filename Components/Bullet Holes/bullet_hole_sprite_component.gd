#Component for making bullet holes appear in sprites
#To use this component, connect a shootable component and a canvas item you want hole to appear in
class_name BulletHoleSpriteComponent
extends BulletHoleComponent

#Component Connections
var holeVictimSprite : Sprite2D
@export var shootableComponent : ShootableBase

func _ready() -> void:
	super._ready()
	assert(shootableComponent != null, "Bullet hole component needs a valid shootable component!")
	assert(holeVictim is Sprite2D, "Bullet Component for sprites must use a sprite")
	shootableComponent.was_shot.connect(_on_was_shot)
	holeVictimSprite = holeVictim as Sprite2D
	holeVictimSprite.material.set_shader_parameter(imageScaleStringName, holeVictimSprite.global_scale)

#it deeplt hurts my soul to do this, but for some reason _set() is not affected by it's attached object being changed
func _process(_delta: float) -> void:
	holeVictimSprite.material.set_shader_parameter(imageScaleStringName, holeVictimSprite.get_rect().size * holeVictimSprite.global_scale)

func _on_was_shot(shotLocation : Vector2) -> void:
	# shotLocation - holeVictimSprite.global_position gets you a vector pointing to where on the sprite the shot occured
	# .roated(-holeVictimSprite.global_rotation) is to correct the difference vector so we're basically working in unrotated space
	# + holeVictimSize * 0.5 undoes the fact godot uses the center as the position, the pointing vector now starts from the top left, just like UVs
	# / holeVictimSize normalizes the pointing vector, just like UVs
	#TODO: correct for skewing, although i dont think ill need it
	
	var holeVictimSize : Vector2 = holeVictimSprite.get_rect().size * holeVictimSprite.global_scale
	var localShotLocation : Vector2 
	
	if holeVictimSprite.centered:
		localShotLocation = ((shotLocation - holeVictimSprite.global_position - holeVictimSprite.offset).rotated(-holeVictimSprite.rotation) + holeVictimSize * 0.5) / holeVictimSize
	else:
		localShotLocation = (shotLocation - holeVictimSprite.global_position - holeVictimSprite.offset).rotated(-holeVictimSprite.rotation) / holeVictimSize
	
	shotLocations[shotLocationIndex % MAX_BULLET_HOLES] = localShotLocation
	shotLocationIndex += 1
	holeVictimSprite.material.set_shader_parameter(shotLocationsStringName, shotLocations)
