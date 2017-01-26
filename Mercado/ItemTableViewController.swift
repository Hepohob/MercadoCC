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

class ItemTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    private struct Storyboard {
        static let CellID = "Search cell"
        static let SegueItemDetails = "Segue Item Details"
    }

    var searchText:String? {
        didSet {
            clearSearchEntity()
            loadRESTData()
        }
    }

    private var controller: NSFetchedResultsController<Search>!

    override func viewDidLoad() {
        super.viewDidLoad()
        getLastSearch()
        attemptFetch()
    }

    // MARK: Update UI elements
    
    private func loadRESTData() {
        if let query = searchText, !query.isEmpty {
            REST.loadList(for: query) {
                self.attemptFetch()
                self.tableView.setContentOffset(CGPoint(x:0, y:-(self.navigationController?.navigationBar.frame.size.height)! * 1.4), animated: false)
                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.bottom)
            }
        }
    }
    
    private func configureCell(cell:SearchTableCell, indexPath:IndexPath) {
        // update cell
        let item = controller.object(at: indexPath)
        if let thumbString = item.thumb,
            thumbString.characters.count > 5,
            let url = NSURL(string: thumbString),
            UIApplication.shared.canOpenURL(url as URL) {
            Alamofire.request(thumbString).responseImage { response in
                if let image = response.result.value {
                    cell.configureCell(image: image)
                    item.thumbImg = image
                }
            }
        } else {
            // no image
            cell.configureCell(image: UIImage(named: "imagePick")!)
            item.thumbImg = UIImage(named: "imagePick")
        }
        
        cell.configureCell(item: item)
    }
    
    // MARK: CoreData working
    
    private func clearSearchEntity() {
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
    }
    
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
        let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
        do {
            if let reqs = try context.fetch(fetchRequest) as [Request]?, reqs.count > 0 {
                searchBar?.text = reqs.last?.string
            }
        } catch {
            // handle error
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

    // MARK: SearchBar delegates
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet {
            searchBar.delegate = self
            searchBar.text = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            searchText = text
            let req = Request(context: context)
            req.string = text
            ad.saveContext()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: Storyboard.SegueItemDetails, sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.SegueItemDetails {
            if let destination = segue.destination as? DetailViewController {
                if let item = sender as? Search {
                    
                    destination.titleItem = item.title
                    destination.number = item.id
                    destination.price = "Price: \(item.price) \(item.currency ?? "")"
                    if let img = item.thumbImg as? UIImage {
                        destination.thumb = img
                    }

                    destination.productId = item.id
                    destination.titleText = searchBar.text
                }
            }
        }
        
    }

}
