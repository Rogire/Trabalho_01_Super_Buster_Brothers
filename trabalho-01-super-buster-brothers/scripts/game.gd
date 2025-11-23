extends Node2D

@export var Ataque : PackedScene
@export var Inimigo : PackedScene

@onready var game: Node2D = $"."
@onready var player: Area2D = $player
@onready var score_label: Label = $score
@onready var hp: Label = $HP
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var score : int
var totInimigos : int
var screen_size = Vector2(1100,654)
var ataque_na_tela: Area2D
var frame_time = (0.016*60)
var ac = frame_time
var resetPos : Vector2

func _ready() -> void:
	audio_stream_player_2d.play()
	score = 0
	ataque_na_tela = null
	resetPos = player.position
	
	gerar_inimigos()
	player.area_entered.connect(_on_player_hit.bind())
	

func _physics_process(delta: float) -> void:
	score_label.text = str(score)
	hp.text = str(player.vida)
	
	if(score == totInimigos):
		get_tree().change_scene_to_file("res://cenas/tela_de_vitoria.tscn")
	else:
		if(Input.is_action_just_pressed("atirar") && ac > frame_time):
			ataque_na_tela = Ataque.instantiate()
			ataque_na_tela.position = Vector2(player.position.x,player.position.y-150)
			add_child(ataque_na_tela)
			ac = 0.0

		if(ataque_na_tela != null && ataque_na_tela.position.y < -300 ):
			ataque_na_tela.queue_free()
			ataque_na_tela = null
		
		ac+=delta

func instanciar_inimigo(pos:Vector2, escala=1.0, velocidade=Vector2(300.0,300.0),ehCopia=false,dir=1):
	var inimigo:Area2D;
	var collision_shape;
	
	inimigo = Inimigo.instantiate()

	collision_shape = inimigo.get_child(0)
	inimigo.position = pos
	
	inimigo.scale = Vector2(escala,escala)
	collision_shape.scale = Vector2(escala,escala)
	
	inimigo.velocidade = velocidade
	inimigo.ehCopia = ehCopia
	
	if(inimigo.ehCopia):
		inimigo.copia_dir = dir
		
	var info = {"inimigo":inimigo,"escala":inimigo.scale.x}
	
	inimigo.area_entered.connect(_on_bubble_shoot.bind(info))
	add_child(inimigo)

func _on_bubble_shoot(_area_entered, info)->void:
	var inimigo = info.inimigo
	var escala_inimigo = info.escala
	
	if(inimigo.ehCopia == false):
		var newpos1 = Vector2(inimigo.position.x+50,inimigo.position.y+30)
		var newpos2 = Vector2(inimigo.position.x-50,inimigo.position.y+30)
		var new_esc = escala_inimigo/2
		
		await get_tree().create_timer(0.1).timeout
		instanciar_inimigo(newpos1,new_esc,Vector2(300/new_esc,-350/new_esc),true,1)
		instanciar_inimigo(newpos2,new_esc,Vector2(300/new_esc,-350/new_esc),true,-1)
		
	score += 1
	
	if(inimigo != null):
		inimigo.call_deferred("queue_free")
	
func _on_player_hit(_area)->void:
	player.vida -=1
	score = 0
	player.get_child(2).play()
	
	if(player.vida == 0):
		get_tree().call_deferred("change_scene_to_file","res://cenas/tela_de_morte.tscn")
	else:
		for i in range(len(game.get_children())):
			if i>5 and (game.get_child(i).is_queued_for_deletion() == false):
				game.get_child(i).call_deferred("queue_free")
		
		player.position = resetPos
		
		await get_tree().create_timer(1).timeout
		gerar_inimigos()
	
func gerar_inimigos()->void:
	var numInimigos = RandomNumberGenerator.new().randi_range(3,6)
	totInimigos = numInimigos*3
	
	for i in range(numInimigos):
		var randX = RandomNumberGenerator.new().randi_range(0,screen_size.x)
		var randY = RandomNumberGenerator.new().randi_range(0,50)
		var randS = RandomNumberGenerator.new().randf_range(0.75,1);
		var randV = Vector2(500/randS,350/randS)
	
		var pos = Vector2(randX,randY)
		instanciar_inimigo(pos,randS,randV)
