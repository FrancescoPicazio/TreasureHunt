//
//  File.swift
//  Treasure Hunter
//
//  Created by Francesco Picazio on 30/05/18.
//  Copyright © 2018 Francesco Picazio. All rights reserved.
//

import UIKit
import CoreLocation


class BeaconListController: UITableViewController {
    
    //gestore beacon
    static let shared = BeaconListController()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeaconManager.shared.beaconRegions.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "row")
        
        BeaconManager.shared.selectedBeacon = BeaconManager.shared.beaconRegions[indexPath.item]
        
        performSegue(withIdentifier: "goToBC", sender: nil)
        
    }

    @IBAction func newBeacon(_ sender: Any) {
        BeaconManager.shared.selectedBeacon = CLBeaconRegion(proximityUUID: UUID(uuidString:"00000000-0000-0000-0000-000000000000")!, identifier: "Identifier")
        performSegue(withIdentifier: "goToBC", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "row")
        
        let beacon: CLBeaconRegion = BeaconManager.shared.beaconRegions[indexPath.item]
        
        cell?.textLabel?.text = beacon.identifier
        
        cell?.detailTextLabel?.text = "\(String(describing: beacon.proximityUUID)) M:\(beacon.major ?? 0) m:\(beacon.minor ?? 0)"
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            BeaconManager.shared.beaconRegions.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
