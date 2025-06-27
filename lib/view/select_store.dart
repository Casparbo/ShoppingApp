import 'package:flutter/material.dart';
import 'dart:collection';

class SelectStore extends StatefulWidget {
	final Color themeColor;
	final HashSet<String> stores;
	final Function(String store) shopStore;

	const SelectStore({
		super.key,
		required this.themeColor,
		required this.stores,
		this.shopStore = _defaultShopStore
	});

	static void _defaultShopStore(String store) {}

  @override
  State<SelectStore> createState() => _SelectStoreState();
}

class _SelectStoreState extends State<SelectStore> {
	String selectedStore = "ALL";

	@override
	Widget build (BuildContext context) {
		return Scaffold (
			appBar: AppBar(
				backgroundColor: widget.themeColor,
				foregroundColor: Colors.white,
				title: const Text("Select Store")
			),
			body: Padding(
			  padding: const EdgeInsets.all(20),
			  child: Center(
	  	            child: DropdownMenu<String>(
  	                textStyle: const TextStyle(color: Colors.black),
  	                inputDecorationTheme: const InputDecorationTheme(
  	                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  	                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  	                  suffixIconColor: Colors.black,
  	                ),
  	                width: double.infinity,
  	                initialSelection: selectedStore,
  	                onSelected: (String? value) {
  	                  setState(() {
  	                    selectedStore = value!;
  	                  });
  	                },
  	                dropdownMenuEntries: widget.stores.map<DropdownMenuEntry<String>>((String value) {
  	                  return DropdownMenuEntry<String>(value: value, label: value);
  	                }).toList()..sort((a, b) {
  	                    if(a.value=="ALL") {
  	                      return -1;
  	                    }
  	                    if(b.value=="ALL") {
  	                      return 1;
  	                    }
  	                    return 0;
  	                  }),
	  	            )
	  		    ),
			),
		    floatingActionButton: FloatingActionButton(
		    	onPressed: () => widget.shopStore(selectedStore),
		    	foregroundColor: Colors.white,
		    	backgroundColor: widget.themeColor,
		    	child: const Icon(Icons.check),
		    ),
		);
	}
}