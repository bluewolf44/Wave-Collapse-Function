class_name Tile
extends Resource

var name : String
var dir : Array
var tile_coord : Vector2i
var weight : int
var layer: int
var alternative : int

func _init(name:String,tile_coord:Vector2i,dir:Array,alternative:= 0,layer:=1,weight:=1) -> void:
	self.name = name
	self.tile_coord = tile_coord
	self.dir = dir
	self.weight = weight
	self.layer = layer
	self.alternative = alternative


func _to_string()->String:
	return name
