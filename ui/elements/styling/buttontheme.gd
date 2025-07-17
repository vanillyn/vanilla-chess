class_name ButtonTheme
extends Resource

# texture and font
@export var background_texture: Texture2D
@export var font: Font

# state colors
@export var text_color: Color = Color.WHITE
@export var hover_color: Color = Color(1.2, 1.2, 1.2)
@export var press_color: Color = Color(0.8, 0.8, 0.8)
@export var disabled_color: Color = Color(0.5, 0.5, 0.5)

# shadow variables
@export var shadow_color: Color = Color(0, 0, 0, 0.5)
@export var shadow_offset_x: float = 2.0
@export var shadow_offset_y: float = 2.0

# margins and size variables
@export var patch_margin_left: int = 4
@export var patch_margin_right: int = 4
@export var patch_margin_top: int = 4
@export var patch_margin_bottom: int = 4
@export var minimum_size: Vector2 = Vector2(64, 64)

# sound effects (eventually)
@export var hover_sound: AudioStream
@export var press_sound: AudioStream
