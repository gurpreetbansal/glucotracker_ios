//
//  BluetoothDevicesVC.swift
//  GlucoGenius
//
//  Created by i mark on 20/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import CoreBluetooth
import UIKit

class BluetoothDevicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate
{
    //MARK:- Outlets & Properties
    
    var centralManager: CBCentralManager?
    var peripherals: Array<CBPeripheral> = Array<CBPeripheral>()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialise CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = btDevicesVC_title
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(BluetoothDevicesVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- CoreBluetooth methods
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        if (central.state == .poweredOn){//CBCentralManagerState.poweredOn
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else{
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        let peripheralName = peripheral.name
        //peripheral.identifier
        if peripheralName != nil && !peripherals.contains(peripheral){
            peripherals.append(peripheral)
        }
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager!.stopScan()
        Utility.showAlert(successtext, message: btDevicesVC_alert_deviceConnected, viewController: self)
    }
    
    // MARK: - UITableView methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
      //  let currentSize = cell.textLabel?.font.pointSize
        
//        if (UIScreen.main.bounds.height > 736){
//            cell.textLabel?.font = cell.textLabel?.font.withSize(currentSize!+8)
//        }
//        else{
//            cell.textLabel?.font = cell.textLabel?.font.withSize(currentSize!)
//        }
        
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let periToConnect = peripherals[indexPath.row]
        centralManager!.connect(periToConnect, options: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return btDevicesVC_headerText
    }
}
