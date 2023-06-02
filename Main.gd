extends TileMap

var tiles: Array[Tile]
const MAP_SIZE := Vector2i(50,50)

var all_open_tiles := []

func _ready()-> void:
	tiles.append(Tile.new("Blank",Vector2i(0,0),["Blank","Blank","Blank","Blank"]))
	tiles.append(Tile.new("Stright",Vector2i(14,3),["Line","Blank","Line","Blank"]))
	tiles.append(Tile.new("StrightT",Vector2i(14,3),["Blank","Line","Blank","Line"],1))
	
	tiles.append(Tile.new("Turn0",Vector2i(15,3),["Blank","Line","Line","Blank"]))
	tiles.append(Tile.new("Turn1",Vector2i(15,3),["Blank","Blank","Line","Line"],1))
	tiles.append(Tile.new("Turn2",Vector2i(15,3),["Line","Blank","Blank","Line"],2))
	tiles.append(Tile.new("Turn3",Vector2i(15,3),["Line","Line","Blank","Blank"],3))
	
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			all_open_tiles.append(tiles.duplicate())
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			await get_tree().create_timer(0.001).timeout
			set_tile(all_open_tiles[coordsToArray(Vector2i(x,y))].pick_random(),Vector2i(x,y))
			update_tiles(Vector2i(x,y))


func set_tile(tile:Tile,coords:Vector2i)->void:
	all_open_tiles[coordsToArray(coords)] = [tile]
	set_cell(tile.layer,coords,0,tile.tile_coord,tile.alternative)
	#print("set:",coords,tile)

func update_tiles(coords:Vector2i)->void:
	var updated_places := []
	for n in range(4):
		var new_coords:Vector2 = coords+[Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1),Vector2i(1,0)][n]
		if new_coords.x < 0 or new_coords.y < 0 or new_coords.x >= MAP_SIZE.x or new_coords.y >= MAP_SIZE.y:
			continue
		
		var remove_array := []
		for tile_num in all_open_tiles[coordsToArray(new_coords)]:
			var remove := true

			for tile in all_open_tiles[coordsToArray(coords)]:
				if tile_num.dir[n] == tile.dir[(n+2)%4]:
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

