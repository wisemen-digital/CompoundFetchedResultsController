//
//  FlatCompoundFetchedResultsController+NSFetchedResultsController.swift
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 24/07/2020.
//

import CoreData
import UIKit

extension FlatCompoundFetchedResultsController: NSFetchedResultsControllerDelegate {
	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate?.controllerWillChangeContent?(self)
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		guard let section = sections?.first else { return }
		delegate?.controller?(self, didChange: section, atSectionIndex: 0, for: .update)
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		guard let section = sections?.first else { return }
		delegate?.controller?(self, didChange: section, atSectionIndex: 0, for: .update)
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		controllersInfo = FlatCompoundFetchedResultsController.calculateSectionOffsets(controllers: controllers)
		delegate?.controllerDidChangeContent?(self)
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return delegate?.controller?(self, sectionIndexTitleForSectionName: sectionName)
	}
}
