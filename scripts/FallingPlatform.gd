extends KinematicBody2D

var on_platform = false
var falling = false
var velocity = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _process(delta):
    if on_platform:
        $Sprite.modulate = Color(0,2,0)
    else:
        $Sprite.modulate = Color(1,1,1)
    if falling:
        velocity.y += 50
        pass
    pass

func _physics_process(delta):
    velocity = move_and_slide(velocity, FLOOR_NORMAL)
    if is_on_floor():
        queue_free()

func _on_Timer_timeout():
    falling = true
    on_platform = false
    pass # Replace with function body.


func _on_Area2D_area_entered(area):
    if area.get_groups().has("player"):
        on_platform = true
        $Timer.start()
    pass # Replace with function body.


func _on_Area2D_area_exited(area):
    if area.get_groups().has("player"):
        on_platform = false
        $Timer.stop()
    pass # Replace with function body.
