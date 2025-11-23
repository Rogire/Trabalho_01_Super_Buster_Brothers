extends Area2D

const JUMP_VELOCITY = -1000.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var gravidade : float
@export var chao : float
@export var screen_size : float
@export var vida : int

var velocity : Vector2
var ac  = 0.0

func _ready() -> void:
	vida = 3
	velocity.x = 600
	velocity.y = 0
	
func _physics_process(delta: float) -> void:
	var dx = Input.get_axis("esquerda","direita")
	
	if(position.x <= 0 && dx == -1 || position.x>=screen_size && dx == 1):
		velocity.x = 0
	else:
		velocity.x=600
		position.x += dx*velocity.x*delta
	
	if(position.y < chao):
		velocity.y += gravidade*delta
		
	position.y += velocity.y*delta
	
	if(Input.is_action_just_pressed("pular") && ac>(0.016*60)):
		velocity.y += JUMP_VELOCITY
		ac = 0.0

	if(position.y>chao):
		position.y = chao
		velocity.y = 0

	ac += delta
	
func _on_area_2d_area_entered(_area: Area2D) -> void:
	vida -= 1
	print("aiai")


func _on_area_entered(_area: Area2D) -> void:
	pass # Replace with function body.
