extends Area2D

var current_direction = 'left'
export (int) var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
    $LifeTimer.start()
    pass # Replace with function body.
    
func set_direction(direction):
    current_direction = direction

func _process(delta):
    if current_direction == 'right':
        position.x += speed * delta
    else:
        position.x += -speed * delta

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()

func _on_Fireball_area_entered(area):
    var groups = area.get_groups()
    if !(groups.has("enemies") or groups.has("enemies_aux")) :
        queue_free()

func _on_LifeTimer_timeout():
    queue_free()
