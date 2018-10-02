//
//  ValueFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData

/// Fake FRC for value types (such as structs)
public final class ValueFetchedResultsController<ItemType>: StaticFetchedResultsController<AnyValueWrapper> {
	public var values: [ItemType] {
		get {
			return items.compactMap { ($0 as? ValueWrapper<ItemType>)?.value }
		}
		set {
			items = newValue.map { ValueWrapper<ItemType>(value: $0) }
		}
	}

	public required init(values: [ItemType], sectionTitle: String = "") {
		let objects = values.map { ValueWrapper<ItemType>(value: $0) }
		super.init(items: objects, sectionTitle: sectionTitle)
	}

	public func object(at indexPath: IndexPath) -> ItemType {
		guard let wrapper = super.object(at: indexPath) as? ValueWrapper<ItemType> else {
			fatalError("Expected \(ValueWrapper<ItemType>.self), got something else!")
		}
		return wrapper.value
	}
}
