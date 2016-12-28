//
//  ValueFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData

public final class ValueFetchedResultsController<ItemType>: StaticFetchedResultsController {
	public var values: [ItemType] {
		get {
			return items.map { ($0 as! ValueWrapper<ItemType>).value }
		}
		set {
			items = newValue.map { ValueWrapper<ItemType>(value: $0) }
		}
	}

	public required init(values: Array<ItemType>, sectionTitle: String = "") {
		let objects = values.map { ValueWrapper<ItemType>(value: $0) }

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
