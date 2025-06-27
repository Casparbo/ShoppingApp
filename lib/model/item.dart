class Item {
	final String name;
	final String store;
	final String location;
	bool stocked = true;

	Item({required String name, required String store, required String location}):
		name = name.trim(),
		store = store.trim(),
		location = location.trim();

	String toCsv() {
		return "$name;$store;$location;$stocked";
	}

	static Item fromCsv(String csv) {
		List<String> fields = csv.split(";");

		Item item = Item(name: fields[0], store: fields[1], location: fields[2]);
		item.stocked = bool.parse(fields[3]);

		return item;
	}

	@override
	bool operator ==(Object other) =>
		other is Item &&
		other.name == name &&
		other.store == store &&
		other.location == location;

	@override
	int get hashCode => (name + store + location).hashCode;

	@override
	String toString() {
		return toCsv();
	}
}