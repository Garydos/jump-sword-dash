extends KinematicBody2D

signal enemy_knockback(direction)
signal health_changed(health, max_health)
signal player_died()
signal level_cleared()

export (int) var run_speed = 40
export (int) var jump_speed = -500
export (int) var gravity = 1600
export (int) var max_horiz_speed = 200
export (int) var max_vert_speed = 1000
export (int) var max_run_speed = 175
export (int) var friction = 30
export (int) var max_health = 5
export (int) var dash_speed = 450
export (int) var wall_stick_speed = 5
export (Vector2) var default_knockback = Vector2(150,-150)

#constants
var FLOOR_NORMAL = Vector2(0, -1)

var frozen = false
var velocity = Vector2()
var stick = Vector2(-20,0)
var jumping = false
var dashable = true
var swordable = true
var swording = false
var dashing = false
var current_direction = 'right'
var knockingback = false
var health = max_health
var invincible = false
var sticking = false

func _ready():
    $PlayerSprite.visible = true
    $PlayerSprite.play('idle')
    get_node("/root/PlayerVars").alive = true

func set_current_direction(direction):
    if direction == 'right':
        current_direction = 'right'
        $PlayerSprite.scale.x = 1
        $Sword.position.x = 20
        $Sword/SwordSprite.scale.x = 0.5
    else:
        current_direction = 'left'
        $PlayerSprite.scale.x = -1
        $Sword.position.x = -5
        $Sword/SwordSprite.scale.x = -0.5

func _input(ev):
    #if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo:
    #    var pos = $Camera2D.global_position
    #    $Camera2D.current = false
    #    $Camera2D.position = global_position
    pass

func get_input():
    
    if dashing:
        if current_direction == 'right':
            velocity.x = dash_speed
        else:
            velocity.x = -dash_speed
        return
    
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_just_pressed('ui_select')
    var dash = Input.is_action_just_pressed('aux_button')
    var action = Input.is_action_just_pressed('action_button')
    var pause = Input.is_action_just_pressed('pause')

    if is_on_floor() and $PlayerSprite.animation == 'jump':
        $PlayerSprite.stop()
        $PlayerSprite.animation = 'idle'
        $PlayerSprite.play()
    if jump and is_on_floor():
        $JumpSound.play()
        jumping = true
        velocity.y = jump_speed
        if $PlayerSprite.animation != 'jump':
            $PlayerSprite.animation = 'jump'
            $PlayerSprite.play()
    elif jump and is_on_wall():
        $JumpSound.play()
        jumping = true
        sticking = false
        velocity.y = jump_speed
        if current_direction == 'right':
            velocity.x = -run_speed*8
            pass
        else:
            velocity.x = run_speed*8
            pass
        $PlayerSprite.animation = 'jump'
        $PlayerSprite.play()
    if right:
        velocity.x += run_speed
        current_direction = 'right'
        $PlayerSprite.scale.x = 1
        $Sword.position.x = 20
        $Sword/SwordSprite.scale.x = 0.5
        if $PlayerSprite.animation != 'walk' && $PlayerSprite.animation != 'jump':
            $PlayerSprite.animation = 'walk'
            $PlayerSprite.play()
    elif left:
        velocity.x -= run_speed
        current_direction = 'left'
        $PlayerSprite.scale.x = -1
        $Sword.position.x = -5
        $Sword/SwordSprite.scale.x = -0.5
        if $PlayerSprite.animation != 'walk' && $PlayerSprite.animation != 'jump':
            $PlayerSprite.animation = 'walk'
            $PlayerSprite.play()
    else:
        if !jumping && is_on_floor():
            $PlayerSprite.animation = 'idle'
            $PlayerSprite.play()
    if action:
        if swordable:
            swordable = false
            swording = true
            $SwordCooldownTimer.start()
            $SwordTimer.start()
            $SwordSound.play()
            if current_direction == 'right':
                velocity.x = 200
                $SwordAnimation.play("sword_swing_right")
            else:
                $SwordAnimation.play("sword_swing_left")
                velocity.x = -200
    if swording:
        $Sword/SwordSprite.visible = true
        $Sword/SwordHitBox.disabled = false
    else:
        $Sword/SwordSprite.visible = false
        $Sword/SwordHitBox.disabled = true
        
    if (left or right) and swordable == true:
        swording = false
        
    if dash && dashable && !dashing:
        dashing = true
        dashable = false
        $DashTimer.start()
        $DashSound.play()
    
    if is_on_wall() and !is_on_floor() and !sticking:
        sticking = true
        if current_direction == 'right':
            stick.x = abs(stick.x)
        else:
            stick.x = abs(stick.x) * -1
        $StickTimer.start()
    
    if sticking:
        velocity += stick
    
    if !is_on_wall() and sticking:
        sticking = false
        $StickTimer.stop()
        if current_direction == 'right':
            velocity.x -= 20
        else:
            velocity.x += 20
    
    if (is_on_floor() or is_on_wall()) and $DashCooldownTimer.is_stopped() and $DashTimer.is_stopped():
        dashable = true
        
    if pause:
        var pausescene = load("res://scenes/PauseScreen.tscn")
        var pauseinstance = pausescene.instance()
        add_child(pauseinstance)
        #get_parent().get_node("Music").stream_paused = true
        get_tree().paused = true
        
func apply_friction():
    var abs_vel = abs(velocity.x)
    if is_on_floor():
        abs_vel -= friction
    else:
        #air drag
        abs_vel -= friction/8
    if abs_vel < 0:
        abs_vel = 0
    if abs_vel > max_run_speed && !dashing:
        var max_speed = max_run_speed
        abs_vel =  max_speed
    if velocity.x < 0:
        abs_vel *= -1
    velocity.x = abs_vel

func apply_gravity(delta):
    if dashing:
        velocity.y = 0
        return
    velocity.y += gravity * delta
    var max_fall_speed = max_vert_speed
    if sticking:
        max_fall_speed = wall_stick_speed
    if velocity.y > max_fall_speed:
        velocity.y = max_fall_speed
    if jumping and is_on_floor():
            jumping = false
            dashable = true

func _physics_process(delta):
    if !knockingback and get_node("/root/PlayerVars").alive and !frozen:
        get_input()
    apply_friction()
    apply_gravity(delta)
    
    velocity = move_and_slide(velocity, FLOOR_NORMAL)
    if is_on_wall():
        for i in get_slide_count():
            var collision = get_slide_collision(i)
            if collision.normal.x > 0:
                set_current_direction('left')
            else:
                set_current_direction('right')
    
func _process(delta):
    get_node("/root/PlayerVars").position = global_position
    get_node("/root/PlayerVars").player_vel = velocity

func _on_DashTimer_timeout():
    dashing = false
    $DashTimer.stop()
    $DashCooldownTimer.start()

func _on_DashCooldownTimer_timeout():
    if is_on_floor() or is_on_wall():
        dashable = true
    $DashCooldownTimer.stop()


func _on_SwordCooldownTimer_timeout():
    swordable = true


func _on_Sword_body_entered(body):
    pass # Replace with function body.

func _on_SwordTimer_timeout():
    if !Input.is_action_pressed('action_button'):
        $Sword/SwordSprite.visible = false
        swording = false


func _on_KnockbackTimer_timeout():
    knockingback = false

func _on_Sword_area_entered(area):
    if area.get_groups().has("enemies"):
        var knockbackAmount = default_knockback
        if current_direction == 'right':
            knockbackAmount.x = -knockbackAmount.x
        velocity = knockbackAmount
        knockingback = true
        $KnockbackTimer.start()

func die():
    #queue_free()
    $PlayerSprite.play("dead")
    var knockbackAmount = Vector2(150,-150)
    if current_direction == 'right':
        knockbackAmount.x = -knockbackAmount.x
    velocity = knockbackAmount
    invincible = true
    $InvincibilityTimer.stop()
    get_node("/root/PlayerVars").alive = false
    emit_signal("player_died")

func player_hurt():
    $HurtSound.play()
    health -= 1
    emit_signal("health_changed", health, max_health)
    if health <= 0:
        die()
    else:
        var knockbackAmount = Vector2(150,-150)
        if current_direction == 'right':
            knockbackAmount.x = -knockbackAmount.x
        velocity = knockbackAmount
        knockingback = true
        invincible = true
        $KnockbackTimer.start()
        $InvincibilityTimer.start()
        $PlayerAnimation.play("blinking")

func _on_PlayerHurtBox_area_entered(area):
    if area.get_groups().has("enemies"):
        if !invincible:
            player_hurt()
    if area.get_groups().has("instakill"):
        if !invincible:
            die()
    if area.get_groups().has("level_win"):
        frozen = true
        invincible = true
        $InvincibilityTimer.stop()
        emit_signal("level_cleared")


func _on_InvincibilityTimer_timeout():
    invincible = false
    $PlayerAnimation.stop()
    $PlayerSprite.visible = true

func _on_StickTimer_timeout():
    sticking = false
    $StickTimer.stop()

