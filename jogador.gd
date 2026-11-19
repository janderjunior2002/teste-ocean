extends CharacterBody3D

const VELOCIDADE = 3.0
const GRAVIDADE = 9.8
const SENSIBILIDADE = 0.003

@onready var camera = $Camera3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	# Girar a visão com o mouse
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSIBILIDADE)
		camera.rotate_x(-event.relative.y * SENSIBILIDADE)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	# Esc solta o mouse, clique prende de novo
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y -= GRAVIDADE * delta

	# Andar
	var entrada = Input.get_vector("esquerda", "direita", "frente", "tras")
	var direcao = transform.basis * Vector3(entrada.x, 0, entrada.y)
	velocity.x = direcao.x * VELOCIDADE
	velocity.z = direcao.z * VELOCIDADE

	move_and_slide()
