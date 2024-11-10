extends BaseItem

var extra_shot_radius : int = 128 #measured in pixels
var extra_shot_count : int

func pickup() -> void:
	if num_stacks == 0:
		extra_shot_count = 3
	else:
		extra_shot_count += 1
	super.pickup()
	
func loss() -> void:
	super.loss()
	if num_stacks == 0:
		extra_shot_count = 0
	else:
		extra_shot_count -= 1
