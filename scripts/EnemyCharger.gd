extends "res://scripts/Enemy.gd"

export (int) var charge_speed = 400

var charging
var alerted

# Called when the node enters the scene tree for the first time.
func _ready():
    $AlertedSprite.visible = false
    current_direction = 'left'
    charging = false
    alerted = false
    max_run_speed = 600

func _process(delta):
    if charging:
        velocity.x = charge_speed
    else:
        velocity.x = 0

func _physics_process(delta):
    if is_on_wall():
        charging = false

func die():
    charging = false
    .die()
    $Sprite.rotation_degrees = 90


func charge(direction):
    alerted = true
    $AlertedSprite.visible = true
    $AlertedTimer.start()
    $AlertAnimation.play("Alerted")
    $AlertedSound.play()
    if direction == 'right':
        charge_speed = abs(charge_speed)
    else:
        charge_speed = abs(charge_speed) * -1

func _on_SightCircle_area_entered(area):
    if area.get_groups().has("player") and on_screen and !alerted and !charging:
        if get_node("/root/PlayerVars").position.x < global_position.x:
            current_direction = 'left'
        else:
            current_direction = 'right'
        charge(current_direction)

func _on_AlertedTimer_timeout():
    alerted = false
    $AlertedSprite.visible = false
    $AlertAnimation.stop()
    charging = true
    $ChargeSound.play()
    $AlertedTimer.stop()