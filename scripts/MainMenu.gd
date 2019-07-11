extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $SwordAnim.play("Sword")
    $JumpAnim.play("Jump")
    $DashAnim.play("Dash")
    $PressSpaceAnim.play("PressSpace")
    $AudioStreamPlayer.play()
    if OS.get_name() == "Android" or OS.get_name() == "iOS":
        $CanvasLayer/Label2.visible = true
        $CanvasLayer/Label.visible = false
    else:
        $CanvasLayer/Label2.visible = false
        $CanvasLayer/Label.visible = true
    pass # Replace with function body.
    
func _input(event):
    pass


func _process(delta):
    var jump = Input.is_action_just_pressed('ui_select')
    var click = Input.is_action_just_pressed('tap')
    if jump or click:
        get_tree().change_scene("res://scenes/Level1.tscn")
