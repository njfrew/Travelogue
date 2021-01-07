//
//  TravelogueEntriesViewController.swift
//  Travelogue
//
//  Created by Noah Frew on 12/10/20.
//

import UIKit
import CoreData

class TravelogueEntriesViewController: UIViewController {


    @IBOutlet weak var travelogueEntriesTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        travelogueEntriesTableView.delegate = self
        travelogueEntriesTableView.dataSource = self
        
        title = "\(trip?.title ?? "") Travelogue Entries"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.travelogueEntriesTableView.reloadData()
    }
    
    @IBAction func addTravelogueEntry(_ sender: Any) {
        performSegue(withIdentifier: "showTravelogueEntry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleTravelogueEntryViewController else { return }
        
        destination.trip = trip
        
        if let indexPath = travelogueEntriesTableView.indexPathForSelectedRow,
              let travelogueEntries = trip?.travelogueEntries {
            let travelogueEntry = travelogueEntries[indexPath.row]
            destination.existingTravelogueEntry = travelogueEntry
        }
    }
    
    func deleteTravelogueEntry(at indexPath: IndexPath) {
        guard let travelogueEntry = trip?.travelogueEntries?[indexPath.row],
              let managedContext = trip?.managedObjectContext else {
            return
        }
        
        managedContext.delete(travelogueEntry)
        
        do {
            try managedContext.save()
            
            travelogueEntriesTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Delete failed")
            
            travelogueEntriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension TravelogueEntriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trip?.travelogueEntries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = travelogueEntriesTableView.dequeueReusableCell(withIdentifier: "travelogueEntryCell", for: indexPath)
        if let travelogueEntry = trip?.travelogueEntries?[indexPath.row] {
            cell.textLabel?.text = travelogueEntry.title
            if let modificationDate = travelogueEntry.date {
                cell.detailTextLabel?.text = "Modified: \(dateFormatter.string(from: modificationDate))"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTravelogueEntry(at: indexPath)
        }
    }
}

extension TravelogueEntriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTravelogueEntry", sender: self)
    }
}
