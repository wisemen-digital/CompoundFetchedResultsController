//
//  StartViewController.swift
//  Example
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016 dj. All rights reserved.
//

import CompoundFetchedResultsController
import MagicalRecord

class StartViewController: UITableViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let vc = segue.destination as? TableViewController,
			let path = sender as? IndexPath else { return }

		// first section is plain frc
		if (path.section == 0) {
			if path.item == 0 {
				vc.frc = itemsFRC
			} else {
				vc.frc = limitedItemsFRC
				try? vc.frc.performFetch()
			}
		} else {
			var controllers: [Any] = []

			// create sub frc
			if path.item == 1 || path.item == 3 {
				controllers += [ValueFetchedResultsController<String>(values: ["abc", "def", "ghi", "jkl"], sectionTitle: "prepend")]
			}
			if path.section == 1 || path.section == 2 {
				controllers += [itemsFRC]
			}
			if path.item == 2 || path.item == 3 {
				controllers += [ValueFetchedResultsController<String>(values: ["mno", "pqr", "stu", "vwx"], sectionTitle: "append")]
			}

			// create wrapper frc
			if path.section == 1 {
				vc.frc = FlatCompoundFetchedResultsController(controllers: controllers.compactMap { $0 as? NSFetchedResultsController<NSFetchRequestResult>})
			} else {
				vc.frc = CompoundFetchedResultsController(controllers: controllers.compactMap { $0 as? NSFetchedResultsController<NSFetchRequestResult>})
			}
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "next", sender: indexPath)
	}

	private var itemsFRC: NSFetchedResultsController<NSFetchRequestResult> {
		let moc = NSManagedObjectContext.mr_default()

		return Item.mr_fetchAllGrouped(by: #keyPath(Item.section),
		                               with: nil,
		                               sortedBy: "\(#keyPath(Item.section)),\(#keyPath(Item.name))",
		                               ascending: true,
		                               in: moc)
	}

	private var limitedItemsFRC: LimitedFetchedResultsController<NSFetchRequestResult> {
		let moc = NSManagedObjectContext.mr_default()
		let request = Item.mr_requestAllSorted(by: "\(#keyPath(Item.section)),\(#keyPath(Item.name))", ascending: true)
		request.fetchLimit = 3

		return LimitedFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: #keyPath(Item.section), cacheName: nil)
	}
}
