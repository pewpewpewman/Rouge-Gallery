#Base Class for targets that appear
class_name BaseTarget
extends Sprite2D

#Component Connection
@export var shootableComponent : ShootableBase

#General Use Vars
var pointValue : int = 0
var destroyed : bool = false
var dragger : RemoteTransform2D

#Death Animation Vars
var deathCurve : Curve2D = Curve2D.new()
var deathAnimationTime : float = 0.0
@export var deathText : CompressedTexture2D

#Thrown Target Vars
var thrown : bool = false
var trajectory : Curve2D = Curve2D.new()
var trajectoryTracker : float = 0.0

#Variable paths for tweener - possible solution to stutter
#static var trajectoryTrackerPath : NodePath = "trajectoryTracker"
#static var rotationPath : NodePath = "rotation"

func _ready() -> void:
	assert(shootableComponent != null, "Targets need shot detection components")
	shootableComponent.componentShot.connect(_on_was_shot)

func _process(_delta: float) -> void:
	if destroyed:
		self.position = deathCurve.sample(0, deathAnimationTime)
	elif thrown:
		self.position = trajectory.sample(0, trajectoryTracker)

func _on_was_shot(_shotLocation : Vector2i):
	if !destroyed:
		GameplaySignals.target_shot.emit(self)
		_on_destroyed()

func _on_destroyed():
	destroyed = true
	if dragger != null:
		dragger.remote_path = ""
	if deathText != null:
		texture = deathText
	play_death_anim()
 
func play_death_anim() -> void:
	#Get a random direction for the dying animation
	var deathDirection : int = randi()
	if deathDirection % 2 == 0:
		deathDirection = -1
	else:
		deathDirection = 1
	
	#Find death animation ending values
	var deathAnimLength = 3.0
	var deathMagnitudeHoriz : float = randf() * 50.0 + 100.0
	var deathMagnitudeVert : float =  500.0
	var screenSize : Vector2i = get_window().get_viewport().get_visible_rect().size
	var deathPeak : Vector2 =  Vector2(deathMagnitudeHoriz * deathDirection * 1.5, -deathMagnitudeVert)
	var placeOfDeath : Vector2 = Vector2(deathMagnitudeHoriz * deathDirection, screenSize.y + 100)
	
	#Add points to death curve
	deathCurve.add_point(self.position, Vector2.ZERO, deathPeak)
	deathCurve.add_point(self.position + placeOfDeath, deathPeak, Vector2.ZERO)
	
	#Add death animation tweener
	var tween : Tween = self.create_tween()
	tween.tween_property(self, "deathAnimationTime", 1.0, deathAnimLength).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel()
	tween.tween_property(self, "rotation", 4.0 * PI * -deathDirection, deathAnimLength).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(queue_free)

func death_free_check() -> void:
	if !destroyed:
		queue_free()
