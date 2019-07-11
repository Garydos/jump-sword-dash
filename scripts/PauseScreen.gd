extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    if OS.get_name() == "Android" or OS.get_name() == "iOS":
        $Label2.visible = true
        $Label3.visible = false
    else:
        $Label2.visible = false
        $Label3.visible = true


func _process(delta):
    var jump = Input.is_action_just_pressed('ui_select')
    var click = Input.is_action_just_pressed('tap')
    if OS.get_name() == "Android" or OS.get_name() == "iOS":
        if click:
            get_tree().paused = false
            queue_free()
    else:
        if jump:
            get_tree().paused = false
            queue_free()
