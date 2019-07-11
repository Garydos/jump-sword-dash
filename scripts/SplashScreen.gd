extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimStart.start()
    $Timer.start()
    $AudioStreamPlayer.play()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_AnimationPlayer_animation_finished(anim_name):
    $AnimationPlayer.stop()
    $AnimationPlayer2.play("Studios")

func _on_AnimStart_timeout():
    $AnimationPlayer.play("AyyLmao")
    $AnimStart.stop()


func _on_Timer_timeout():
    $Timer.stop()
    get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_AnimationPlayer2_animation_finished(anim_name):
    $AnimationPlayer2.stop()
