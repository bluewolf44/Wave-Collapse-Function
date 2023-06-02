class_name Tile
extends Resource

var name : String
var dir : Array
var tiles_places : Array
var weight : int

func _init(name:String,tiles_places:Array,dir:Array,weight:=1) -> void:
	self.name = name
	self.tiles_places = tiles_places
	self.dir = dir
	self.weight = weight

func _to_string()->String:
	return name
