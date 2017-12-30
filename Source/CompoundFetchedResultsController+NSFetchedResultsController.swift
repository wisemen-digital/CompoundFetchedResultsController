//
//  CompoundFetchedResultsController+NSFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

extension CompoundFetchedResultsController: NSFetchedResultsControllerDelegate {
	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<FetchRequestResult>) {
		delegate?.controllerWillChangeContent?(self)
	}

	public func controller(_ controller: NSFetchedResultsController<FetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		delegate?.controller?(self, didChange: sectionInfo, atSectionIndex: sectionIndex + offsets[controller]!, for: type)
	}

	public func controller(_ controller: NSFetchedResultsController<FetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		var old = indexPath
		if let indexPath = indexPath {
			old = IndexPath(item: indexPath.item, section: indexPath.section + offsets[controller]!)
		}

		var new = newIndexPath
		if let newIndexPath = newIndexPath {
			new = IndexPath(item: newIndexPath.item, section: newIndexPath.section + offsets[controller]!)
		}

		delegate?.controller?(self, didChange: anObject, at: old, for: type, newIndexPath: new)
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<FetchRequestResult>) {
		offsets = CompoundFetchedResultsController.calculateSectionOffsets(controllers: controllers)
		delegate?.controllerDidChangeContent?(self)
	}

	public func controller(_ controller: NSFetchedResultsController<FetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return delegate?.controller?(self, sectionIndexTitleForSectionName: sectionName)
	}
}
