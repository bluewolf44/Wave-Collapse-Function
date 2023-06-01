extends TileMap

var tiles: Array[Tile]
const MAP_SIZE := Vector2i(5,5)

var all_open_tiles := []

func _ready()-> void:
	tiles.append(Tile.new("Blank",Vector2i(0,0)))
	tiles.append(Tile.new("Stright",Vector2i(14,3)))
	tiles.append(Tile.new("StrightR",Vector2i(14,3)))
	tiles.append(Tile.new("Turn",Vector2i(15,3)))
	
	tiles[0].setAllDir("Blank")
	tiles[1].setDir("Line","Blank","Line","Blank")
	tiles[2].setDir("Blank","Line","Blank","Line")
	tiles[3].setDir("Blank","Line","Line","Blank")
	
	
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			all_open_tiles.append(tiles.duplicate())
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			await get_tree().create_timer(0.1).timeout
			
			set_tile(all_open_tiles[coordsToArray(Vector2i(x,y))].pick_random(),Vector2i(x,y))


func set_tile(tile:Tile,coords:Vector2i)->void:
	all_open_tiles[coordsToArray(coords)] = [tile]
	set_cell(tile.layer,coords,0,tile.tile_coord)
	print("set:",coords,tile)
	
	update_tiles(coords)

func update_tiles(coords:Vector2i)->void:
	var updated_places := []
	for n in range(4):
		var new_coords:Vector2 = coords+[Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)][n]
		if new_coords.x < 0 or new_coords.y < 0 or new_coords.x >= MAP_SIZE.x or new_coords.y >= MAP_SIZE.y:
			continue
		
		var remove_array := []
		for tile_num in all_open_tiles[coordsToArray(new_coords)]:
			var remove := true
			var dir : String
			
			match n:
				0: dir = tile_num.dir0
				1: dir = tile_num.dir1
				2: dir = tile_num.dir2
				3: dir = tile_num.dir3
			
			for tile in all_open_tiles[coordsToArray(coords)]:
				var side_dir : String
				match n:
					0: side_dir = tile.dir2
					1: side_dir = tile.dir3
					2: side_dir = tile.dir0
					3: side_dir = tile.dir1
				if dir == side_dir:
					remove = false
					break
			
			if remove:
				remove_array.append(tile_num)
		
		if(!remove_array.is_empty()):
			for remove in remove_array:
				all_open_tiles[coordsToArray(new_coords)].erase(remove)
			
			updated_places.append(new_coords)
	
	for up in updated_places:
		update_tiles(up)

	
func coordsToArray(coords:Vector2i) -> int:
	return MAP_SIZE.x*coords.y+coords.x

