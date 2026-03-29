extends CharacterBody2D

@export var patrolNodeParent: Node2D
@export var waitTime := 3
@export var walkSpeed = 250

@onready var NavAgent = $NavigationAgent2D
@onready var waitTimer = $WaitTimer
@onready var raychecks: Array[RayCast2D] = [
	$RayCast2D, $RayCast2D2, $RayCast2D3
]

@onready var sprite = $Sprite2D
enum NpcState {
	Patrol,
	Chase,
	Return,
}
var currentState: NpcState = NpcState.Patrol
var initRotation: float
var patrolIndex: int = -1

var objectsInScanRegion: Array[CollisionObject2D] = []
var chaseTarget: Node2D
var lastSeen: Vector2

func _ready() -> void:
	waitTimer.start(waitTime)
	initRotation = rotation
func start_patrol() -> void:
	if not patrolNodeParent: return
	patrolIndex += 1
	
	if patrolIndex >= patrolNodeParent.get_child_count(): patrolIndex = 0
	if patrolNodeParent.get_child_count() > 0:
		print("at index", patrolIndex)
		NavAgent.target_position = (patrolNodeParent.get_child(patrolIndex) as Node2D).global_position
		print("going to ", NavAgent.target_position)
	
#func _draw() -> void:
	#draw_line(Vector2.ZERO, get_angle() * Vector2.UP * 250, Color.ALICE_BLUE)
func _process(_delta: float) -> void:
	if InventoryManager.instance.paused: return
	match currentState:
		NpcState.Patrol:
			#print("patrolling")
			if is_moving():
				navMove()
			var scanResult = scan_for_player()
			if scanResult:
				enter_chase(scanResult)
		NpcState.Chase:
			#print("chasing")
			NavAgent.target_position = lastSeen
			waitTimer.stop()
			if is_moving():
				navMove(0.25)
			var scanResult = scan_for_player()
			if not scanResult:
				if NavAgent.is_navigation_finished():
					currentState = NpcState.Patrol
					start_patrol()
			else:
				lastSeen = scanResult.global_position

			
func scan_for_player() -> CollisionObject2D:
	#rn just raycast
	for ray in raychecks:
		ray.force_raycast_update()
		if ray.is_colliding():
			#print("ray hit something")
			var collider = ray.get_collider()
			if collider.is_in_group("Player"):
				return collider
	#print("no player found")
	return null
func enter_chase(target: CollisionObject2D) -> void:
	print("Enter Chase")
	currentState = NpcState.Chase
	chaseTarget = target
	lastSeen = target.global_position
func get_dir() -> Vector2:
	var dest = NavAgent.get_next_path_position()
	return global_position.direction_to(dest)
func get_angle() -> float:
	return initRotation + get_dir().angle()
func is_moving() -> bool:
	return waitTimer.is_stopped()

func _on_wait_timer_timeout() -> void:
	print("wait time finished")
	start_patrol()


func _on_navigation_agent_2d_navigation_finished() -> void:
	print("nav finished")
	waitTimer.start(waitTime)

var tween: Tween
func navMove(turnSpeed = 0.3):
	velocity = get_dir() * walkSpeed
	move_and_slide()
	if tween and tween.is_running():
		tween.kill()
		tween = null
	
	tween = create_tween()
	tween.tween_property(self, "rotation", lerp_angle(rotation, get_angle(), 1), turnSpeed)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	InventoryManager.instance.set_game_over("caught by a guy")


func _on_area_2d_body_exited(body: Node2D) -> void:
	objectsInScanRegion.remove_at(objectsInScanRegion.find(body))


func _on_kill_zone_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and InventoryManager.instance and InventoryManager.instance.collected_gun:
			var player = get_tree().get_first_node_in_group("Player") as Node2D
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(player.global_position, global_position)
			query.collision_mask = 1 << 0 # only collide with the default layer
			# if no obstacles in the way, win
			if not space_state.intersect_ray(query):
				InventoryManager.instance.set_game_over("win")
			


func _on_kill_zone_mouse_entered() -> void:
	if InventoryManager.instance and InventoryManager.instance.collected_gun:
		sprite.modulate = Color.RED


func _on_kill_zone_mouse_exited() -> void:
	sprite.modulate = Color.WHITE
