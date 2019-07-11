extends CanvasLayer

var empty_heart
var full_heart

# Called when the node enters the scene tree for the first time.
func _ready():
    empty_heart = preload("res://assets/textures/tile728.png")
    full_heart = preload("res://assets/textures/tile730.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func update_health(health, max_health):
    if max_health != 5:
        #max is 5, for now.  If not, something's horribly wrong
        return
    for i in range(health):
        var heartname = "Heart" + str(i)
        var heartnode = get_node("PlayerHealth/HealthColumn1/" + heartname)
        heartnode.set_texture(full_heart)
    for j in range(health,max_health):
        var heartname = "Heart" + str(j)
        var heartnode = get_node("PlayerHealth/HealthColumn1/" + heartname)
        heartnode.set_texture(empty_heart)