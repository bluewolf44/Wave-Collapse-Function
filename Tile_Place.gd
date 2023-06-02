class_name Tile_Place
extends Resource

var tile_coord : Vector2i
var layer : int
var alt : int

func _init(tile_coord:Vector2i,layer:int,alt:int) -> void:
	self.tile_coord = tile_coord
	self.layer = layer
	self.alt = alt
