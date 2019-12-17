package ogmo;

class Ext {
	public static inline function toValueMap(values:Dynamic):Map<String, Dynamic> {
		var valueMap = new Map();
		for (field in Reflect.fields(values))
			valueMap.set(field, Reflect.field(values, field));
		return valueMap;
	}

	public static inline function toStringMap(values:Dynamic):Map<String, String> {
		var valueMap = new Map();
		for (field in Reflect.fields(values))
			valueMap.set(field, cast Reflect.field(values, field));
		return valueMap;
	}
}
