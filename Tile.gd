class_name Tile
extends Resource

var name : String
var dir0 : String
var dir1 : String
var dir2 : String
var dir3 : String
var tile_coord : Vector2i
var weight : int
var layer: int

func _init(name:String,tile_coord:Vector2i,layer:=1,weight:=1) -> void:
	self.name = name
	self.tile_coord = tile_coord
	self.weight = weight
	self.layer = layer

func setDir(dir0:String,dir1:String,dir2:String,dir3:String)-> void:
	self.dir0 = dir0
	self.dir1 = dir1
	self.dir2 = dir2
	self.dir3 = dir3

func setAllDir(dir:String)-> void:
	self.dir0 = dir
	self.dir1 = dir
	self.dir2 = dir
	self.dir3 = dir



func _to_string()->String:
	return name
