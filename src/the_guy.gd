extends CharacterBody2D

@export var patrolNodeParent: Node2D
@export var waitTime := 3
@export var walkSpeed = 250

@onready var NavAgent = $NavigationAgent2D
@onready var waitTimer = $WaitTimer
@onready var raychecks: Array[RayCast2D] = [
	$RayCast2D, $RayCast2D2, $RayCast2D3
]
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
	patrolIndex += 1
	if patrolIndex >= patrolNodeParent.get_child_count(): patrolIndex = 0
	if patrolNodeParent.get_child_count() > 0:
		print("at index", patrolIndex)
		NavAgent.target_position = (patrolNodeParent.get_child(patrolIndex) as Node2D).global_position
		print("going to ", NavAgent.target_position)
	
func _draw() -> void:
	draw_line(Vector2.ZERO, get_angle() * Vector2.UP * 250, Color.ALICE_BLUE)
func _process(_delta: float) -> void:
	match currentState:
		NpcState.Patrol:
			if is_moving():
				navMove()
			var scanResult = scan_for_player()
			if scanResult:
				enter_chase(scanResult)
		NpcState.Chase:
			NavAgent.target_position = lastSeen
			
		NpcState.Return:
			pass
func scan_for_player() -> Player:
	#rn just raycast
	for ray in raychecks:
		ray.force_raycast_update()
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider is Player:
				return collider
	return null
func enter_chase(target: Player):
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
	if body not in objectsInScanRegion:
		objectsInScanRegion.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	objectsInScanRegion.remove_at(objectsInScanRegion.find(body))
