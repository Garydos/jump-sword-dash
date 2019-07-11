extends Node2D

var checkpoint1spawn = Vector2(3288,1786)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    self.visible = false
    $ParallaxBackground/ParallaxLayer/Sprite.visible = false
    $ParallaxBackground/ParallaxLayer2/Sprite.visible = false
    if get_node("/root/PlayerVars").checkpoint == 1:
        $Player.position = checkpoint1spawn
    $Music.play()
    $WinTimer.stop()
    $AvoidLoadHiccup.start()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Player_player_died():
    $Player.health = 0
    $Player.emit_signal("health_changed", $Player.health, $Player.max_health)
    
    $Music.stop()
    $ResetTimer.start()
    $DeathMusic.play()

func _on_ResetTimer_timeout():
    $ResetTimer.stop()
    get_tree().change_scene("res://scenes/Main.tscn")


func _on_Cat_area_entered(area):
    if area.get_groups().has("player"):
        $Cat.queue_free()
        $CatFoundSound.play()
        get_node("/root/LevelVars").cat_found = true

func _on_WinTimer_timeout():
    get_tree().change_scene("res://scenes/Level3.tscn")

func _on_Player_level_cleared():
    get_node("/root/PlayerVars").checkpoint = 0
    $WinTimer.start()
    $Music.stop()
    $WinMusic.play()


func _on_Checkpoint1_area_entered(area):
    if area.get_groups().has("player"):
        if get_node("/root/PlayerVars").checkpoint < 1:
            get_node("/root/PlayerVars").checkpoint = 1


func _on_AvoidLoadHiccup_timeout():
    self.visible = true
    $ParallaxBackground/ParallaxLayer/Sprite.visible = true
    $ParallaxBackground/ParallaxLayer2/Sprite.visible = true
    $AvoidLoadHiccup.stop()
