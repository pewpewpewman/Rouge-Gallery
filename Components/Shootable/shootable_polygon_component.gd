class_name ShootablePolygonComponent
extends ShootableBase

@export var pointMarkers : Array[Marker2D]

func _ready():
	super._ready()
	assert(pointMarkers.size() >= 3, "Polygon shot component needs more")
	for i : int in pointMarkers.size():
		assert(pointMarkers[i] != null, "all polygon points nust be valid")

func check_shot(shotLocation : Vector2) -> bool:
	#Finding the usable poly point locs in a loop her emay seem dumb, but it lets us avoid having a seperate list of vectors
	#and makes the poly agnostic to the the shootable componetent owner's origin (i.e. the target stands)
	var polygonPoints : PackedVector2Array
	polygonPoints.resize(pointMarkers.size())
	for i : int in pointMarkers.size():
		polygonPoints[i] = pointMarkers[i].global_position
	
	#print("\n")
	#print("Owner: ", self.get_parent())
	#print("Shot Loc: ", shotLocation)
	#print("Points: ", polygonPoints)		
	#print("Result: ", Geometry2D.is_point_in_polygon(shotLocation, polygonPoints))
	#print("\n")	
	
	return Geometry2D.is_point_in_polygon(shotLocation, polygonPoints)
