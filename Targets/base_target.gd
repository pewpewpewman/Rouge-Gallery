#Base Class for targets that appear
class_name BaseTarget
extends Sprite2D

#Component Connection
@export var shootableComponent : ShootableComponent

#General Use Vars
var pointValue : int = 0
var destroyed : bool = false
var dragger : RemoteTransform2D

#Death Animation Vars
var deathCurve : Curve2D = Curve2D.new()
var deathAnimationTime : float = 0.0

func _ready() -> void:
	shootableComponent.was_shot.connect(_on_was_shot)

func _process(delta: float) -> void:
	if destroyed:
		self.position = deathCurve.sample(0, deathAnimationTime)

func _on_was_shot(player : PlayerCharacter):
	if !destroyed:
		GameplaySignals.target_shot.emit(self)
		_on_destroyed()

func _on_destroyed():
	destroyed = true
	dragger.remote_path = ""
	
	#Get a random direction for the dying animation
	var deathDirection : int = randi()
	if deathDirection % 2 == 0:
		deathDirection = -1
	else:
		deathDirection = 1
	
	#Find death animation ending values
	var deathAnimLength = 2.5
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
 
