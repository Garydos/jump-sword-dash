extends "res://scripts/Level.gd"

const Enemy = preload("res://scripts/Enemy.gd")
const EnemyCrab = preload("res://scripts/EnemyBossCrab.gd")
const Fireball = preload("res://scripts/Fireball.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cutscene_executed = false
var camera_move_num = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    #get_node("/root/PlayerVars").checkpoint = 1
    ._ready()
    for child in $TileMap.get_children():
        if child is EnemyCrab:
            child.visible = true
            child.active = false
        elif child is Enemy:
            child.visible = false
            child.active = false
    $InitialBGM.play()
    $Music.stop()
    pass # Replace with function body.

func _on_checkpoint1_area_entered(area):
    if area.get_groups().has("player"):
        if get_node("/root/PlayerVars").checkpoint < 1:
            get_node("/root/PlayerVars").checkpoint = 1

func _on_CutsceneTotalTimer_timeout():
    $CutsceneTotalTimer.stop()
    $Player.frozen = false
    $Player.invincible = false
    cutscene_executed = true
    $Player/Camera2D.current = true
    $CameraNode/Camera2D.current = false
    $TileMap/EnemyBossCrab.active = true
    $Music.play()
    for child in $TileMap.get_children():
        if child is Enemy:
            child.visible = true
            child.active = true

func _on_PlayerFirstFallArea_area_entered(area):
    if area.get_groups().has("player"):
        if cutscene_executed:
            return
        $Player/PlayerSprite.play("idle")
        $Player.set_current_direction("left")
        $CutsceneTotalTimer.start()
        $Player.frozen = true
        $Player.invincible = true
        $CameraSetTimer.start()
        $InitialBGM.stop()

func _on_CameraSetTimer_timeout():
    #this timer is needed because the player
    #still falls a little bit once he reaches
    #the cutscene trigger
    $CameraSetTimer.stop()
    $Player/Camera2D.current = false
    $CameraNode.position = $Player/Camera2D.get_camera_position()
    $Tween.interpolate_property($CameraNode, 'position', $CameraNode.position, $TileMap/EnemyBossCrab.global_position,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
    $Tween.start()
    $CameraNode/Camera2D.current = true
    $CutsceneAnimTimer.start()

func _on_Tween_tween_all_completed():
    if camera_move_num == 1:
        $TileMap/EnemyBossCrab/GrowAnim.play("GrowAnim")
        $GrowingSound.play()
    camera_move_num += 1

func _on_CutsceneAnimTimer_timeout():
    if camera_move_num == 2:
        $Tween.interpolate_property($CameraNode, 'position', $CameraNode.position, $Player/Camera2D.get_camera_position(),0.25,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
        $Tween.start()


func _on_EnemyBossCrab_dead():
    for child in $TileMap.get_children():
        if child is Enemy and !(child is EnemyCrab):
            child.die()
        if child is Fireball:
            child.queue_free()
    $TimeTillWin.start()


func _on_TimeTillWin_timeout():
    ._on_Player_level_cleared()
    $TimeTillWin.stop()
    $Player.frozen = true
    $Player/PlayerSprite.play('idle')
