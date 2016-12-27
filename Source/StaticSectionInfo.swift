//
//  StaticSectionInfo.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData

final class StaticSectionInfo: NSObject, NSFetchedResultsSectionInfo {
	let name: String
	let objects: [Any]?

	init(name: String, objects: [Any]) {
		self.name = name
		self.objects = objects
	}

	var numberOfObjects: Int {
		return objects!.count
	}

	var indexTitle: String? {
		return nil
	}
}
