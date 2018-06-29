//
//  BeaconManager.swift
//  Treasure Hunter
//
//  Created by Francesco Picazio on 30/05/18.
//  Copyright © 2018 Francesco Picazio. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager {
    
    static let shared = BeaconManager()
    
    // salvataggio in locale
    let defaultUser = UserDefaults.standard
    
    // Beacon selezionato per la caccia
    var selectedBeacon : CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString:"4f902a96-5014-414b-911d-8b7a285593ad")!, major: 10, identifier: "Event")
    
    
    //Lista di beacon
    var beaconRegions : [CLBeaconRegion] = []
    
    
    func saveBeacon () {
       
        for (index,beacon) in beaconRegions.enumerated() {
            defaultUser.setValue(beacon.identifier , forKey: "ID\(index)")
            defaultUser.setValue(beacon.proximityUUID.uuidString, forKey: "UUID\(index)")
            defaultUser.setValue(beacon.minor?.doubleValue, forKey: "Minor\(index)")
            defaultUser.setValue(beacon.major?.doubleValue, forKey: "Major\(index)")
        }
        
    
    }
    
    func loadBeacon() {
        //Primo avvio
        var index = 0
        if !self.defaultUser.bool(forKey: "firstStart") {
           self.defaultUser.set(true, forKey: "firstStart")
          
            let firstLoad = [
                CLBeaconRegion(proximityUUID: UUID(uuidString:"4f902a96-5014-414b-911d-8b7a285593ad")!, major: 10, identifier: "Event"),
                CLBeaconRegion(proximityUUID: UUID(uuidString:"4f902a96-5014-414b-911d-8b7a285593ad")!, major: 10, identifier: "Event"),
                CLBeaconRegion(proximityUUID: UUID(uuidString:"4f902a96-5014-414b-911d-8b7a285593ad")!, major: 10, identifier: "Event"),
                CLBeaconRegion(proximityUUID: UUID(uuidString:"4f902a96-5014-414b-911d-8b7a285593ad")!, major: 10, identifier: "Event")]
            
            beaconRegions = firstLoad
            return
        }
    
        if defaultUser.string(forKey: "ID0") == nil {
            return
        }
     
        
        repeat {
            let identifier = defaultUser.string(forKey: "ID\(index)")
            let uuid = defaultUser.string(forKey: "UUID\(index)")
            let minor = defaultUser.double(forKey: "Minor\(index)")
            let major = defaultUser.double(forKey: "Major\(index)")
            
            
            let beacon = CLBeaconRegion(proximityUUID: UUID(uuidString: uuid!)!, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: identifier!)
            
            beaconRegions.append(beacon)
            
            defaultUser.removeObject(forKey: "ID\(index)")
            defaultUser.removeObject(forKey: "UUID\(index)")
            defaultUser.removeObject(forKey: "Minor\(index)")
            defaultUser.removeObject(forKey: "Major\(index)")
            
            index += 1
            
        } while defaultUser.string(forKey: "ID\(index)") != nil
    }
}
