//
//  FlatCompoundFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 24/07/2020.
//

import CoreData

extension Array {
    func scan<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> T) -> [T] {
		self.reduce(into: [initialResult]) { result, item in
			let lastElement = result.last ?? initialResult
			result.append(nextPartialResult(lastElement, item))
		}
    }
}

public final class FlatCompoundFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
	struct ControllerInfo {
		let range: Range<Int>
		let offsets: [Int]
	}

	final class SectionInfoWrapper: NSFetchedResultsSectionInfo {
		let name: String
		let indexTitle: String?
		let numberOfObjects: Int
		let objects: [Any]?

		init(section: NSFetchedResultsSectionInfo?, items: [Any]?) {
			name = section?.name ?? ""
			indexTitle = section?.indexTitle
			numberOfObjects = items?.count ?? 0
			objects = items
		}
	}

	let controllers: [NSFetchedResultsController<NSFetchRequestResult>]
	var controllersInfo: [ControllerInfo]

	public required init(controllers: [NSFetchedResultsController<NSFetchRequestResult>]) {
		self.controllers = controllers

		// ensure we have the items before we start calculating offsets
		for controller in controllers {
			try? controller.performFetch()
		}
		self.controllersInfo = FlatCompoundFetchedResultsController.calculateSectionOffsets(controllers: controllers)
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

	static func calculateSectionOffsets(controllers: [NSFetchedResultsController<NSFetchRequestResult>]) -> [ControllerInfo] {
		var offset = 0
		var result = [ControllerInfo]()

		for controller in controllers {
			let offsets = (controller.sections ?? []).map(\.numberOfObjects).scan(offset, +)
			let last = (offsets.last ?? offset)

			result.append(ControllerInfo(range: offset..<last, offsets: offsets.dropLast()))
			offset = last
		}

		return result
	}
}

extension FlatCompoundFetchedResultsController {
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
		return controllers.compactMap { $0.fetchedObjects }.flatMap { $0 }
	}

	public override func object(at indexPath: IndexPath) -> NSFetchRequestResult {
		guard indexPath.section == 0 else { fatalError("Section must be 0") }

		for (controller, info) in zip(controllers, controllersInfo) where info.range.contains(indexPath.item) {
			let section = info.offsets.lastIndex { $0 <= indexPath.item } ?? 0
			let path = IndexPath(item: indexPath.item - info.offsets[section], section: section)
			return controller.object(at: path)
		}

		fatalError("Path \(indexPath) not found among sub-controllers")
	}

	public override func indexPath(forObject object: NSFetchRequestResult) -> IndexPath? {
		for (controller, info) in zip(controllers, controllersInfo) {
			if let path = controller.indexPath(forObject: object) {
				return IndexPath(item: path.item + info.offsets[path.section], section: 0)
			}
		}

		return nil
	}

	public override func sectionIndexTitle(forSectionName sectionName: String) -> String? {
		return controllers.first?.sectionIndexTitle(forSectionName: sectionName)
	}

	public override var sectionIndexTitles: [String] {
		return [controllers.first?.sectionIndexTitles.first ?? ""]
	}

	public override var sections: [NSFetchedResultsSectionInfo]? {
		return [SectionInfoWrapper(section: controllers.first?.sections?.first, items: fetchedObjects)]
	}

	public override func section(forSectionIndexTitle title: String, at sectionIndex: Int) -> Int {
		return 0
	}
}

