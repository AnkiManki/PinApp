//
//  ViewController.swift
//  PinApp
//
//  Created by Stefan Markovic on 9/29/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    //MARK: - Variables
    @IBOutlet weak var myTableView: UITableView!
    
    var restaurants: [RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController: UISearchController!
    var searchResults: [RestaurantMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        fetchData()
        
        searchController = UISearchController(searchResultsController: nil)
        myTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchBarAppearance()
        
        startAnimatingCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //stopAnimatingCells()
    }
    
    
    //MARK: - TableViews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]

        cell.configureCell(restaurant: restaurant)
        
        cell.thumbnailImageView.layer.cornerRadius = 12
        cell.thumbnailImageView.clipsToBounds = true
        cell.tintColor = #colorLiteral(red: 0.2006471157, green: 0.2145825028, blue: 0.2327077687, alpha: 1)
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none

        return cell
    }
    
    //MARK: - Share and Delete Swipe Actions
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.row)
        }
        myTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //MARK: Social sharing
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let defaultText = "Just checking in at  \(self.restaurants[indexPath.row].name!)"
            
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image!) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            
        }
        
        //MARK: Delete Button
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            let restaurantToDelete = self.fetchResultController.object(at: indexPath)
            context.delete(restaurantToDelete)
            appDelegate.saveContext()
        }
        shareAction.backgroundColor = #colorLiteral(red: 0.4479328394, green: 0.7674189806, blue: 0.7529405951, alpha: 1)
        deleteAction.backgroundColor = #colorLiteral(red: 0.8899894357, green: 0.449493885, blue: 0.2545161545, alpha: 1)
        
        return [deleteAction, shareAction]
    }
    
    //MARK: - Disable edit of cells when search is active
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView" {
            if let indexPath = myTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailVC
                destinationVC.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    //MARK: - Fetch data from core data
    func fetchData() {
        
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Called when we start processing content change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myTableView.beginUpdates()
    }
    
    //MARK: Whenever there is change in the data we call this method
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            if let newIndexPath = newIndexPath {
                myTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                myTableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            myTableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    //MARK: Finish updating the table
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myTableView.endUpdates()
    }
    
    //MARK: - Filter content
    func filterContent(searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    //MARK: - Update search results
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            myTableView.reloadData()
        }
    }
    
    //MARK: - Search bar UI
    func searchBarAppearance() {
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.3160597086, green: 0.3289884627, blue: 0.3499003947, alpha: 1)
    }

    func startAnimatingCells() {
        myTableView.reloadData()
        let cells = myTableView.visibleCells
        let tableHeight: CGFloat = myTableView.bounds.size.height
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
        }
        
        var delay = 0.2
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            
            print("Animating")
            delay += 0.1
        }
    }
    

    
    
    
}




















