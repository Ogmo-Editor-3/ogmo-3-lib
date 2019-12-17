package ogmo;

import haxe.Json;
import ogmo.Types;

using ogmo.Ext;

@:structInit
class EntityDefinition {
	public var name:String;
	public var id:Int;
	@:alias("_eid") public var exportID:String;
	public var x:Float;
	public var y:Float;
	@:optional public var width:Null<Float>;
	@:optional public var height:Null<Float>;
	@:optional public var originX:Null<Float>;
	@:optional public var originY:Null<Float>;
	@:optional public var rotation:Null<Float>;
	@:optional public var flippedX:Null<Bool>;
	@:optional public var flippedY:Null<Bool>;
	@:optional public var nodes:Null<Array<{x:Float, y:Float}>>;
	@:optional public var values:Null<Map<String, Dynamic>>;
}

@:structInit
class DecalDefinition {
	public var x:Float;
	public var y:Float;
	public var texture:String;
	@:optional public var rotation:Null<Float>;
	@:optional public var scaleX:Null<Float>;
	@:optional public var scaleY:Null<Float>;
}

@:structInit
class LayerDefinition {
	public var name:String;
	@:alias("_eid") public var exportID:String;
	public var offsetX:Float;
	public var offsetY:Float;
	public var gridCellWidth:Int;
	public var gridCellHeight:Int;
	public var gridCellsX:Int;
	public var gridCellsY:Int;
	@:optional public var data:Null<Array<Int>>;
	@:optional public var data2D:Null<Array<Array<Int>>>;
	@:optional public var dataCoords:Null<Array<Array<Int>>>;
	@:optional public var dataCoords2D:Null<Array<Array<Array<Int>>>>;
	@:optional public var grid:Null<Array<String>>;
	@:optional public var grid2D:Null<Array<Array<String>>>;
	@:optional public var entities:Null<Array<EntityDefinition>>;
	@:optional public var decals:Null<Array<DecalDefinition>>;
	@:optional public var exportMode:Null<ExportMode>;
	@:optional public var arrayMode:Null<ArrayMode>;
	@:optional public var tileset:Null<String>;
	@:optional public var folder:Null<String>;
}

@:structInit
class Level {
	/**
	 * Width of the Level.
	 */
	public var width:Float;

	/**
	 * Height of the Level.
	 */
	public var height:Float;

	/**
	 * Offset of the Level on the X axis. Useful for loading multiple chunked Levels.
	 */
	public var offsetX:Float;

	/**
	 * Offset of the Level on the Y axis. Useful for loading multiple chunked Levels.
	 */
	public var offsetY:Float;

	/**
	 * Array containing all of the Level's Layer Definitions.
	 */
	public var layers:Array<LayerDefinition>;

	/**
	 * Array containing all of the Level's custom values.
	 */
	public var values:Null<Map<String, Dynamic>>;

	/**
	 * Callback triggered when a Decal layer is found after calling `load()` on a Level.
	 *
	 * The first argument is an Array holding the Layer's Decal Definitions.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onDecalLayerLoaded:Array<DecalDefinition>->LayerDefinition->Void;

	/**
	 * Callback triggered when an Entity layer is found after calling `load()` on a Level.
	 *
	 * The first argument is an Array holding the Layer's Entity Definitions.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onEntityLayerLoaded:Array<EntityDefinition>->LayerDefinition->Void;

	/**
	 * Callback triggered when a Grid layer exported with a 1D Data Array is found after calling `load()` on a Level.
	 *
	 * The first argument is a 1D Array holding the Layer's Grid Data.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onGridLayerLoaded:Array<String>->LayerDefinition->Void;

	/**
	 * Callback triggered when a Grid layer exported with a 2D Data Array is found after calling `load()` on a Level.
	 *
	 * The first argument is a 2D Array holding the Layer's Grid Data.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onGrid2DLayerLoaded:Array<Array<String>>->LayerDefinition->Void;

	/**
	 * Callback triggered when a Tile layer exported with a 1D Data Array containing Tile IDs is found after calling `load()` on a Level.
	 *
	 * The first argument is a 1D Array holding the Layer's Tile ID Data.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onTileLayerLoaded:Array<Int>->LayerDefinition->Void;

	/**
	 * Callback triggered when a Tile layer exported with a 2D Data Array containing Tile IDs is found after calling `load()` on a Level.
	 *
	 * The first argument is a 2D Array holding the Layer's Tile ID Data.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onTile2DLayerLoaded:Array<Array<Int>>->LayerDefinition->Void;

	/**
	 * Callback triggered when a Tile layer exported with a 2D Data Array containing Tile Coords is found after calling `load()` on a Level.
	 *
	 * The first argument is a 2D Array holding the Layer's Tile Cordinate Data.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onTileCoordsLayerLoaded:Array<Array<Int>>->LayerDefinition->Void;

	/**
	 * Callback triggered when a Tile layer exported with a 3D Data Array containing Tile Coords is found after calling `load()` on a Level.
	 *
	 * The first argument is a 3D Array holding the Layer's Tile Coords Data.
	 * The second argument is the Layer Definition itself.
	 */
	@:optional public var onTileCoords2DLayerLoaded:Array<Array<Array<Int>>>->LayerDefinition->Void;

	/**
	 * Creates a Level with `.json` data from Ogmo.
	 * @param json String holding Ogmo Level Json data.
	 * @return Level parsed from Json.
	 */
	public static function create(json:String):Level {
		var data = Json.parse(json);

		return {
			width: data.width,
			height: data.height,
			offsetX: data.offsetX,
			offsetY: data.offsetY,
			layers: [
				for (layer in (cast data.layers : Array<Dynamic>))
					{
						exportID: layer._eid,
						name: layer.name,
						offsetX: layer.offsetX,
						offsetY: layer.offsetY,
						gridCellWidth: layer.gridCellWidth,
						gridCellHeight: layer.gridCellHeight,
						gridCellsX: layer.gridCellsX,
						gridCellsY: layer.gridCellY,
						data: layer.data,
						data2D: layer.data2D,
						dataCoords: layer.dataCoords,
						dataCoords2D: layer.dataCoords2D,
						grid: layer.grid,
						grid2D: layer.grid2D,
						entities: layer.entities == null ? null : [
							for (entity in (cast layer.entities : Array<Dynamic>))
								{
									name: entity.name,
									id: entity.id,
									exportID: entity._eid,
									x: entity.x,
									y: entity.y,
									width: entity.width,
									height: entity.height,
									originX: entity.originX,
									originY: entity.originY,
									rotation: entity.rotation,
									flippedX: entity.flippedX,
									flippedY: entity.flippedY,
									nodes: entity.nodes,
									values: entity.values == null ? null : entity.values.toValueMap()
								}
						],
						decals: layer.decals == null ? null : [
							for (decal in (cast layer.decals : Array<Dynamic>))
								{
									x: decal.x,
									y: decal.y,
									texture: decal.texture,
									rotation: decal.rotation,
									scaleX: decal.scaleX,
									scaleY: decal.scaleY
								}
						],
						exportMode: layer.exportMode,
						arrayMode: layer.arrayMode,
						tileset: layer.tileset,
						folder: layer.folder,
					}
			],
			values: data.values == null ? new Map() : (cast data.values : Dynamic).toValueMap()
		}
	}

	/**
	 * Loops through all layers, triggering each layer's callback if defined on this Level.
	 *
	 * Available Callbacks:
	 * ```
	 * onTileLayerLoaded()
	 * onTile2DLayerLoaded()
	 * onTileCoordsLayerLoaded()
	 * onTileCoords2DLayerLoaded()
	 * onDecalLayerLoaded()
	 * onEntityLayerLoaded()
	 * onGridLayerLoaded()
	 * onGrid2DLayerLoaded()
	 * ```
	 */
	public function load() {
		for (layer in layers) {
			if (layer.data != null) {
				if (onTileLayerLoaded != null)
					onTileLayerLoaded(layer.data, layer);
			} else if (layer.data2D != null) {
				if (onTile2DLayerLoaded != null)
					onTile2DLayerLoaded(layer.data2D, layer);
			} else if (layer.dataCoords != null) {
				if (onTileCoordsLayerLoaded != null)
					onTileCoordsLayerLoaded(layer.dataCoords, layer);
			} else if (layer.dataCoords2D != null) {
				if (onTileCoords2DLayerLoaded != null)
					onTileCoords2DLayerLoaded(layer.dataCoords2D, layer);
			} else if (layer.grid != null) {
				if (onGridLayerLoaded != null)
					onGridLayerLoaded(layer.grid, layer);
			} else if (layer.grid2D != null) {
				if (onGrid2DLayerLoaded != null)
					onGrid2DLayerLoaded(layer.grid2D, layer);
			} else if (layer.decals != null) {
				if (onDecalLayerLoaded != null)
					onDecalLayerLoaded(layer.decals, layer);
			} else if (layer.entities != null) {
				if (onEntityLayerLoaded != null)
					onEntityLayerLoaded(layer.entities, layer);
			}
		}
	}
}
