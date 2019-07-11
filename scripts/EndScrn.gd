extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    if get_node("/root/LevelVars").cat_found == false:
        $Sprite.visible = false
    else:
        $Sprite.visible = true
    $AudioStreamPlayer.play()
    $Timer.start()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Timer_timeout():
    get_tree().change_scene("res://scenes/MainMenu.tscn")
    pass # Replace with function body.
