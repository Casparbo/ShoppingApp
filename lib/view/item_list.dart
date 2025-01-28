import 'package:flutter/material.dart';
import 'package:shopping_app/model/item.dart';

class ItemList extends StatelessWidget {
	final List<Item> items;
	final Color themeColor;

	const ItemList({
		super.key, 
		required this.items,
		required this.themeColor
	});

	Color buttonColors(Set<WidgetState> states) {
		const Set<WidgetState> interactiveStates = <WidgetState>{
			WidgetState.pressed,
			WidgetState.hovered,
			WidgetState.focused,
		};
		if (states.any(interactiveStates.contains)) {
			return Colors.red;
		}
		return themeColor;
	}
	

	@override
	Widget build(BuildContext context) {
		return ListView.separated(
			padding: const EdgeInsets.all(12),
			itemCount: items.length,
			itemBuilder: (BuildContext context, int index) {
				return SizedBox(
					height: 50,
					child: Row(
					  children: [
					  	FilledButton.tonal(
					  		style: ButtonStyle(
					  			foregroundColor: WidgetStatePropertyAll(Colors.black),
					  			backgroundColor: WidgetStateColor.resolveWith(buttonColors),
					  		),
					    	onPressed: () {},
					    	child: const Icon(Icons.delete, size: 20,),
					    ),
					    Expanded(
					    	child: Center(
						    	child: Text(
							    	items.elementAt(index).name,
							    	style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
							    ),
						    ),
					    ),
					    Checkbox(
					    	fillColor: WidgetStateColor.resolveWith(buttonColors),
					    	value: items.elementAt(index).stocked,
					    	onChanged: (bool? value) {},
					    )
					  ],
					),
				);
			},
			separatorBuilder: (BuildContext context, int index) => const Divider(),
		);
	}
}