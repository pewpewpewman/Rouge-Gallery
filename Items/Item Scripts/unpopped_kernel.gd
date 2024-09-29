extends BaseItem

var extraShotRadius : int = 128 #measured in pixels
var extraShotCount : int

func pickup() -> void:
	if numStacks == 0:
		extraShotCount = 3
	else:
		extraShotCount += 1
	super.pickup()
	
func loss() -> void:
	super.loss()
	if numStacks == 0:
		extraShotCount = 0
	else:
		extraShotCount -= 1
