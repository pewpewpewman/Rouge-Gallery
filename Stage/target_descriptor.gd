class_name TargetDescriptor
extends Resource

enum TargetTypes {
	BASIC,
	TIME,
	ITEM
}

enum MovementTypes
{
	SCROLL,
	TOSS
}

enum SpawnPoints
{
	HIGH_OR_RIGHT,
	MID_OR_CENTER,
	LOW_OR_LEFT,
}

@export_category("Target Info")
@export var type : TargetTypes = TargetTypes.BASIC
@export var item : BaseItem.ItemID = BaseItem.ItemID.SUGARY_SWEETS
@export var time_reward : float = 0
@export_category("Movement Info")
@export var movement_type : MovementTypes = MovementTypes.SCROLL
@export var spawn_point : SpawnPoints = SpawnPoints.MID_OR_CENTER
@export var time_on_screen : float = 0
