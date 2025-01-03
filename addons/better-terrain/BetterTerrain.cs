using Godot;
using Godot.Collections;

#nullable disable

/*

This is a lightweight wrapper for Better Terrain in C#.

It is not a C# implementation, it merely provides a type safe interface to access
the BetterTerrain autoload from C#. If you are not using Godot in C#, you can ignore
this file.

The interface is created for a specific tilemap node, which it uses to locate the
autoload, and to fill in as a parameter to simplify all the subsequent calls.
Very simple example:

```
	BetterTerrain betterTerrain;

	public override void _Ready()
	{
		TileMapLayer tileMapLayer = GetNode<TileMapLayer>("TileMapLayer");
		betterTerrain = new BetterTerrain(tm);

		var coordinates = new Vector2I(0, 0);
		betterTerrain.SetCell(coordinates, 1);
		betterTerrain.UpdateTerrainCell(coordinates);
	}
```

The functions available are the same as BetterTerrain's, though the TileMapLayer or
TileSet parameters are automatically filled in. The help is not duplicated here,
refer to the GDScript version for specifics.

*/

public class BetterTerrain
{
	public enum TerrainType
	{
		MatchTiles = 0,
		MatchVertices = 1,
		Category = 2,
		Decoration = 3
	}

	public enum SymmetryType
	{
		None = 0,
		Mirror = 1, // Horizontally mirror
		Flip = 2, // Vertically flip
		Reflect = 3, // All four reflections
		RotateClockwise = 4,
		RotateCounterClockwise = 5,
		Rotate180 = 6,
		RotateAll = 7, // All four rotated forms
		All = 8 // All rotated and reflected forms
	}

	private static readonly NodePath nodePath = new("/root/BetterTerrain");
	private readonly Node betterTerrain;
	private readonly TileMapLayer tileMapLayer;

	public BetterTerrain(TileMapLayer tileMapLayer)
	{
		this.tileMapLayer = tileMapLayer;
		betterTerrain = tileMapLayer.GetNode(nodePath);
	}

	public Array<Godot.Collections.Dictionary<string, Variant>> GetTerrainCategories()
	{
		return (Array<Godot.Collections.Dictionary<string, Variant>>)betterTerrain.Call(MethodName.GetTerrainCategories, tileMapLayer.TileSet);
	}

	public bool AddTerrain(string name, Color color, TerrainType type, Array<int> categories = null, Godot.Collections.Dictionary<Variant, Variant> icon = null)
	{
		categories ??= new Array<int>();
		icon ??= new Godot.Collections.Dictionary<Variant, Variant>();
		return (bool)betterTerrain.Call(MethodName.AddTerrain, tileMapLayer.TileSet, name, color, (int)type, categories, icon);
	}

	public bool RemoveTerrain(int index)
	{
		return (bool)betterTerrain.Call(MethodName.RemoveTerrain, tileMapLayer.TileSet, index);
	}

	public int TerrainCount()
	{
		return (int)betterTerrain.Call(MethodName.TerrainCount, tileMapLayer.TileSet);
	}

	public Godot.Collections.Dictionary<string, Variant> GetTerrain(int index)
	{
		return (Godot.Collections.Dictionary<string, Variant>)betterTerrain.Call(MethodName.GetTerrain, tileMapLayer.TileSet, index);
	}

	public bool SetTerrain(int index, string name, Color color, TerrainType type, Array<int> categories = null, Godot.Collections.Dictionary<Variant, Variant> icon = null)
	{
		categories ??= new Array<int>();
		icon ??= new Godot.Collections.Dictionary<Variant, Variant>();
		return (bool)betterTerrain.Call(MethodName.SetTerrain, tileMapLayer.TileSet, index, name, color, (int)type, categories, icon);
	}

	public bool SwapTerrains(int index1, int index2)
	{
		return (bool)betterTerrain.Call(MethodName.SwapTerrains, tileMapLayer.TileSet, index1, index2);
	}

	public bool SetTileTerrainType(TileData tileData, int type)
	{
		return (bool)betterTerrain.Call(MethodName.SetTileTerrainType, tileMapLayer.TileSet, tileData, type);
	}

	public int GetTileTerrainType(TileData tileData)
	{
		return (int)betterTerrain.Call(MethodName.GetTileTerrainType, tileData);
	}

	public bool SetTileSymmetryType(TileData tileData, SymmetryType type)
	{
		return (bool)betterTerrain.Call(MethodName.SetTileSymmetryType, tileMapLayer.TileSet, tileData, (int)type);
	}

	public SymmetryType GetTileSymmetryType(TileData tileData)
	{
		return (SymmetryType)(int)betterTerrain.Call(MethodName.GetTileSymmetryType, tileData);
	}

	public Array<TileData> GetTilesInTerrain(int type)
	{
		return (Array<TileData>)betterTerrain.Call(MethodName.GetTilesInTerrain, tileMapLayer.TileSet, type);
	}

	public Array<Godot.Collections.Dictionary<string, Variant>> GetTileSourcesInTerrain(int type)
	{
		return (Array<Godot.Collections.Dictionary<string, Variant>>)betterTerrain.Call(MethodName.GetTileSourcesInTerrain, tileMapLayer.TileSet, type);
	}

	public bool AddTilePeeringType(TileData tileData, TileSet.CellNeighbor peering, int type)
	{
		return (bool)betterTerrain.Call(MethodName.AddTilePeeringType, tileMapLayer.TileSet, tileData, (int)peering, type);
	}

	public bool RemoveTilePeeringType(TileData tileData, TileSet.CellNeighbor peering, int type)
	{
		return (bool)betterTerrain.Call(MethodName.RemoveTilePeeringType, tileMapLayer.TileSet, tileData, (int)peering, type);
	}

	public Array<TileSet.CellNeighbor> TilePeeringKeys(TileData tileData)
	{
		return (Array<TileSet.CellNeighbor>)betterTerrain.Call(MethodName.TilePeeringKeys, tileData);
	}

	public Array<int> TilePeeringTypes(TileData tileData, TileSet.CellNeighbor peering)
	{
		return (Array<int>)betterTerrain.Call(MethodName.TilePeeringTypes, tileData, (int)peering);
	}

	public Array<TileSet.CellNeighbor> TilePeeringForType(TileData tileData, int type)
	{
		return (Array<TileSet.CellNeighbor>)betterTerrain.Call(MethodName.TilePeeringForType, tileData, type);
	}

	public bool SetCell(Vector2I coordinate, int type)
	{
		return (bool)betterTerrain.Call(MethodName.SetCell, tileMapLayer, coordinate, type);
	}

	public bool SetCells(Array<Vector2I> coordinates, int type)
	{
		return (bool)betterTerrain.Call(MethodName.SetCells, tileMapLayer, coordinates, type);
	}

	public bool ReplaceCell(Vector2I coordinate, int type)
	{
		return (bool)betterTerrain.Call(MethodName.ReplaceCell, tileMapLayer, coordinate, type);
	}

	public bool ReplaceCells(Array<Vector2I> coordinates, int type)
	{
		return (bool)betterTerrain.Call(MethodName.ReplaceCells, tileMapLayer, coordinates, type);
	}

	public int GetCell(Vector2I coordinate)
	{
		return (int)betterTerrain.Call(MethodName.GetCell, tileMapLayer, coordinate);
	}

	public void UpdateTerrainCells(Array<Vector2I> cells, bool updateSurroundingCells = true)
	{
		betterTerrain.Call(MethodName.UpdateTerrainCells, tileMapLayer, cells, updateSurroundingCells);
	}

	public void UpdateTerrainCell(Vector2I cell, bool updateSurroundingCells = true)
	{
		betterTerrain.Call(MethodName.UpdateTerrainCell, tileMapLayer, cell, updateSurroundingCells);
	}

	public void UpdateTerrainArea(Rect2I area, bool updateSurroundingCells = true)
	{
		betterTerrain.Call(MethodName.UpdateTerrainArea, tileMapLayer, area, updateSurroundingCells);
	}

	public Godot.Collections.Dictionary<Variant, Variant> CreateTerrainChangeset(Godot.Collections.Dictionary<Vector2I, int> paint)
	{
		return (Godot.Collections.Dictionary<Variant, Variant>)betterTerrain.Call(MethodName.CreateTerrainChangeset, tileMapLayer, paint);
	}

	public bool IsTerrainChangesetReady(Godot.Collections.Dictionary<Variant, Variant> changeset)
	{
		return (bool)betterTerrain.Call(MethodName.IsTerrainChangesetReady, changeset);
	}

	public void WaitForTerrainChangeset(Godot.Collections.Dictionary<Variant, Variant> changeset)
	{
		betterTerrain.Call(MethodName.WaitForTerrainChangeset, changeset);
	}

	public void ApplyTerrainChangeset(Godot.Collections.Dictionary<Variant, Variant> changeset)
	{
		betterTerrain.Call(MethodName.ApplyTerrainChangeset, changeset);
	}

	private static class MethodName
	{
		public static readonly StringName GetTerrainCategories = "get_terrain_categories";
		public static readonly StringName AddTerrain = "add_terrain";
		public static readonly StringName RemoveTerrain = "remove_terrain";
		public static readonly StringName TerrainCount = "terrain_count";
		public static readonly StringName GetTerrain = "get_terrain";
		public static readonly StringName SetTerrain = "set_terrain";
		public static readonly StringName SwapTerrains = "swap_terrains";
		public static readonly StringName SetTileTerrainType = "set_tile_terrain_type";
		public static readonly StringName GetTileTerrainType = "get_tile_terrain_type";
		public static readonly StringName SetTileSymmetryType = "set_tile_symmetry_type";
		public static readonly StringName GetTileSymmetryType = "get_tile_symmetry_type";
		public static readonly StringName GetTilesInTerrain = "get_tiles_in_terrain";
		public static readonly StringName GetTileSourcesInTerrain = "get_tile_sources_in_terrain";
		public static readonly StringName AddTilePeeringType = "add_tile_peering_type";
		public static readonly StringName RemoveTilePeeringType = "remove_tile_peering_type";
		public static readonly StringName TilePeeringKeys = "tile_peering_keys";
		public static readonly StringName TilePeeringTypes = "tile_peering_types";
		public static readonly StringName TilePeeringForType = "tile_peering_for_type";
		public static readonly StringName SetCell = "set_cell";
		public static readonly StringName SetCells = "set_cells";
		public static readonly StringName ReplaceCell = "replace_cell";
		public static readonly StringName ReplaceCells = "replace_cells";
		public static readonly StringName GetCell = "get_cell";
		public static readonly StringName UpdateTerrainCells = "update_terrain_cells";
		public static readonly StringName UpdateTerrainCell = "update_terrain_cell";
		public static readonly StringName UpdateTerrainArea = "update_terrain_area";
		public static readonly StringName CreateTerrainChangeset = "create_terrain_changeset";
		public static readonly StringName IsTerrainChangesetReady = "is_terrain_changeset_ready";
		public static readonly StringName WaitForTerrainChangeset = "wait_for_terrain_changeset";
		public static readonly StringName ApplyTerrainChangeset = "apply_terrain_changeset";
	}
}
