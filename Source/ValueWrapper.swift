//
//  ValueWrapper.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

public class AnyValueWrapper: NSObject, NSFetchRequestResult {
	fileprivate let data: Any

	init(value: Any) {
		data = value
	}
}

public final class ValueWrapper<T>: AnyValueWrapper {
	public var value: T {
		return data as! T
	}
}
