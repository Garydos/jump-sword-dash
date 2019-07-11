extends "res://scripts/Enemy.gd"

const Enemy = preload("res://scripts/Enemy.gd")
const Fairy = preload("res://scripts/EnemyFairy.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var faries_max = 0
export (int) var charge_speed = 600

var charging = false
var alerted = false
var dizzy = false
var player_in_sights = false

var exclmation
var question

# Called when the node enters the scene tree for the first time.
func _ready():
    exclmation = preload("res://assets/textures/tile819.png")
    question = preload("res://assets/textures/tile821.png")
    self.max_run_speed = 800
    invincible = true
    max_health = 10
    health = max_health
    $MinionSpawnTimer.start()
    active = false
    pass # Replace with function body.

func add_fairy():
    var fairy = load("res://scenes/EnemyFairy.tscn")
    var fairy_instance = fairy.instance()
    fairy_instance.position = self.position
    get_parent().add_child(fairy_instance)

func replenish_fairies():
    var fairy_count = 0
    for child in get_parent().get_children():
        if child is Fairy:
            fairy_count += 1
    if fairy_count < faries_max:
        add_fairy()

func _process(delta):
    if dizzy:
        invincible = false
    else:
        invincible = true

    if active and !dead:
        if charging:
            velocity.x = charge_speed
            $Sprite.modulate = Color(1,0,0)
        elif player_in_sights and !dizzy and !alerted and abs(get_node("/root/PlayerVars").position.x - global_position.x) < 200:
            if get_node("/root/PlayerVars").position.x < global_position.x:
                current_direction = 'left'
                print(current_direction)
            else:
                current_direction = 'right'
                print(current_direction)
            charge(current_direction)
        else:
            velocity.x = 0
            $Sprite.modulate = Color(1,1,1)

func _physics_process(delta):
    if is_on_wall() and charging:
        charging = false
        alerted = false
        dizzy = true
        velocity.x = 0
        $GrowAnim.play("Confused")
        $ConfusedTimer.start()
        $Exclamation.set_texture(question)
        $HitWallSound.play()
        $ConfusedSound.play()

func _on_SightLine_area_entered(area):
    if area.get_groups().has("player"):
        player_in_sights = true
        
func charge(direction):
    print("started charge")
    alerted = true
    $AlertedSound.play()
    $Exclamation.visible = true
    $AlertedTimer.start()
    $GrowAnim.play("Alert")
    if direction == 'right':
        charge_speed = abs(charge_speed)
    else:
        charge_speed = abs(charge_speed) * -1

func _on_AlertedTimer_timeout():
    alerted = false
    $Exclamation.visible = false
    charging = true
    $ChargeSound.play()
    $AlertedTimer.stop()


func _on_ConfusedTimer_timeout():
    dizzy = false
    $ConfusedTimer.stop()
    $Exclamation.set_texture(exclmation)
    invincible = true


func _on_SightLine_area_exited(area):
    if area.get_groups().has("player"):
        player_in_sights = false


func _on_MinionSpawnTimer_timeout():
    if active and !dead:
        replenish_fairies()
