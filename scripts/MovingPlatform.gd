extends Node2D

export (String) var moving_direction = 'left'
export (String) var moving_mode = 'moving'
export (bool) var oneshot = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $MovingPlatformAnim.play(moving_mode + "_" + moving_direction)
    pass # Replace with function body.


func _process(delta):
    if get_node("/root/PlayerVars").player_vel.y < 0:
        $MovingPlatformSprite/MovingPlatformBody/CollisionShape2D.disabled = true
    else:
        $MovingPlatformSprite/MovingPlatformBody/CollisionShape2D.disabled = false

func _on_MovingPlatformAnim_animation_finished(anim_name):
    if oneshot:
        $MovingPlatformAnim.stop(false)
