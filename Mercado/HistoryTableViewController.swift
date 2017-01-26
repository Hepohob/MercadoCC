//
//  HistoryTableViewController.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    private struct Storyboard {
        static let CellID = "History cell"
        static let SegueItemDetails = "Segue Item Details from History"
    }

    private var controller: NSFetchedResultsController<Product>!
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
    
        case.insert:
            if let indexPath = newIndexPath {
                var indxPath = indexPath
                indxPath.row = 0
                tableView.insertRows(at: [indxPath], with: .fade)
                attemptFetch()
                tableUpdate()

            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? SearchTableCell {
                    configureCell(cell: cell, indexPath: indexPath)
                    attemptFetch()
                    tableUpdate()

                }
            }
            break

        default: break
        }
    }
    
    //MARK: APP Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableUpdate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attemptFetch()
    }

    private func configureCell(cell:SearchTableCell, indexPath:IndexPath) {
        // update cell
        let product = controller.object(at: indexPath)
        cell.configureCell(product: product)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller?.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller?.sections {
            let sectionInfo = sections[section]
            var result = sectionInfo.numberOfObjects
            if isShowFive && result > 5 {
                result = 5
            }
            return result
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellID, for: indexPath) as! SearchTableCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    var isShowFive = true
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        if !isShowFive {
            self.navigationItem.title = "Last 5 items"
            isShowFive = true
        } else {
            self.navigationItem.title = "All items"
            isShowFive = false
        }
        attemptFetch()
        tableUpdate()
    }
    
    private func tableUpdate() {
        self.tableView.setContentOffset(CGPoint(x:0, y:-(self.navigationController?.navigationBar.frame.size.height)! * 1.4), animated: false)
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.bottom)
    }

    // MARK: CoreData working
    
    private func attemptFetch() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }
    }

    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let product = objs[indexPath.row]
            performSegue(withIdentifier: Storyboard.SegueItemDetails, sender: product)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.SegueItemDetails {
            if let destination = segue.destination as? DetailViewController {
                if let product = sender as? Product {
                    destination.product = product
                }
            }
        }
        
    }

}
