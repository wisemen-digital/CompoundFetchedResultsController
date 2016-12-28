//
//  ValueWrapper.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData

extension NSObject: NSFetchRequestResult {
}

public final class ValueWrapper<ValueType: Any>: NSObject {
	public let value: ValueType

	init(value: ValueType) {
		self.value = value
	}
}
