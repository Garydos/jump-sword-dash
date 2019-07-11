extends "res://scripts/Level.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    #get_node("/root/PlayerVars").checkpoint = 1
    ._ready()
    pass # Replace with function body.
    
func _on_checkpoint1_area_entered(area):
    if area.get_groups().has("player"):
        if get_node("/root/PlayerVars").checkpoint < 1:
            get_node("/root/PlayerVars").checkpoint = 1