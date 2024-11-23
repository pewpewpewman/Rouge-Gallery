class_name TargetEventDescriptor
extends Resource

enum TargetTypes {
	BASIC,
	TIME,
	ITEM
}

enum MovementTypes {
	SCROLL,
	TOSS
}

enum SpawnPoints {
	HIGH_OR_RIGHT,
	MID_OR_CENTER,
	LOW_OR_LEFT,
}

@export_category("Event Info")
@export var length : float = 0
@export var contained_targets : Array[TargetDescriptor] = []
