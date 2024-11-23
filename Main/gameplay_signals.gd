#Global container for all signals relating to gameplay effects
extends Node

##Game State
signal round_timer_expire

##Shooting Communication
signal search_aimed_objects(location : Vector2) #tests which objects are overlapped by location?
signal in_shot_range(z_index : int) #valid objects respond with thier z index
signal found_highest_z(z_index : int) # player responds with the highest z index so targets can check if theyre valid to be shot and killed
signal object_shot(object : Node)

##Score Signal
signal through_hole_bonus()

##HUD Update Signals
signal bullet_used(num_bullets : int, max_ammo : int, time_to_shoot : float)
signal bullet_reloaded(reloaded : int, max_ammo : int, time_to_reload : float)
