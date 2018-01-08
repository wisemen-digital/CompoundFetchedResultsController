//
//  StaticFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData

public class StaticFetchedResultsController<ResultType: FetchRequestResult>: NSFetchedResultsController<FetchRequestResult> {
	public var items: [ResultType] {
		didSet {
			delegate?.controllerWillChangeContent?(self)

			let info = StaticSectionInfo(name: sectionTitle, objects: items)
			delegate?.controller?(self, didChange: info, atSectionIndex: 0, for: .update)

			delegate?.controllerDidChangeContent?(self)
		}
	}
	let sectionTitle: String

	public init(items: [ResultType], sectionTitle: String? = nil) {
		self.items = items
		self.sectionTitle = sectionTitle ?? ""
		super.init()
	}

	override convenience init() {
		self.init(items: [])
	}

	override convenience init(fetchRequest: NSFetchRequest<FetchRequestResult>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName name: String?) {
		fatalError("This method is not available")
	}

	// MARK: - NSFetchedResultsController overrides

	public override func performFetch() throws {
	}

	public override var fetchRequest: NSFetchRequest<FetchRequestResult> {
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

	public override var fetchedObjects: [FetchRequestResult]? {
		return items
	}

	public override func object(at indexPath: IndexPath) -> FetchRequestResult {
		return items[indexPath.item]
	}

	public func object(at indexPath: IndexPath) -> ResultType {
		return items[indexPath.item]
	}

	public override func indexPath(forObject object: FetchRequestResult) -> IndexPath? {
		guard let item = items.index(where: { $0.hash == object.hash }) else { return nil }
		return IndexPath(item: item, section: 0)
	}

	public override func sectionIndexTitle(forSectionName sectionName: String) -> String? {
		return nil
	}

	public override var sectionIndexTitles: [String] {
		return [""]
	}

	public override var sections: [NSFetchedResultsSectionInfo]? {
		return [StaticSectionInfo(name: sectionTitle, objects: items)]
	}

	public override func section(forSectionIndexTitle title: String, at sectionIndex: Int) -> Int {
		return NSNotFound
	}
}
