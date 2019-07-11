extends "res://scripts/Enemy.gd"

var falling = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $Sprite.frame = 588
    $Sprite.rotation = 0
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _physics_process(delta):
    if !falling:
        velocity.y -= gravity * delta
    if (is_on_wall() or is_on_floor()) and falling:
        falling = false
        $ExplosionTimer.start()
        $ExplosionSound.play()
        $FallingBoxAnim.play("explode")
    pass

func _on_FallTriggerArea_area_entered(area):
    if area.get_groups().has("player"):
        var space_state = get_world_2d().direct_space_state
        var result = space_state.intersect_ray(position, area.position,
                    [self], collision_mask)
        if result:
            falling = true

func _on_ExplosionTimer_timeout():
    #$FallingBoxAnim.stop(false)
    #$FallingBoxAnim.queue_free()
    #$Sprite.queue_free()
    queue_free()
