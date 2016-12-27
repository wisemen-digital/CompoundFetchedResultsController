//
//  StartViewController.swift
//  Example
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016 dj. All rights reserved.
//

import CompoundFetchedResultsController
import CoreData
import MagicalRecord

class TableViewController: UITableViewController {
	var frc: NSFetchedResultsController<NSFetchRequestResult>!

	fileprivate var deletedSections = IndexSet()
	fileprivate var insertedSections = IndexSet()
	fileprivate var reloadedSections = IndexSet()
	fileprivate var deletedRows = [IndexPath]()
	fileprivate var insertedRows = [IndexPath]()
	fileprivate var reloadedRows = [IndexPath]()
	private var fetchedDataTimer: Timer?

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		fetchedDataTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
			MagicalRecord.save({ moc in
				var items = Item.mr_findAll(in: moc) as! [Item]

				// delete random # of items
				let delete = arc4random_uniform(UInt32(items.count))
				for _ in 0..<delete {
					let item = Int(arc4random_uniform(UInt32(items.count)))
					items[item].mr_deleteEntity(in: moc)
					items.remove(at: item)
				}

				// update random # of items
				let update = arc4random_uniform(UInt32(items.count))
				for _ in 0..<update {
					let item = Int(arc4random_uniform(UInt32(items.count)))
					items[item].name = UUID().uuidString
				}

				// create random new items
				let create = arc4random_uniform(10)
				for _ in 0..<create {
					let item = Item.mr_createEntity(in: moc)
					item?.name = UUID().uuidString
					item?.section = String(arc4random_uniform(3))
				}

				NSLog("Updated fetched items: \(delete) deletes, \(update) updates and \(create) creates")
			})
		}
		frc?.delegate = self
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		fetchedDataTimer?.invalidate()
		frc?.delegate = nil
	}
}

extension TableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return frc.sections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return frc.sections?[section].numberOfObjects ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let data = frc.object(at: indexPath)
		if let item = data as? ValueWrapper<String> {
			cell.textLabel?.text = item.value
			cell.detailTextLabel?.text = "Wrapped Value"
		} else if let item = data as? Item {
			cell.textLabel?.text = item.name
			cell.detailTextLabel?.text = "Fetched Value"
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return frc.sections?[section].name
	}
}

extension TableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			if !insertedSections.contains(newIndexPath!.section) && !reloadedSections.contains(newIndexPath!.section) {
				insertedRows.append(newIndexPath!)
			}
		case .delete:
			if !deletedSections.contains(indexPath!.section) && !reloadedSections.contains(indexPath!.section) {
				deletedRows.append(indexPath!)
			}
		case .update:
			reloadedRows.append(indexPath!)
		case .move:
			if !deletedSections.contains(indexPath!.section) && !reloadedSections.contains(indexPath!.section) {
				deletedRows.append(indexPath!)
			}
			if !insertedSections.contains(newIndexPath!.section) && !reloadedSections.contains(newIndexPath!.section) {
				insertedRows.append(newIndexPath!)
			}
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			insertedSections.insert(sectionIndex)
		case .delete:
			deletedSections.insert(sectionIndex)
		case .update:
			reloadedSections.insert(sectionIndex)
		default:
			break
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.deleteSections(deletedSections, with: .automatic)
		tableView.insertSections(insertedSections, with: .automatic)
		tableView.reloadSections(reloadedSections, with: .automatic)
		tableView.deleteRows(at: deletedRows, with: .automatic)
		tableView.insertRows(at: insertedRows, with: .automatic)
		tableView.reloadRows(at: reloadedRows, with: .automatic)
		tableView.endUpdates()

		deletedSections = IndexSet()
		insertedSections = IndexSet()
		reloadedSections = IndexSet()
		deletedRows = [IndexPath]()
		insertedRows = [IndexPath]()
		reloadedRows = [IndexPath]()
	}
}
