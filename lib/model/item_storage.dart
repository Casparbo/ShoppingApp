import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:shopping_app/model/item.dart';

class ItemStorage {
	late File file;

	ItemStorage._(this.file);

	static Future<ItemStorage> create(String filename) async {
		Directory dir = await getApplicationDocumentsDirectory();
		String p = join(dir.absolute.path, filename);
    	File file = File(p);
    	return ItemStorage._(file);
	}

	Future<List<Item>> readItems() async {
		List<Item> items = <Item>[];

		String contents = await file.readAsString();
		List<String> lines = contents.split("\n");

		for(String line in lines) {
			if(line.isNotEmpty) {
				items.add(Item.fromCsv(line));
			}
		}

		return items;
	}

	void writeItems(List<Item> items) {
		String csv = _itemsToCsv(items);

		file.writeAsString(csv);
	}

	String _itemsToCsv(List<Item> items) {
		String csv = "";

		for(Item item in items) {
			csv += "${item.toCsv()}\n";
		}
		return csv;
	}
}