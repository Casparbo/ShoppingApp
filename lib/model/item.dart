class Item {
	final String name;
	final String store;
	final String location;
	bool stocked = true;

	Item({required this.name, required this.store, required this.location});

	String toCsv() {
		return "$name;$store;$location;$stocked";
	}

	static fromCsv(String csv) {
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
}