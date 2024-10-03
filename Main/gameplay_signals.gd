#Global container for all signals relating to gameplay effects
extends Node

signal player_shot(shotLocation : Vector2)
signal target_in_range()
signal target_shot(target : BaseTarget)
signal bullet_used(numBullets : int, maxAmmo : int, timeToShoot : float)
signal bullet_reloaded(reloaded : int, maxAmmo : int, timeToReload : float)
