//
//  ItemTableViewController.swift
//  Mercado
//
//  Created by Aleksei Neronov on 23.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class ItemTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    struct Storyboard {
        static let CellID = "Search cell"
        static let SegueItemDetails = "Segue Item Details"
    }

    var searchText:String? {
        didSet {
            // Delete all records in entity 'Search' CoreData
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Search")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    context.delete(managedObjectData)
                }
            } catch {
                print(error)
            }
            updateUI()
        }
    }

    var controller: NSFetchedResultsController<Search>!

    override func viewDidLoad() {
        super.viewDidLoad()
        getLastSearch()
        updateUI()
    }

    // MARK: Update UI elements
    
    private func updateUI() {
        if let query = searchText, !query.isEmpty {
            REST.loadList(for: query) {
                self.attemptFetch()
                self.tableView.setContentOffset(CGPoint(x:0, y:-(self.navigationController?.navigationBar.frame.size.height)! * 1.4), animated: false)
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureCell(cell:SearchTableCell, indexPath:IndexPath) {
        // update cell
        let item = controller.object(at: indexPath)
        
        Alamofire.request(item.thumb!).responseImage { response in
            if let image = response.result.value {
                cell.configureCell(image: image)
                item.thumbImg = image
            }
        }
        
        cell.configureCell(item: item)
    }
    
    // MARK: CoreData fetching
    
    private func attemptFetch() {
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest.sortDescriptors = []
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

    private func getLastSearch() {
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest.sortDescriptors = []
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
            return sectionInfo.numberOfObjects
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

    // MARK: TextFieldDelegates
    
    @IBAction func refresh(_ sender: UITextField) {
        updateUI()
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            searchText = text
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
