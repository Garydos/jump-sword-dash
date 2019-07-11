extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $AlertAnim.play("loading")
    $BlinkingAnim.play("blinkwords")
    $Timer.start()
    $AudioStreamPlayer.play()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Timer_timeout():
    $Timer.stop()
    get_tree().change_scene("res://scenes/Main.tscn")
