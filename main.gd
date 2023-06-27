extends Node2D

@onready var camera:Camera2D = $Node2D/SubViewportContainer/SubViewport/Camera2D
@onready var image:Sprite2D = $Node2D/SubViewportContainer/SubViewport/Sprite2D2/imagen
@onready var sbp:SubViewport = $Node2D/SubViewportContainer/SubViewport
@onready var image_size = image.get_rect().size
@onready var vp_size = sbp.get_visible_rect().size

func _ready():
	camera.limit_top = -((image_size.y/2) + 1)
	camera.limit_bottom = ((image_size.y/2))
	camera.limit_left = -((image_size.x/2))
	camera.limit_right = ((image_size.x/2))

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		camera.position.y += 1
		print(camera.position)
	if Input.is_action_just_pressed("ui_down"):
		camera.position.y -= 1
		print(camera.position)

func _unhandled_input(event):
	
	var camera_off = camera.offset
	var camera_pos = camera.position
	var camera_zoom = camera.zoom
	var camera_img_size = image_size * camera_zoom
#	print("viewport size: %s" % vp_size)
	print("image size: %s" % image_size)
	print("camera position: %s" %camera_pos)
	print("camera offset: %s" % camera_off)
	print("camera zoom: %s" % camera_zoom)
	print("camera image zoom size: %s" % camera_img_size)
	
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		var rel_x = event.relative.x
		var rel_y = event.relative.y
		camera_pos.x -= rel_x
		camera_pos.y -= rel_y

		var x_offset = vp_size.x / (2 * camera.zoom.x)
		camera_pos.x = clamp(
			camera_pos.x,
			camera.limit_left + x_offset,
			camera.limit_right - x_offset)

		var y_offset = vp_size.y / (2 * camera.zoom.y)
		camera_pos.y = clamp(
			camera_pos.y,
			camera.limit_top + y_offset,
			camera.limit_bottom - y_offset)
		
		camera.position = camera_pos
	
	if event is InputEventMouseButton:
		if event.button_index in [4, 5]:
			# print(event)
			var camera_z = camera.zoom
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if camera_z.y > 2:
					return
				camera_z.x += 0.01 
				camera_z.y += 0.01 
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera_z.x -= 0.01 
				camera_z.y -= 0.01
			var new_camera_img_size = image_size * camera_z
			if new_camera_img_size.y >= vp_size.y:
				camera.zoom = camera_z 
