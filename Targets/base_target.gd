#Base Class for targets that appear
class_name BaseTarget
extends Sprite2D

#Component Connection
@export var shootable_component : ShootableCircleComponent

#Target Data
var description : TargetDescriptor
var point_value : float = 10

#Death Vars
var destroyed : bool = false
var death_response : Callable
var death_curve : Curve2D = Curve2D.new()
var death_animation_time : float = 0.0
var death_text : CompressedTexture2D

#Movement Vars
var trajectory : Curve2D = Curve2D.new()
var trajectory_tracker : float = 0.0

#Scoring Vars
var num_hole_bonuses : int = 0

#Other Scenes
var target_stand_scene : PackedScene = preload("res://Targets/target_stand.tscn")

func _ready() -> void:
	assert(shootable_component != null, "Targets need shot detection components")
	shootable_component.component_shot.connect(_on_destroyed.unbind(1))
	assert(description != null, "Target is supposed to have info attached")
	
	#Initialize Death Response
	match description.type:
		TargetDescriptor.TargetTypes.BASIC:
			death_response = basic_death
		TargetDescriptor.TargetTypes.TIME:
			death_response = time_death
		TargetDescriptor.TargetTypes.ITEM:
			death_response = item_death
	
	#Start Movement Tweener
	var tweener : Tween = self.create_tween()
	match description.movement_type:
		TargetDescriptor.MovementTypes.SCROLL:
			z_index = 1
			var target_stand : Sprite2D = target_stand_scene.instantiate()
			add_child(target_stand)
		TargetDescriptor.MovementTypes.TOSS:
			z_index = 1
			var spawn_x : float = (description.spawn_point + 1) * get_viewport().size.x / 4
			var screen_size : Vector2 = get_viewport().size
			var height : float = 2 * screen_size.y / 5
			var initial_pos : Vector2 = Vector2(spawn_x, screen_size.y)
			
			trajectory.add_point(initial_pos)
			trajectory.add_point(Vector2(spawn_x, height))
			trajectory.add_point(initial_pos)
			
			position = initial_pos
			tweener.tween_property(self, "rotation", TAU, description.time_on_screen)
			tweener.parallel()
			tweener.set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
	tweener.tween_property(self, "trajectory_tracker", 1, description.time_on_screen)
	#tweener.finished.connect(func () : if !destroyed: queue_free())

func _process(delta : float) -> void:
	if !destroyed:
		position = trajectory.sample(0, trajectory_tracker)
		if description.movement_type == TargetDescriptor.MovementTypes.SCROLL:
			pass
			#print(trajectory.point_count)
	else:
		position = death_curve.sample(0, death_animation_time)
	
func _on_destroyed() -> void:
	if !destroyed:
		destroyed = true
		if death_text != null:
			texture = death_text
		death_response.call()
		play_death_anim()

func basic_death() -> void:
	pass
	
func time_death() -> void:
	pass

func item_death() -> void:
	pass

func play_death_anim() -> void:
	#Get a random direction for the dying animation
	var death_direction : int = randi()
	if death_direction % 2 == 0:
		death_direction = -1
	else:
		death_direction = 1
	
	#Find death animation ending values
	var death_anim_length = 2.5
	var death_magnitude_horiz : float = randf() * 50.0 + 100.0
	var death_magnitude_vert : float =  500.0
	var screen_size : Vector2 = get_viewport().size
	var death_peak : Vector2 =  Vector2(death_magnitude_horiz * death_direction * 1.5, -death_magnitude_vert)
	var place_of_death : Vector2 = Vector2(death_magnitude_horiz * death_direction, screen_size.y + 100)
	
	#Add points to death curve
	death_curve.add_point(self.position, Vector2.ZERO, death_peak)
	death_curve.add_point(self.position + place_of_death, death_peak, Vector2.ZERO)
	
	#Add death animation tweener
	var tween : Tween = self.create_tween()
	tween.tween_property(self, "death_animation_time", 1.0, death_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel()
	tween.tween_property(self, "rotation", 6.0 * PI * -death_direction, death_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(queue_free)
