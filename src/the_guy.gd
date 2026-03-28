extends CharacterBody2D

@export var patrolNodeParent: Node2D
@export var waitTime := 3
@export var walkSpeed = 250

@onready var NavAgent = $NavigationAgent2D
@onready var waitTimer = $WaitTimer

var patrolIndex: int = -1
func _ready() -> void:
	start_patrol()

func start_patrol() -> void:
	patrolIndex += 1
	if patrolIndex >= patrolNodeParent.get_child_count(): patrolIndex = 0
	if patrolNodeParent.get_child_count() > 0:
		print("at index", patrolIndex)
		NavAgent.target_position = (patrolNodeParent.get_child(patrolIndex) as Node2D).global_position
		print("going to ", NavAgent.target_position)
	

func _process(delta: float) -> void:
	if is_moving():
		var dest = NavAgent.get_next_path_position()
		var dir = global_position.direction_to(dest)
		velocity = dir * walkSpeed
		move_and_slide()

func is_moving() -> bool:
	return waitTimer.is_stopped()

func _on_wait_timer_timeout() -> void:
	print("wait time finished")
	start_patrol()


func _on_navigation_agent_2d_navigation_finished() -> void:
	print("nav finished")
	waitTimer.start(waitTime)
