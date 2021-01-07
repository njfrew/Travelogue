//
//  TripViewController.swift
//  Travelogue
//
//  Created by Noah Frew on 12/10/20.
//

import UIKit
import CoreData

class TripViewController: UIViewController {

    @IBOutlet weak var tripsTableView: UITableView!
    
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        title = "Trips"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            trips = try managedContext.fetch(fetchRequest)
            
            tripsTableView.reloadData()
        } catch {
            print("Could not fetch")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TravelogueEntriesViewController,
           let selectedRow = self.tripsTableView.indexPathForSelectedRow?.row else {
                return
            }
        
        destination.trip = trips[selectedRow]
    }

    func deleteTrip(at indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        
        guard let managedContext = trip.managedObjectContext else {
            return
        }
        
        let deleteOptionMenu = UIAlertController(title: nil, message: "Are you sure you want to delete the \(trip.title ?? "") trip?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            return
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            managedContext.delete(trip)
            
            do {
                try managedContext.save()
                
                self.trips.remove(at: indexPath.row)
                
                self.tripsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Could not delete")
                
                self.tripsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        deleteOptionMenu.addAction(cancelAction)
        deleteOptionMenu.addAction(deleteAction)

        self.present(deleteOptionMenu, animated: true)
    }
    
    
}

extension TripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = trips[indexPath.row]
        
        cell.textLabel?.text = trip.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTrip(at: indexPath)
        }
    }
}
