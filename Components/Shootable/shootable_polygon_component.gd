class_name ShootablePolygonComponent
extends ShootableBase

@export var polygon : Line2D
var polygonPoints : Array[Vector2]

func _ready():
	super._ready()
	assert(polygon != null, "shootable component needs a hitbox")
	assert(polygon.points.size() >= 3, "Polygon shot component needs more")
	polygonPoints.resize(polygon.points.size())
	for i : int in polygon.points.size():
		polygonPoints[i] = polygon.points[i]
	polygon.queue_free()

func check_shot(shotLocation : Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(shotLocation, polygonPoints.map(func (x : Vector2) : return x + componentOwner.position))
