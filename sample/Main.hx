import h2d.Graphics;
import h2d.TileGroup;
import h2d.Bitmap;
import h2d.Tile;

class Main extends hxd.App 
{
	override function init() 
	{
		// Set the window's background color
		engine.backgroundColor = 0xffffff;

		// Use `Project.create()` to parse an Ogmo Project file and get it's values.
    var project = ogmo.Project.create(hxd.Res.test.entry.getText());

		// Use `Level.create()` to parse an Ogmo Level file and get it's values.
    var level = ogmo.Level.create(hxd.Res.levels.uno.entry.getText());
		
		// Get the Tileset Image
		var tileImage = hxd.Res.img.tiles.toTile();
		// Subtile the Tileset Image into 16x16 tiles
		var tileSize = 16;
		var tileset = [
        for(y in 0 ... Std.int(tileImage.height / tileSize))
        for(x in 0 ... Std.int(tileImage.width / tileSize))
        tileImage.sub(x * 16, y * tileSize, tileSize, tileSize)
      ];

		// Register a callback function for any Tile layers exported as a 1D Array containing IDs.
		level.onTileLayerLoaded = (tiles, layer) -> 
		{
			var tileGroup = new TileGroup(tileImage, s2d);
			tileGroup.x += layer.offsetX;
			tileGroup.y += layer.offsetY;

			for (i in 0...tiles.length) 
			{
				if (tiles[i] > -1) 
				{
					var x = i % layer.gridCellsX;
					var y = Math.floor(i / layer.gridCellsX);
					tileGroup.add(x * layer.gridCellWidth, y * layer.gridCellHeight, tileset[tiles[i]]);
				}
			}
		}

		// Register a callback function for any Tile layers exported as a 2D Array containing IDs.
		level.onTile2DLayerLoaded = (tiles, layer) -> 
		{
			var tileGroup = new TileGroup(tileImage, s2d);
			tileGroup.x += layer.offsetX;
			tileGroup.y += layer.offsetY;

			for (x in 0...tiles.length) for (y in 0...tiles[x].length)
			{
				if (tiles[x][y] > -1) tileGroup.add(x * layer.gridCellWidth, y * layer.gridCellHeight, tileset[tiles[x][y]]);
			}
		}

		// Register a callback function for any Tile layers exported as a 1D Array containing Coords.
		level.onTileCoordsLayerLoaded = (tiles, layer) -> 
		{
			// TODO - example of loading Tile Layer with 1D Array of Coords
		}

		// Register a callback function for any Tile layers exported as a 2D Array containing Coords.
		level.onTileCoords2DLayerLoaded = (tiles, layer) -> 
		{
			// TODO - example of loading Tile Layer with 2D Array of Coords
		}

		// Register a callback function for any Grid layers exported as a 1D Array.
		level.onGridLayerLoaded = (grid, layer) -> 
		{
			var graphic = new Graphics(s2d);
			graphic.x += layer.offsetX;
			graphic.y += layer.offsetY;

			graphic.beginFill();

			for (i in 0...grid.length) 
			{
				if (grid[i] == "0") continue;
				var x = i % layer.gridCellsX;
				var y = Math.floor(i / layer.gridCellsX);
				
				graphic.drawRect(x * layer.gridCellWidth, y * layer.gridCellHeight, layer.gridCellWidth, layer.gridCellHeight);
			}

			graphic.endFill();
		}

		// Register a callback function for any Grid layers exported as a 2D Array.
		level.onGrid2DLayerLoaded = (grid, layer) -> 
		{
			var graphic = new Graphics(s2d);
			graphic.x += layer.offsetX;
			graphic.y += layer.offsetY;

			graphic.beginFill();

			for (x in 0...grid.length) for (y in 0...grid[x].length)
			{
				if (grid[x][y] != "0") graphic.drawRect(x * layer.gridCellWidth, y * layer.gridCellHeight, layer.gridCellWidth, layer.gridCellHeight);
			}

			graphic.endFill();
		}

		// Register a callback function for any Entity layers.
		level.onEntityLayerLoaded = (entities, layer) -> 
		{
			for (entity in entities) {
				var e = new Bitmap(Tile.fromColor(0xFF0000, entity.width == null ? 16: 16, entity.height == null ? 16: 16), s2d);
				e.name = entity.name;
				e.setPosition(entity.x + layer.offsetX, entity.y + layer.offsetY);
			}
		}

		// Register a callback function for any Decal layers.
		level.onDecalLayerLoaded = (decals, layer) -> 
		{
			for (decal in decals) {
				var e = new Bitmap(hxd.Res.load('img/${decal.texture}').toTile(), s2d);
				e.tile.dx -= e.tile.width * 0.5;
				e.tile.dy -= e.tile.height * 0.5;
				e.setPosition(decal.x + layer.offsetX, decal.y + layer.offsetY);
			}
		}

		// Call `load()` on the Level to parse through each layer, triggering any layers have callbacks registered
		level.load();
	}

	static function main() 
	{
    hxd.Res.initEmbed();
		new Main();
	}
}
