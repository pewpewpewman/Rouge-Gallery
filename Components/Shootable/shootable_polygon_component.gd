class_name ShootablePolygonComponent
extends ShootableBase

@export var polygon : Line2D
var polygon_points : Array[Vector2]

func _ready():
	super._ready()
	assert(polygon != null, "shootable component needs a hitbox")
	assert(polygon.points.size() >= 3, "Polygon shot component needs more")
	polygon_points.resize(polygon.points.size())
	for i : int in polygon.points.size():
		polygon_points[i] = polygon.points[i]
	polygon.queue_free()

func check_shot(shot_location : Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(shot_location, polygon_points.map(func (x : Vector2) : return x + component_owner.position))
