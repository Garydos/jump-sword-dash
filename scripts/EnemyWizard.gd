extends "res://scripts/Enemy.gd"

var default_tex
var fireballscene

# Called when the node enters the scene tree for the first time.
func _ready():
    $Staff.visible = false
    default_tex = load("res://assets/textures/tile056.png")
    fireballscene = load("res://scenes/Fireball.tscn")
    $CastTimer.start()
    pass # Replace with function body.

func _process(delta):
    if !on_screen:
        if $StaffAnimation.is_playing():
            $StaffAnimation.stop()
        $Sprite.texture = default_tex
        $Staff.visible = false
    
    if get_node("/root/PlayerVars").position.x < global_position.x:
        current_direction = 'left'
    else:
        current_direction = 'right'
        
    if current_direction == 'left':
        $Sprite.flip_h = true
        #$Staff.scale.x = -1*(abs($Staff.scale.x))
        $Staff.position.x = -6
        if !$StaffAnimation.is_playing():
            $Staff.rotation_degrees = 0
    else:
        $Sprite.flip_h = false
        #$Staff.scale.x = (abs($Staff.scale.x))
        $Staff.position.x = 8
        if !$StaffAnimation.is_playing():
            $Staff.rotation_degrees = -90
    if !$StaffAnimation.is_playing():
        $Sprite.texture = default_tex
    pass
    
func die():
    .die()
    $Sprite.rotation_degrees = 90
    
func cast_fireball():
    if !active:
        return
    $FireballSound.play()
    var fireball = fireballscene.instance()
    if current_direction == 'left':
        fireball.position = self.position + Vector2(-20,0)
        fireball.set_direction('left')
    else:
        fireball.position = self.position + Vector2(20,0)
        fireball.set_direction('right')
        fireball.scale.x = -1
    get_parent().add_child(fireball)

func _on_CastTimer_timeout():
    if frozen or !on_screen:
        return
    if current_direction == 'right':
        $StaffAnimation.play("StaffAttackRight")
    else:
        $StaffAnimation.play("StaffAttackLeft")
    $Staff.visible = true
    cast_fireball()
    

func _on_StaffAnimation_animation_finished(anim_name):
    $StaffAnimation.stop(false)
    $Sprite.texture = default_tex
    $Staff.visible = false
