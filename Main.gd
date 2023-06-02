extends TileMap

var tiles: Array[Tile]
const MAP_SIZE := Vector2i(20,20)

var all_open_tiles := []

func _ready()-> void:
	tiles.append(Tile.new("Blank",[Tile_Place.new(Vector2i(-1,-1),0,0)],["Blank","Blank","Blank","Blank"],2))
	tiles.append(Tile.new("Stright",[Tile_Place.new(Vector2i(14,3),0,0)],["Line","Blank","Line","Blank"],10))
	tiles.append(Tile.new("StrightT",[Tile_Place.new(Vector2i(14,3),0,1)],["Blank","Line","Blank","Line"],10))
	
	tiles.append(Tile.new("Turn0",[Tile_Place.new(Vector2i(15,3),0,0)],["Blank","Line","Line","Blank"],5))
	tiles.append(Tile.new("Turn1",[Tile_Place.new(Vector2i(15,3),0,1)],["Blank","Blank","Line","Line"],5))
	tiles.append(Tile.new("Turn2",[Tile_Place.new(Vector2i(15,3),0,2)],["Line","Blank","Blank","Line"],5))
	tiles.append(Tile.new("Turn3",[Tile_Place.new(Vector2i(15,3),0,3)],["Line","Line","Blank","Blank"],5))
	
	tiles.append(Tile.new("Stop0",[Tile_Place.new(Vector2i(13,3),0,0)],["Blank","Blank","Line","Blank"],1))
	tiles.append(Tile.new("Stop1",[Tile_Place.new(Vector2i(13,3),0,1)],["Blank","Blank","Blank","Line"],1))
	tiles.append(Tile.new("Stop2",[Tile_Place.new(Vector2i(13,3),0,2)],["Line","Blank","Blank","Blank"],1))
	tiles.append(Tile.new("Stop3",[Tile_Place.new(Vector2i(13,3),0,3)],["Blank","Line","Blank","Blank"],1))
	
	tiles.append(Tile.new("Up0",[Tile_Place.new(Vector2i(13,3),0,0),Tile_Place.new(Vector2i(13,3),1,2)],["Up","Blank","Line","Blank"],5))
	tiles.append(Tile.new("Up1",[Tile_Place.new(Vector2i(13,3),0,1),Tile_Place.new(Vector2i(13,3),1,3)],["Blank","Up","Blank","Line"],5))
	tiles.append(Tile.new("Up2",[Tile_Place.new(Vector2i(13,3),0,2),Tile_Place.new(Vector2i(13,3),1,0)],["Line","Blank","Up","Blank"],5))
	tiles.append(Tile.new("Up3",[Tile_Place.new(Vector2i(13,3),0,3),Tile_Place.new(Vector2i(13,3),1,1)],["Blank","Line","Blank","Up"],5))
	
	tiles.append(Tile.new("UpStright",[Tile_Place.new(Vector2i(14,3),1,0)],["Up","Blank","Up","Blank"],10))
	tiles.append(Tile.new("UpStrightT",[Tile_Place.new(Vector2i(14,3),1,1)],["Blank","Up","Blank","Up"],10))
	
	tiles.append(Tile.new("UpDown",[Tile_Place.new(Vector2i(14,3),1,0),Tile_Place.new(Vector2i(14,3),0,1)],["Up","Line","Up","Line"],10))
	tiles.append(Tile.new("UpDownT",[Tile_Place.new(Vector2i(14,3),1,1),Tile_Place.new(Vector2i(14,3),0,0)],["Line","Up","Line","Up"],10))
	
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			all_open_tiles.append(tiles.duplicate())
			set_cell(0,Vector2i(x,y),0,Vector2i(0,0))
	
	var unused := get_used_cells_by_id(0,0,Vector2i(0,0))#,Vector2i(0,0))
	while !unused.is_empty():
		var current = unused.pick_random()
		await get_tree().create_timer(0.001).timeout
		set_tile(weighted_tile_pick(all_open_tiles[coordsToArray(current)]),current)
		update_tiles(current)
		
		unused = get_used_cells_by_id(0,0,Vector2i(0,0))
	print("Done")


func set_tile(tile:Tile,coords:Vector2i)->void:
	all_open_tiles[coordsToArray(coords)] = [tile]
	for tile_place in tile.tiles_places:
		set_cell(tile_place.layer,coords,0,tile_place.tile_coord,tile_place.alt)

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
		if all_open_tiles[coordsToArray(up)].size() == 1:
			set_tile(all_open_tiles[coordsToArray(up)][0],up)
		
		update_tiles(up)

	
func coordsToArray(coords:Vector2i) -> int:
	return MAP_SIZE.x*coords.y+coords.x

func weighted_tile_pick(tileArray:Array) -> Tile:
	var total:=0
	for tile in tileArray:
		total += tile.weight
	
	var current := randi() % total
	total = 0
	for tile in tileArray:
		total += tile.weight
		if current <= total:
			return tile
	
	return tileArray[-1]
