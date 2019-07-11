extends "res://scripts/Enemy.gd"

export (String) var wall_direction = "left"
export (String) var starting_climb_direction = "up"
export (int) var climb_speed = 80

var climbing = true

func _ready():
    gravity = 0
    health = 2
    $SwitchUpDown.start()
    current_direction = starting_climb_direction
    climbing = true
    pass

func _process(delta):
    if !on_screen:
        $SkitterSound.stop()
    else:
        if !$SkitterSound.playing:
            $SkitterSound.play()

func _physics_process(delta):
    if dead:
        gravity = 800
        ._physics_process(delta)
        return
    if climbing:
        if current_direction == "up":
            velocity.y = -climb_speed
        else:
            velocity.y = climb_speed
    else:
        velocity.y = 0
    
    
    if wall_direction == "left":
        velocity.x = -500
    else:
        velocity.x = 500

func _on_SwitchUpDown_timeout():
    climbing = false
    $SwitchUpDown.stop()
    if current_direction == "down":
        $AnimationPlayer.play("TurnClockwiseFromBottom")
        current_direction = "up"
    else:
        $AnimationPlayer.play("TurnClockwiseFromTop")
        current_direction = "down"
    pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
    $SwitchUpDown.start()
    climbing = true
    $AnimationPlayer.stop()
