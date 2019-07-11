extends KinematicBody2D

signal hit(knockbackAmount, enemy)
signal dead()

var velocity = Vector2()
export (int) var max_run_speed = 175
export (int) var gravity = 1600
export (int) var friction = 30
export (int) var max_health = 3
export (Vector2) var knockback_amount = Vector2(200,-150)

var health
var invincible = false
var current_direction = 'left'
var on_screen = false
var previously_on_screen = false
var frozen = false
var dead = false
var active = true

#constants
var FLOOR_NORMAL = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
    health = max_health
    pass # Replace with function body.

func apply_friction():
    var abs_vel = abs(velocity.x)
    abs_vel -= friction
    if abs_vel < 0:
        abs_vel = 0
    if abs_vel > max_run_speed:
        var max_speed = max_run_speed
        abs_vel =  max_speed
    if velocity.x < 0:
        abs_vel *= -1
    velocity.x = abs_vel

func apply_gravity(delta):
    velocity.y += gravity * delta

func _physics_process(delta):
    apply_friction()
    apply_gravity(delta)
    
    velocity = move_and_slide(velocity, FLOOR_NORMAL)
    
func _process(delta):
    pass

func die():
    dead = true
    $Area2D.queue_free()
    $DeathSound.play()
    $DeathTimer.start()
    emit_signal("dead")

func _on_Area2D_area_entered(area):
    if area.get_groups().has("sword") and not invincible:
        health -= 1
        if area.get_node("SwordSprite").scale.x < 0:
            knockback_amount.x = abs(knockback_amount.x)*-1
        else:
            knockback_amount.x = abs(knockback_amount.x)
        velocity = knockback_amount
        invincible = true
        frozen = true
        if health > 0:
            $HurtSound.play()
            $InvincibilityTimer.start()
            $FreezeTimer.start()
        else:
            die()


func _on_InvincibilityTimer_timeout():
    invincible = false


func _on_VisibilityNotifier2D_screen_exited():
    on_screen = false

func _on_VisibilityNotifier2D_screen_entered():
    on_screen = true
    previously_on_screen = true


func _on_FreezeTimer_timeout():
    frozen = false
    $FreezeTimer.stop()


func _on_DeathTimer_timeout():
    queue_free()
