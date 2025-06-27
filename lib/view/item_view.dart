import 'package:flutter/material.dart';
import 'package:shopping_app/model/item.dart';

class ItemView extends StatefulWidget {
	final List<Item> items;
	final Color themeColor;
	final Function(Item item, bool value) setItemStocked;
	final Function(Item item) deleteItem;

	const ItemView({
		super.key, 
		required this.items,
		required this.themeColor,
		this.setItemStocked = _defaultItemStocked,
		this.deleteItem = _defaultDeleteItem
	});

	static void _defaultItemStocked(Item item, bool value) {}
	static void _defaultDeleteItem(Item item) {}

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
	Color buttonColors(Set<WidgetState> states) {
		Color red = Colors.red.withValues(alpha: 0.5);
		Color green = widget.themeColor.withValues(alpha: 0.5);

		const Set<WidgetState> interactiveStates = <WidgetState>{
			WidgetState.pressed,
			WidgetState.hovered,
			WidgetState.focused,
		};
		if (states.any(interactiveStates.contains)) {
			return red;
		}
		return green;
	}

	@override
	Widget build(BuildContext context) {
		return ListView.separated(
			padding: const EdgeInsets.all(12),
			itemCount: widget.items.length,
			itemBuilder: (BuildContext context, int index) {
				List<Widget> children = [
					Expanded(
				    	child: Text(
					    	widget.items.elementAt(index).name,
					    	style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
					    ),
				    ),
				    Checkbox(
				    	fillColor: WidgetStateColor.resolveWith(buttonColors),
				    	value: widget.items.elementAt(index).stocked,
				    	onChanged: (bool? value) {
				    		widget.setItemStocked(widget.items.elementAt(index), value!);
			    		},
				    )
				];

				// hide delete button if no delete function added
			    if(widget.deleteItem != ItemView._defaultDeleteItem) {
			    	children.insert(0, const SizedBox(
					    	width: 10,
					    )
			    	);
			    	children.insert(0, FilledButton.tonal(
					  		style: ButtonStyle(
					  			backgroundColor: WidgetStateColor.resolveWith(buttonColors),
					  			iconColor: const WidgetStatePropertyAll(Colors.black),
					  			animationDuration: const Duration(milliseconds: 0),
					  		),
					    	onPressed: () {
					    		widget.deleteItem(widget.items.elementAt(index));
					    	},
					    	child: const Icon(Icons.delete, size: 20,),
					    )
			    	);
			    }

				return SizedBox(
					height: 50,
					child: Row(
					  children: children,
					),
				);
			},
			separatorBuilder: (BuildContext context, int index) => const Divider(),
		);
	}
}