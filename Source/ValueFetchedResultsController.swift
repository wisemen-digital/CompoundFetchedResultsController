//
//  ValueFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData

public final class ValueFetchedResultsController<ItemType>: StaticFetchedResultsController {
	public required init(values: Array<ItemType>, sectionTitle: String = "") {
		let objects = values.map { (v: ItemType) -> ValueWrapper<ItemType> in
			return ValueWrapper<ItemType>(value: v)
		}

		super.init(items: objects, sectionTitle: sectionTitle)
	}

	public func object(at indexPath: IndexPath) -> ItemType {
		let item: NSFetchRequestResult = object(at: indexPath)

		if let item = item as? ValueWrapper<ItemType> {
			return item.value
		} else {
			fatalError("Unexpected object found at path \(indexPath): item")
		}
	}
}
