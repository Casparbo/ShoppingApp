import 'package:flutter/material.dart';
import 'package:shopping_app/model/item.dart';
import 'package:shopping_app/view/item_view.dart';

class Shopping extends StatefulWidget {
	final Color themeColor;
	final List<Item> items;
	final Function(List<Item> items) markAsStocked;

	const Shopping({
		super.key,
		required this.themeColor,
		required this.items,
		this.markAsStocked = _defaultMarkAsStocked,
	});

	static void _defaultMarkAsStocked(List<Item> items) {}

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
	@override
	Widget build (BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: widget.themeColor,
				foregroundColor: Colors.white,
				title: const Text("Shopping mode")
			),
			body: Center(
	            child: ItemView(
	              themeColor: widget.themeColor,
	              items: widget.items,
	              setItemStocked: (Item item, bool value) => setState(() {item.stocked = value;}),
	            ),
	        ),
	        bottomNavigationBar: BottomAppBar(
	        	color: widget.themeColor,
	        	child: FilledButton(
	        		onPressed: () => widget.markAsStocked(widget.items.where((item) => item.stocked).toList()),
	        		style: FilledButton.styleFrom(
	        			foregroundColor: Colors.white,
	        			backgroundColor: widget.themeColor,
	        			iconSize: 25,
	        		),
	        		child: const Icon(Icons.check),
        		),
        	),
		);
	}
}