#Base Class for targets that appear
class_name BaseTarget
extends Sprite2D

#Component Connection
@export var shootable_component : ShootableBase

#General Use Vars
var point_value : int = 0
var destroyed : bool = false
var dragger : RemoteTransform2D

#Death Animation Vars
var death_curve : Curve2D = Curve2D.new()
var death_animation_time : float = 0.0
@export var death_text : CompressedTexture2D

#Thrown Target Vars
var thrown : bool = false
var trajectory : Curve2D = Curve2D.new()
var trajectory_tracker : float = 0.0

var num_hole_bonuses : int = 0

func _ready() -> void:
	assert(shootable_component != null, "Targets need shot detection components")
	shootable_component.component_shot.connect(_on_destroyed.unbind(1))

func _process(_delta: float) -> void:
	if destroyed:
		self.position = death_curve.sample(0, death_animation_time)
	elif thrown:
		self.position = trajectory.sample(0, trajectory_tracker)

func _on_destroyed():
	if !destroyed:
		destroyed = true
		if dragger != null:
			dragger.remote_path = ""
		if death_text != null:
			texture = death_text
		play_death_anim()

func play_death_anim() -> void:
	#Get a random direction for the dying animation
	var death_direction : int = randi()
	if death_direction % 2 == 0:
		death_direction = -1
	else:
		death_direction = 1
	
	#Find death animation ending values
	var death_anim_length = 3.0
	var death_magnitude_horiz : float = randf() * 50.0 + 100.0
	var death_magnitude_vert : float =  500.0
	var screen_size : Vector2i = get_window().get_viewport().get_visible_rect().size
	var death_peak : Vector2 =  Vector2(death_magnitude_horiz * death_direction * 1.5, -death_magnitude_vert)
	var place_of_death : Vector2 = Vector2(death_magnitude_horiz * death_direction, screen_size.y + 100)
	
	#Add points to death curve
	death_curve.add_point(self.position, Vector2.ZERO, death_peak)
	death_curve.add_point(self.position + place_of_death, death_peak, Vector2.ZERO)
	
	#Add death animation tweener
	var tween : Tween = self.create_tween()
	tween.tween_property(self, "death_animation_time", 1.0, death_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel()
	tween.tween_property(self, "rotation", 4.0 * PI * -death_direction, death_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(queue_free)

func death_free_check() -> void:
	if !destroyed:
		queue_free()
