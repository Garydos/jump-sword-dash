extends Node2D

export (Vector2) var checkpoint1spawn = Vector2(1580,-100)
export (Vector2) var checkpoint2spawn
export (Vector2) var checkpoint3spawn
export (Vector2) var checkpoint4spawn
export (Vector2) var checkpoint5spawn
export (Vector2) var checkpoint6spawn
export (Vector2) var checkpoint7spawn
export (Vector2) var checkpoint8spawn
export (Vector2) var checkpoint9spawn
export (Vector2) var checkpoint10spawn

# Called when the node enters the scene tree for the first time.
func _ready():
    self.visible = false
    $ParallaxBackground/ParallaxLayer/Sprite.visible = false
    $ParallaxBackground/ParallaxLayer2/Sprite.visible = false
    if get_node("/root/PlayerVars").checkpoint == 1:
        $Label7.visible = true
        $Player.position = checkpoint1spawn
    else:
        $Label7.visible = false
    $Music.play()
    $WinTimer.stop()
    $AvoidLoadHiccup.start()
    pass # Replace with function body.

func _on_Player_player_died():
    $Player.health = 0
    $Player.emit_signal("health_changed", $Player.health, $Player.max_health)
    
    $Music.stop()
    $ResetTimer.start()
    $DeathMusic.play()

func _on_ResetTimer_timeout():
    $ResetTimer.stop()
    get_tree().change_scene("res://scenes/Level1.tscn")

func _on_WinTimer_timeout():
    get_tree().change_scene("res://scenes/Main.tscn")

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
