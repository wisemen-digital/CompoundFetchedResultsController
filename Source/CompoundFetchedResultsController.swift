//
//  CompoundFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

@_exported import CoreData

public final class CompoundFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
	let controllers: [NSFetchedResultsController<NSFetchRequestResult>]
	var offsets: [NSObject: Int]

	public required init(controllers: [NSFetchedResultsController<NSFetchRequestResult>]) {
		self.controllers = controllers
		
		// ensure we have the items before we start calculating offsets
		for controller in controllers {
			try? controller.performFetch()
		}
		self.offsets = CompoundFetchedResultsController.calculateSectionOffsets(controllers: controllers)
		super.init()
		
		// listen to changes
		for controller in controllers {
			controller.delegate = self
		}
	}

	override convenience init() {
		self.init(controllers: [])
	}

	override convenience init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName name: String?) {
		fatalError("This method is not available")
	}

	static func calculateSectionOffsets(controllers: [NSFetchedResultsController<NSFetchRequestResult>]) -> [NSFetchedResultsController<NSFetchRequestResult>: Int] {
		var offset = 0
		var result = [NSObject: Int]()

		for controller in controllers {
			result[controller] = offset
			offset += controller.sections?.count ?? 0
		}

		return result as! [NSFetchedResultsController<NSFetchRequestResult>: Int]
	}
}

extension CompoundFetchedResultsController {
	public override func performFetch() throws {
		for controller in controllers {
			try controller.performFetch()
		}
	}

	public override var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
		return NSFetchRequest()
	}

	public override var managedObjectContext: NSManagedObjectContext {
		return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	}

	public override var sectionNameKeyPath: String? {
		return nil
	}

	public override var cacheName: String? {
		return nil
	}

	public override var fetchedObjects: [NSFetchRequestResult]? {
		return controllers.flatMap { $0.fetchedObjects }.flatMap { $0 }
	}

	public override func object(at indexPath: IndexPath) -> NSFetchRequestResult {
		for controller in controllers {
			if (indexPath.section - offsets[controller]!) < (controller.sections?.count ?? 0) {
				let path = IndexPath(item: indexPath.item, section: indexPath.section - offsets[controller]!)
				return controller.object(at: path)
			}
		}

		fatalError("Path \(indexPath) not found among sub-controllers")
	}

	public override func indexPath(forObject object: NSFetchRequestResult) -> IndexPath? {
		for controller in controllers {
			if let path = controller.indexPath(forObject: object) {
				return IndexPath(item: path.item, section: path.section + offsets[controller]!)
			}
		}

		return nil
	}

	public override func sectionIndexTitle(forSectionName sectionName: String) -> String? {
		for controller in controllers {
			if let title = controller.sectionIndexTitle(forSectionName: sectionName) {
				return title
			}
		}

		return nil
	}

	public override var sectionIndexTitles: [String] {
		return controllers.flatMap { $0.sectionIndexTitles }
	}

	public override var sections: [NSFetchedResultsSectionInfo]? {
		return controllers.flatMap { $0.sections }.flatMap { $0 }
	}

	public override func section(forSectionIndexTitle title: String, at sectionIndex: Int) -> Int {
		for controller in controllers {
			let section = controller.section(forSectionIndexTitle: title, at: sectionIndex - offsets[controller]!)
			if section != NSNotFound {
				return section
			}
		}

		return NSNotFound
	}
}
