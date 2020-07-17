extends Spatial

export var roof = false

func grow():
	$HexGrid.grow()

func spawn_booster():
	$HexGrid.spawn_booster()
