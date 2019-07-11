extends "res://scripts/Enemy.gd"

export (Vector2) var jump_amount = Vector2(400,-200)
var player_in_view = false

# Called when the node enters the scene tree for the first time.
func _ready():
    $JumpTimer.start()
    max_run_speed = 5000
    pass # Replace with function body.

func _process(delta):
    if get_node("/root/PlayerVars").position.x < global_position.x:
        current_direction = 'left'
    else:
        current_direction = 'right'
        
    if current_direction == 'left':
        $Sprite.flip_h = true
    else:
        $Sprite.flip_h = false
    pass
    
func die():
    .die()
    $Sprite.rotation_degrees = 90

func _on_JumpTimer_timeout():
    if current_direction == 'left':
        jump_amount.x = abs(jump_amount.x) * -1
    else:
        jump_amount.x = abs(jump_amount.x)
    if on_screen and !frozen and player_in_view:
        $JumpSound.play()
        velocity = jump_amount


func _on_SightRadius_area_entered(area):
    if area.get_groups().has("player"):
        player_in_view = true

func _on_SightRadius_area_exited(area):
    if area.get_groups().has("player"):
        player_in_view = false
