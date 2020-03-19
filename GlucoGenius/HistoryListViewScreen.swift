//
//  HistoryListViewScreen.swift
//  GlucoGenius
//
//  Created by i mark on 16/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

protocol HistoryListViewScreenProtocol {
    func deleteBtnAction(_ indexPath:IndexPath)
}

class HistoryListViewScreen: UIView,UICollectionViewDelegate,UICollectionViewDataSource, HistoryListViewCellProtocol{
    
    //MARK:- Outlets & Propeties
    
    var result = [String]()
    var dates = [String]()
    var medicine = [String]()
    var diet = [String]()
    var time = [String]()
    var record_id = [String]()
    var delete  = [String]()
    var delegate:HistoryListViewScreenProtocol?
    let coreDataObj = CoreData()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headingViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lblDiet: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    
    //MARK:- View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headingViewWidthConst.constant = self.frame.size.width / 5
        collectionView.delegate = self
        collectionView.dataSource  = self
        
        lblDate.text = datesText
        lblTime.text = timeText
        lblResult.text = resultText
        lblDiet.text = dietText
        lblDelete.text = deleteText
        
        setDataToshow()
        collectionViewSetup()
        collectionView.register(UINib(nibName: "HistoryListViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func setDataToshow(){
        result = resultDictToShow.map{
            String($0)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        dateFormatter.dateFormat = "dd/M"
        
        dates = dateDictToShow.map{dateFormatter.string(from: $0 as Date)}
        
        medicine = medicineDictToShow
        time = timeDictToShow
        diet = dietDictToShow
        record_id = recordDictToShow
    }
    
    //MARK:- UserDefined Methods
    
    func collectionViewSetup(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
    }
    
    //MARK:- Collection view delegates
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HistoryListViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HistoryListViewCollectionViewCell
        cell.delegate = self
        
        cell.cellLblResult.font = UIFont(name: "Gotham Medium", size: 14.0)
        
        cell.cellLblDelete.font = UIFont.fontAwesome(ofSize: 20)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.trashO)
        cell.cellLblDelete.text = likeBtnTitle
        
        if medicine[indexPath.row] == "false"{
            cell.cellImgViewMedi.image = UIImage(named: "NoMedicine")
        }
        else{
            cell.cellImgViewMedi.image = UIImage(named: "yesMedicine")
        }
        
        if diet[indexPath.row] == "0"{
            cell.cellImgViewDiet.image = UIImage(named: "morningfastionicon")
        }
        else{
            cell.cellImgViewDiet.image = UIImage(named: "2hoursFoodIcon")
        }
        cell.cellLblDate.text = String(dates[indexPath.row])
        cell.cellLblTime.text = time[indexPath.row]
        
        cell.cellLblResult.text = String(format: "%.1f",Double(result[indexPath.row])!)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.frame.size.width / 5 , height: self.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return record_id.count
    }
    
    func deleteButtonCellTapped(_ cell:HistoryListViewCollectionViewCell){
        
        let refreshAlert = UIAlertController(title: alertText, message: measurementRecord_alert_deleteRecord, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: okText, style: .default, handler: { (action: UIAlertAction!) in
            
            let indexPath = self.collectionView?.indexPath(for: cell)
            
            let appDel  = UIApplication.shared.delegate as! AppDelegate
            let context = appDel.managedObjectContext
            
            let record_id = self.record_id[(indexPath?.row)!]
            
            let fetchPredicate = NSPredicate(format: "record_id == %@", record_id)
            
            let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecord")
            fetchUsers.predicate                = fetchPredicate
            fetchUsers.returnsObjectsAsFaults   = false
            
            do {
                let fetchedUsers = try context.fetch(fetchUsers)
                
                for fetchedUser in fetchedUsers {
                    
                    context.delete(fetchedUser as! NSManagedObject)
                    do{
                        try context.save()
                        self.record_id.remove(at: (indexPath?.row)!)
                        
                        dateDictToShow.remove(at: (indexPath?.row)!)
                        resultDictToShow.remove(at: (indexPath?.row)!)
                        dietDictToShow.remove(at: (indexPath?.row)!)
                        recordDictToShow.remove(at: (indexPath?.row)!)
                        timeDictToShow.remove(at: (indexPath?.row)!)
                        allRecordDict.remove(at: (indexPath?.row)!)
                        medicineDictToShow.remove(at: (indexPath?.row)!)
                        self.collectionView.reloadData()
                        
                    } catch let error as NSError {
                        // failure
                        print(error)
                    }
                }
            }catch {}
        }))
        
        refreshAlert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
    }
    
}
