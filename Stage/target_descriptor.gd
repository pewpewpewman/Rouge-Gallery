class_name TargetDescriptior
extends Resource

enum TargetTypes {
	BASIC,
	TIME,
	ITEM
}

enum SpawnPoints {
	HIGH_OR_RIGHT,
	MID_OR_CENTER,
	LOW_OR_LEFT,
}

enum MovementTypes {
	SCROLL,
	TOSS
}

@export_category("Target Info")
@export var type : TargetTypes
@export var item : BaseItem.ItemID
@export var time_reward : float
@export_category("Movement Info")
@export var movement_type : MovementTypes
@export var spawn_point : SpawnPoints
@export var time_on_screen : float
@export_category("Next Target Info")
@export var simultaneous : bool #false if the next target should be spawned instantly
@export var next_time : float #time until next target spawns
