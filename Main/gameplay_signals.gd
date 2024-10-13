#Global container for all signals relating to gameplay effects
extends Node

##Shooting Communication
signal search_aimed_objects(location : Vector2) #tests which objects are overlapped by location?
signal in_shot_range(zIndex : int) #valid objects respond with thier z index
signal found_highest_z(zIndex : int) # player responds with the highest z index so targets can check if theyre valid to be shot and killed
signal target_shot(target : BaseTarget)

##HUD Update Signals
signal bullet_used(numBullets : int, maxAmmo : int, timeToShoot : float)
signal bullet_reloaded(reloaded : int, maxAmmo : int, timeToReload : float)
