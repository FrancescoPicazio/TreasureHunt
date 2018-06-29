//
//  BeaconController.swift
//  Treasure Hunter
//
//  Created by Francesco Picazio on 30/05/18.
//  Copyright © 2018 Francesco Picazio. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class BeaconController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate {
    
    var locationManager: CLLocationManager!
    var bluetoothManager:CBCentralManager!
    
    var beaconRegionEvent = CLBeaconRegion(proximityUUID: UUID(uuidString:"4f902a96-5014-414b-911d-8b7a285593ad")!, major: 10, identifier: "Event")
    
    @IBOutlet weak var beaconImage: UIImageView!
    
    @IBOutlet weak var beaconFeadback: UIImageView!
    
    @IBAction func backButton(_ sender: Any) {
        locationManager.stopMonitoring(for: beaconRegionEvent)
        locationManager.stopRangingBeacons(in: beaconRegionEvent)
//        locationManager.stopMonitoring(for: beaconRegionEvent)
        debugPrint("Stop monitoring")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconFeadback.alpha = 0.6
        beaconFeadback.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        self.beaconImage.image = #imageLiteral(resourceName: "Not found")
        bluetoothManager = CBCentralManager()
        bluetoothManager.delegate = self
  
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("start...")
                    startScanning()
                    
                }
            }
        }
    }
    
    
    func startScanning() {
        locationManager.startMonitoring(for: beaconRegionEvent)
        locationManager.startRangingBeacons(in: beaconRegionEvent)
        if bluetoothManager.state == .poweredOff {
            debugPrint("bluetooth is off")
            
            let alert = UIAlertController(title: "Bluetooth is off", message: "Go in setting and switch it ON", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: "app-settings:root=General&path=Bluetooth") else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
            alert.addAction(settingsAction)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            
            switch distance {
            case .unknown:
                print("Too Far")
                self.beaconFeadback.backgroundColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
                self.beaconImage.image = #imageLiteral(resourceName: "Sea")
            case .far:
                print("Far")
                self.beaconFeadback.backgroundColor = UIColor(red:0.54, green:0.86, blue:0.82, alpha:1.0)
                self.beaconImage.image = #imageLiteral(resourceName: "Water")
            case .near:
                print("Near")
                self.beaconFeadback.backgroundColor = UIColor(red:0.98, green:0.57, blue:0.08, alpha:1.0)
                self.beaconImage.image = #imageLiteral(resourceName: "Fire")
            case .immediate:
                print("Immediate")
                self.beaconFeadback.backgroundColor = UIColor(red:0.79, green:0.00, blue:0.09, alpha:1.0)
                self.beaconImage.image = #imageLiteral(resourceName: "Blaze")
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
}
