extends Area2D


@export var impulso : float
@export var chao : float
@export var screen_size : float
@export var gravidade : float
@export var num_atingido : int
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var ehCopia : bool
var copia_dir : int

var dir = RandomNumberGenerator.new().randf_range(-1,1)
var velocidade: Vector2

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if(ehCopia):
		position.x += velocidade.x * delta * copia_dir
	else:
		position.x += velocidade.x * delta * dir
	
	velocidade.y += gravidade*delta
	position.y += velocidade.y*delta
	
	if(position.y > chao):
		position.y = chao
		velocidade.y = impulso
	
	if(position.x > screen_size):
		dir = -1
		copia_dir = -1
	elif(position.x < 0):
		dir = 1
		copia_dir = 1


func _on_area_entered(_area: Area2D) -> void:
	pass
