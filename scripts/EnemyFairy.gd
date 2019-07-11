extends "res://scripts/Enemy.gd"

var attacking = false
var just_on_floorwall = false
var flying_speed = 250
var desired_x
var prev_global_pos

# Called when the node enters the scene tree for the first time.
func _ready():
    gravity = 0
    health = 1
    desired_x = rand_range(100,150)
    var neg = rand_range(-1,1)
    desired_x *= neg/abs(neg)
    prev_global_pos = get_node("/root/PlayerVars").position
    pass # Replace with function body.

func move():
    var playery = prev_global_pos.y
    var playerx = prev_global_pos.x
    if !attacking:
        if global_position.y > playery - 50:
            velocity.y = -flying_speed
        elif global_position.y < playery - 150:
            velocity.y = flying_speed
        else:
            velocity.y = 0
        if global_position.x > (playerx + desired_x) + 30:
            velocity.x = -flying_speed
        elif global_position.x < (playerx + desired_x)  - 30:
            velocity.x = flying_speed
        else:
            velocity.x = 0
    else:
        if global_position.y > playery + 10:
            velocity.y = -flying_speed
        elif global_position.y < playery - 10:
            velocity.y = flying_speed
        else:
            velocity.y = 0
        if global_position.x > playerx+5:
            velocity.x = -flying_speed
        elif global_position.x < playerx-5:
            velocity.x = flying_speed
        else:
            velocity.x = 0

func _process(delta):
    if dead:
        gravity = 800
        ._physics_process(delta)
        $AnimationPlayer.stop()
        return
    if on_screen:
        move()
        

func _on_AttackTimer_timeout():
    $AttackTimer.stop()
    attacking = false
    $AnimationPlayer.play("idle_anim")
    $RestTimer.start()
    var playerx = get_node("/root/PlayerVars").position.x
    desired_x = rand_range(100,150)
    var neg = rand_range(-1,1)
    desired_x *= neg/abs(neg)
    prev_global_pos = get_node("/root/PlayerVars").position
    #$AnimationPlayer.play("New Anim")
    pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_entered():
    $RestTimer.stop()
    $AttackTimer.start()
    on_screen = true
    prev_global_pos = get_node("/root/PlayerVars").position

func _on_VisibilityNotifier2D_screen_exited():
    $RestTimer.stop()
    $AttackTimer.stop()
    attacking = false
    on_screen = false


func _on_RestTimer_timeout():
    $AnimationPlayer.stop()
    $AttackTimer.start()
    attacking = true
    $AttackSound.play()
    prev_global_pos = get_node("/root/PlayerVars").position
