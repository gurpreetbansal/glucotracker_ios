//
//  HistoryVC.swift
//  GlucoGenius
//
//  Created by i mark on 08/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//
//date = "2016-10-10 08:05:27 +0000";

import UIKit
import MessageUI
import CoreData
import Foundation

var dateDictToShow = [Date]()
var resultDictToShow = [Double]()
var dietDictToShow = [String]()
var medicineDictToShow = [String]()
var recordDictToShow = [String]()
var timeDictToShow = [String]()
var allRecordDict = [NSMutableDictionary]()
var timePeriodSelected = Int()

class HistoryVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,HistoryListViewScreenProtocol,MFMailComposeViewControllerDelegate {
    
    //MARK:- Outlets & Properties
    
    var coreDataObj:CoreData = CoreData()
    var glucose_mmol_L = [Double]()
    var glucose_mg_dL = [Double]()
    var hb_g_L = [Double]()
    var hb_g_dL = [Double]()
    
    var pulse = [Double]()
    var bloodFlow = [Double]()
    var oxSat = [Double]()
    var date = [Date]()
    var medicine = [String]()
    var diet = [String]()
    var time = [String]()
    var record_id = [String]()
    var delete  = [String]()
    var selectPeriodDates = [Date]()
    var resultSelected = "glucose"
    
    var pickerViewEndDatesArray = [Date]()
    var pickerViewStartDatesArray = [Date]()
    
    var periodStartDate = Date()
    var periodEndDate = Date()
    var listView:HistoryListViewScreen = HistoryListViewScreen()
    var chartView:HistoryChartViewScreen = HistoryChartViewScreen()
    var ChoosetimePeriod = 0
    
    var glucoseUnitChoosed = UserDefaults.standard.string(forKey: "hm_gluc_unit")!
    var hbUnitChoosed = UserDefaults.standard.string(forKey: "hm_hb_unit")!
    var daySelectedDate = Date()
    var monthSelectedDate = Date()
    var uniqueDatesArray = [String]()
    var uniqueMonthArray = [String]()
    
    let formatter = DateFormatter()
    let monthFormatter = DateFormatter()
    
    @IBOutlet weak var datePickerView: UIPickerView!
    @IBOutlet weak var pickerViewBgView: UIView!
    @IBOutlet weak var lblLowestValue: UILabel!
    @IBOutlet weak var lblTodayDate: UILabel!
    @IBOutlet weak var low_highestView: UIView!
    
    @IBOutlet weak var lblHighestValue: UILabel!
    @IBOutlet weak var lblAverageValue: UILabel!
    @IBOutlet weak var chartListToggleBtn: UISegmentedControl!
    
    @IBOutlet weak var unitToggleBtn: UISegmentedControl!
    @IBOutlet weak var switchTimePeriod: ADVSegmentedControl!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var imgLineGlucose: UIImageView!
    @IBOutlet weak var imgLinePulse: UIImageView!
    @IBOutlet weak var imgLineBFV: UIImageView!
    @IBOutlet weak var imgLineSpO2: UIImageView!
    @IBOutlet weak var imgLinehb: UIImageView!
    @IBOutlet weak var chartContrainer: UIView!
    @IBOutlet weak var historyChartView: UIView!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var lblTodayHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var chartToggleBtnHeightconst: NSLayoutConstraint!
    @IBOutlet weak var unitToggleBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblUnitheightConst: NSLayoutConstraint!
    @IBOutlet weak var btnTodayheightConst: NSLayoutConstraint!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        historyListViewMethod()
        historyChartViewMethod()
        chartView.isHidden = false
    }
    
    //MARK:- Intial Setup methods
    
    func intialSetup(){
        
        listView.delegate = self
        datePickerView.delegate = self
        datePickerView.dataSource = self
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        monthFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        
        formatter.dateFormat = "yyyy-M-dd"
        
        selectedTimePeriod()
        fetchUserTestData()
        
        setDefaultSettings()
        
        lblUnit.isHidden = true
        unitToggleBtn.isHidden = false
        
        self.title = historyVC_title
        self.navigationItem.setHidesBackButton(true, animated: false)
        pickerViewBgView.isHidden = true
        
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(HistoryVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
        
        if glucoseUnitChoosed == "mmol_L"{
            unitToggleBtn.selectedSegmentIndex = 0
        }
        else{
            unitToggleBtn.selectedSegmentIndex = 1
        }
        
        if UIScreen.main.bounds.height > 736{
            
            lblTodayHeightConst.constant = 50.0
            chartToggleBtnHeightconst.constant = 50.0
            unitToggleBtnHeightConst.constant = 50.0
            lblUnitheightConst.constant = 50.0
            btnTodayheightConst.constant = 50.0
        }
        else{
            
            lblTodayHeightConst.constant = 28.0
            chartToggleBtnHeightconst.constant = 28.0
            unitToggleBtnHeightConst.constant = 28.0
            lblUnitheightConst.constant = 28.0
            btnTodayheightConst.constant = 28.0
        }
        
    }
    
    func setDefaultSettings(){
        chartListToggleBtn.selectedSegmentIndex = 0
        switchSetup()
    }
    
    func fetchUserTestData(){
        allRecordDict = coreDataObj.fetchRequestForTestDetail()
        
        if allRecordDict.count != 0{
            let lastRecord = allRecordDict.last
            
            daySelectedDate = lastRecord?.value(forKey: "date") as! Date
            lblTodayDate.text = formatter.string(from: daySelectedDate)
            getTodayData()
            glucoseBtnTapped()
            
            var dateS = [Date]()
            var dateArr = [String]()
            var MonthArr = [String]()
            monthFormatter.dateFormat = "yyyy-M"
            
            for dicts in allRecordDict{
                let dateToSearch:Date = dicts.value(forKey: "date") as! Date
                dateS.append(dateToSearch)
                dateArr.append(formatter.string(from: dateToSearch))
                MonthArr.append(monthFormatter.string(from: dateToSearch))
            }
            
            uniqueDatesArray = Array(Set(dateArr))
            uniqueDatesArray = uniqueDatesArray.sorted { $0 > $1 }
            
            uniqueMonthArray = Array(Set(MonthArr))
            uniqueMonthArray = uniqueMonthArray.sorted { $0 > $1 }
            
            monthSelectedDate = daySelectedDate
        }
    }
    
    //MARK:- Other Methods
    
    func getTodayData(){
        
        timePeriodSelected = ChoosetimePeriod
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: daySelectedDate)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        
        let predicate = NSPredicate(format: "date >= %@ AND date =< %@", argumentArray: [startDate!, endDate!])
        let dayArray = allRecordDict.filter { predicate.evaluate(with: $0) };
        searchData(dayArray)
    }
    
    func getLastWeekDates(){
        timePeriodSelected = ChoosetimePeriod

        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        // start with today
        var components = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: daySelectedDate)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let startDate = cal.date(from: components)
        
        var date = cal.startOfDay(for: startDate!)
        
        var days = [Int]()
        for _ in 1 ... 7 {
            // get day component:
            let day = (cal as NSCalendar).component(.day, from: date)
            
            // let getDate = day as NSDate
            days.append(day)
            
            // move back in time by one day:
            date  = (cal as NSCalendar).date(byAdding: .day, value: -1, to: date, options: NSCalendar.Options.matchFirst)!
        }
        
        components = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = cal.date(from: components)
        
        let predicate = NSPredicate(format: "date <= %@ AND date >= %@", startDate! as CVarArg, endDate! as CVarArg);
        
        let dayArray = allRecordDict.filter { predicate.evaluate(with: $0) };
        self.searchData(dayArray)
    }
    
    func getLastMonthDates(){
        timePeriodSelected = ChoosetimePeriod

        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        // start with today
        var components = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: monthSelectedDate)
        components.day = 01
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = cal.date(from: components)
        
        var date = cal.startOfDay(for: startDate!)
        var days = [Int]()
        
        for _ in 1 ... 30 {
            let day = (cal as NSCalendar).component(.day, from: date)
            days.append(day)
            
            date  = (cal as NSCalendar).date(byAdding: .day, value: 1, to: date, options: NSCalendar.Options.matchFirst)!
        }
        components = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = cal.date(from: components)
        
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as CVarArg, endDate! as CVarArg);
        
        let dayArray = allRecordDict.filter { predicate.evaluate(with: $0) };
        self.searchData(dayArray)
    }
    
    func getSelectedPeriodDates(){
        timePeriodSelected = ChoosetimePeriod

        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        pickerViewStartDatesArray.append(date)
        pickerViewEndDatesArray.append(date)
        
        var days = [Int]()
        
        for _ in 1 ... 30 {
            let day = (cal as NSCalendar).component(.day, from: date)
            days.append(day)
            
            date  = (cal as NSCalendar).date(byAdding: .day, value: -1, to: date, options: NSCalendar.Options.matchFirst)!
            pickerViewEndDatesArray.append(date)
            pickerViewStartDatesArray.append(date)
        }
    }
    
    func searchPeriodData(){
        
        if periodStartDate.compare(periodEndDate) != ComparisonResult.orderedAscending{
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: periodStartDate)
            components.hour = 23
            components.minute = 59
            components.second = 59
            let startDate = calendar.date(from: components)
            
            components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: periodEndDate)
            components.hour = 00
            components.minute = 00
            components.second = 00
            let endDate = calendar.date(from: components)
            
            let predicate = NSPredicate(format: "date <= %@ AND date >= %@", startDate! as CVarArg ,endDate! as CVarArg );
            let dayArray = allRecordDict.filter { predicate.evaluate(with: $0) };
            self.searchData(dayArray)
        }
        else{
            Utility.showAlert(errorText, message: historyVC_wrongPeriodDateSelectionAlertMessagse, viewController: self)
        }

    }
    
    func searchData(_ array:[NSMutableDictionary]){
        
        glucose_mmol_L = []; glucose_mg_dL = []; hb_g_L = []; hb_g_dL = []; diet = []; oxSat = []; medicine = []; record_id = []; date = []; pulse = []; bloodFlow = []; time = []
        
        if array.count == 0{
            Utility.showAlert(messageText, message: historyVC_alert_noRecord, viewController: self)
        }
        
        for dicts in array{
            
            let glucMmol_L = Double(dicts.value(forKey: "gluc") as! String)!/10
            let glucMg_dl = Utility.mmol_LTomg_gL(glucMmol_L)
            
            glucose_mg_dL.append(Double(truncating: NSDecimalNumber(value: glucMg_dl as Double).rounding(accordingToBehavior: MConstants.behavior)))
            
            glucose_mmol_L.append(Double(dicts.value(forKey: "gluc") as! String)!/10)
            
            hb_g_L.append(Double(dicts.value(forKey: "hb") as! String)!/10)
            hb_g_dL.append(Double(dicts.value(forKey: "hb") as! String)!/100)
            
            oxSat.append(Double(dicts.value(forKey: "oxSat") as! String)!)
            pulse.append(Double(dicts.value(forKey: "pulse") as! String)!)
            bloodFlow.append(Double(dicts.value(forKey: "speed") as! String)!)
            
            date.append(dicts.value(forKey: "date") as! Date)
            
            medicine.append(dicts.value(forKey: "medicine") as! String)
            diet.append(dicts.value(forKey: "diet") as! String)
            time.append(dicts.value(forKey: "time") as! String)
            record_id.append(dicts.value(forKey: "record_id") as! String)
            
        }
        checkWhichResultToShow()
    }
    
    func setHighestLowestValues(_ array: [Double]){
        
        if array.count != 0 {
            
            lblLowestValue.text = String(format: "%.1f", array.min()!)
            lblHighestValue.text = String(format: "%.1f", array.max()!)
            lblAverageValue.text = String(format: "%.1f",((array.min()!)+(array.max()!))/2)
        }
        else{
            lblLowestValue.text = ""
            lblHighestValue.text = ""
            lblAverageValue.text = ""
        }
    }
    
    func historyListViewMethod(){
        listView.delegate = self
        listView.isHidden = true
        listView = (Bundle.main.loadNibNamed("HistoryListViewScreen", owner: self, options: nil)?[0] as? HistoryListViewScreen)!
        listView.frame = CGRect(x: 1, y: 0, width: self.historyView.bounds.width, height: self.historyView.bounds.height)
        self.historyView.addSubview(listView)
        listView.isHidden = true
    }
    
    func historyChartViewMethod(){
        chartView.isHidden = true
        chartView = (Bundle.main.loadNibNamed("HistoryChartViewScreen", owner: self, options: nil)?[0] as? HistoryChartViewScreen)!
        chartView.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width-20,height: self.chartContrainer.frame.height)
        self.chartContrainer.addSubview(chartView)
        chartView.isHidden = true
    }
    
    func switchSetup(){
        switchTimePeriod.items = [historyVC_dayText,historyVC_weekText,historyVC_monthText,historyVC_periodText]
        switchTimePeriod.selectedIndex = 0
        selectedTimeDay()
        switchTimePeriod.addTarget(self, action: #selector(HistoryVC.segmentValueChanged(_:)), for: .valueChanged)
    }
    
    func glucoseBtnTapped(){
        
        if glucoseUnitChoosed == "mmol_L"{
            unitToggleBtn.selectedSegmentIndex = 0
        }
        else{
            unitToggleBtn.selectedSegmentIndex = 1
        }
        pickerViewBgView.isHidden = true
        unitToggleBtn.setTitle("\(unit_AText)", forSegmentAt: 0)
        unitToggleBtn.setTitle("\(unit_Btext)", forSegmentAt: 1)
        lblUnit.isHidden = true
        unitToggleBtn.isHidden = false
        
        if glucoseUnitChoosed == "mg_dL"{
            dataToShow(glucose_mg_dL)
            setHighestLowestValues(glucose_mg_dL)
        }
        else{
            dataToShow(glucose_mmol_L)
            setHighestLowestValues(glucose_mmol_L)
        }
        
        checkHiddenView()
        
        imgLineSpO2.backgroundColor = UIColor.clear
        imgLinehb.backgroundColor = UIColor.clear
        imgLinePulse.backgroundColor = UIColor.clear
        imgLineBFV.backgroundColor = UIColor.clear
        imgLineGlucose.backgroundColor = UIColor.blue
    }
    
    func hbBtnTapped(){
        if hbUnitChoosed == "g_L"{
            unitToggleBtn.selectedSegmentIndex = 0
        }
        else{
            unitToggleBtn.selectedSegmentIndex = 1
        }
        pickerViewBgView.isHidden = true
        unitToggleBtn.setTitle(g_LUnitText, forSegmentAt: 0)
        unitToggleBtn.setTitle(g_dLUnitText, forSegmentAt: 1)
        lblUnit.isHidden = true
        unitToggleBtn.isHidden = false
        
        if hbUnitChoosed == "g_dL"{
            dataToShow(hb_g_dL)
            setHighestLowestValues(hb_g_dL)
        }
        else{
            dataToShow(hb_g_L)
            setHighestLowestValues(hb_g_L)
        }
        checkHiddenView()
        
        imgLineSpO2.backgroundColor = UIColor.clear
        imgLinehb.backgroundColor = UIColor.blue
        imgLinePulse.backgroundColor = UIColor.clear
        imgLineBFV.backgroundColor = UIColor.clear
        imgLineGlucose.backgroundColor = UIColor.clear
    }
    
    func pulseBtnTapped(){
        pickerViewBgView.isHidden = true
        
        lblUnit.isHidden = false
        unitToggleBtn.isHidden = true
        
        lblUnit.text = timePerMinUnitText
        dataToShow(pulse)
        checkHiddenView()
        setHighestLowestValues(pulse)
        
        imgLineSpO2.backgroundColor = UIColor.clear
        imgLinehb.backgroundColor = UIColor.clear
        imgLinePulse.backgroundColor = UIColor.blue
        imgLineBFV.backgroundColor = UIColor.clear
        imgLineGlucose.backgroundColor = UIColor.clear
    }
    
    func bloodFlowBtnTapped(){
        
        
        pickerViewBgView.isHidden = true
        
        lblUnit.isHidden = false
        unitToggleBtn.isHidden = true
        
        lblUnit.text = auUnitText
        dataToShow(bloodFlow)
        checkHiddenView()
        
        setHighestLowestValues(bloodFlow)
        
        imgLineSpO2.backgroundColor = UIColor.clear
        imgLinehb.backgroundColor = UIColor.clear
        imgLinePulse.backgroundColor = UIColor.clear
        imgLineBFV.backgroundColor = UIColor.blue
        imgLineGlucose.backgroundColor = UIColor.clear
    }
    
    func spO2BtnTapped(){
        pickerViewBgView.isHidden = true
        
        lblUnit.isHidden = false
        unitToggleBtn.isHidden = true
        
        lblUnit.text = "%"
        dataToShow(oxSat)
        checkHiddenView()
        setHighestLowestValues(oxSat)
        
        imgLineSpO2.backgroundColor = UIColor.blue
        imgLinehb.backgroundColor = UIColor.clear
        imgLinePulse.backgroundColor = UIColor.clear
        imgLineBFV.backgroundColor = UIColor.clear
        imgLineGlucose.backgroundColor = UIColor.clear
    }
    
    func checkHiddenView(){
        if listView.isHidden{
            historyChartViewMethod()
            chartView.isHidden = false
        }
        else{
            historyListViewMethod()
            listView.isHidden = false
        }
    }
    
    func selectedTimeDay(){
        lblTodayDate.text = formatter.string(from: daySelectedDate)
        pickerViewBgView.isHidden = true
        
        getTodayData()
    }
    
    func selectedTimeWeek(){
        lblTodayDate.text = formatter.string(from: daySelectedDate)
        pickerViewBgView.isHidden = true
        getLastWeekDates()
    }
    
    func selectedTimeMonth(){
        lblTodayDate.text = monthFormatter.string(from: monthSelectedDate)
        pickerViewBgView.isHidden = true
        getLastMonthDates()
    }
    
    func selectedTimePeriod(){
        getSelectedPeriodDates()
    }
    
    func dataToShow(_ result: [Double]){
        
        resultDictToShow = result
        
        dateDictToShow = date
        dietDictToShow = diet
        medicineDictToShow = medicine
        recordDictToShow = record_id
        timeDictToShow = time
    }
    
    func deleteBtnAction(_ indexPath:IndexPath){
    }
    
    //MARK:- Button Actions
    
    @IBAction func chartListToggle(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:historyChartViewMethod()
        listView.isHidden = true
        chartView.isHidden = false
            break
        case 1: historyListViewMethod()
        chartView.isHidden = true
        listView.isHidden = false
            break
        default: break
        }
    }
    
    @IBAction func spO2BtnAction(_ sender: UIButton) {
        resultSelected = "spO2"
        spO2BtnTapped()
    }
    
    @IBAction func glucoseBtnAction(_ sender: UIButton) {
        resultSelected = "glucose"
        glucoseBtnTapped()
    }
    
    @IBAction func bloddFlowBtnAction(_ sender: UIButton) {
        resultSelected = "bloodFlow"
        bloodFlowBtnTapped()
    }
    
    @IBAction func hbBtnAction(_ sender: UIButton) {
        resultSelected = "hb"
        hbBtnTapped()
    }
    
    @IBAction func pulseBtnAction(_ sender: UIButton) {
        resultSelected = "pulse"
        pulseBtnTapped()
    }
    
    @objc func segmentValueChanged(_ sender: AnyObject){
        if switchTimePeriod.selectedIndex == 0 {
            ChoosetimePeriod = 0
            selectedTimeDay()
        }
        else if switchTimePeriod.selectedIndex == 1{
            ChoosetimePeriod = 1
            selectedTimeWeek()
        }
        else if switchTimePeriod.selectedIndex == 2{
            ChoosetimePeriod = 2
            selectedTimeMonth()
        }
        else if switchTimePeriod.selectedIndex == 3{
            ChoosetimePeriod = 3
            selectedTimePeriod()
            datePickerView.reloadAllComponents()
            pickerViewBgView.isHidden = false
        }
    }
    
    @IBAction func unitToggleBtn(_ sender: UISegmentedControl) {
        if resultSelected == "glucose"
        {
            if resultDictToShow.count != 0{
                switch sender.selectedSegmentIndex {
                case 0:
                    glucoseUnitChoosed = "mmol_L"
                    glucoseBtnTapped()
                    break
                case 1:
                    glucoseUnitChoosed = "mg_dL"
                    glucoseBtnTapped()
                    
                    break
                default: break
                }
            }
        }
        else{
            if resultDictToShow.count != 0{
                switch sender.selectedSegmentIndex {
                case 0:
                    hbUnitChoosed = "g_L"
                    hbBtnTapped()
                    break
                case 1:
                    hbUnitChoosed = "g_dL"
                    hbBtnTapped()
                    
                    break
                default: break
                }
            }
        }
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        switch ChoosetimePeriod {
        case 0:
            daySelectedDate = sender.date
            lblTodayDate.text = formatter.string(from: daySelectedDate)
            selectedTimeDay()
            break
        case 1:
            daySelectedDate = sender.date
            lblTodayDate.text = formatter.string(from: daySelectedDate)
            selectedTimeWeek()
            break
        case 2:
            daySelectedDate = sender.date
            lblTodayDate.text = monthFormatter.string(from: monthSelectedDate)
            selectedTimeMonth()
            
            break
        default:
            break
        }
    }
    
    @IBAction func showDateBtnAction(_ sender: UIButton) {
        switch ChoosetimePeriod {
        case 3:
            break
        default:
            pickerViewBgView.isHidden = false
            datePickerView.reloadAllComponents()
            break
        }
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: UIButton) {
        pickerViewBgView.isHidden = true
    }
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Picker view & textfeild delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        switch ChoosetimePeriod {
        case 3: return 2
        default: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        switch ChoosetimePeriod {
        case 3:
            switch(component){
            case 0:
                let str = uniqueDatesArray[row]
                return str
            case 1:
                let str = uniqueDatesArray[row]
                return str
            default:
                return "No dates"
            }
        case 2:
            let str = uniqueMonthArray[row]
            return str
        default:
            let str = uniqueDatesArray[row]
            return str
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch ChoosetimePeriod {
        case 2:  return uniqueMonthArray.count
        default:  return uniqueDatesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if uniqueDatesArray.count != 0{
            switch ChoosetimePeriod {
            case 3:
                switch(component){
                case 0: periodStartDate = formatter.date(from: uniqueDatesArray[row])!
                    break
                case 1: periodEndDate = formatter.date(from: uniqueDatesArray[row])!//pickerViewEndDatesArray[row]
                    break
                default:
                    break
                }
                searchPeriodData()
                
            case 0:
                daySelectedDate = formatter.date(from: uniqueDatesArray[row])!
                lblTodayDate.text = formatter.string(from: daySelectedDate)
                selectedTimeDay()
                break
            case 1:
                daySelectedDate = formatter.date(from: uniqueDatesArray[row])!
                lblTodayDate.text = formatter.string(from: daySelectedDate)
                selectedTimeWeek()
                break
            case 2:
                monthSelectedDate = monthFormatter.date(from: uniqueMonthArray[row])!
                lblTodayDate.text = monthFormatter.string(from: monthSelectedDate)
                selectedTimeMonth()
                
                break
                
            default: break
            }
        }
    }
    
    func checkWhichResultToShow(){
        switch resultSelected {
        case "glucose":glucoseBtnTapped()
        if glucoseUnitChoosed == "mmol_L"{
            setHighestLowestValues(glucose_mmol_L)
        }else{
            setHighestLowestValues(glucose_mg_dL)
        }
            break
        case "spO2":spO2BtnTapped()
        setHighestLowestValues(oxSat)
            break
        case "hb":hbBtnTapped()
        if hbUnitChoosed == "g_L"{
            setHighestLowestValues(hb_g_L)
        }else{
            setHighestLowestValues(hb_g_dL)
        }
            break
        case "bloodFlow":bloodFlowBtnTapped()
        setHighestLowestValues(bloodFlow)
            break
        case "pulse":pulseBtnTapped()
        setHighestLowestValues(pulse)
            break
        default:
            break
        }
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        
        if resultDictToShow.count != 0{
            displayShareSheet()
            //shareButtonTapped()
        }
        else{
            Utility.showAlert(errorText, message: historyVC_alert_noRecord, viewController: self)
        }
    }

    func displayShareSheet() {
        
        let title = historyVC_mailSubject
        let content = historyVC_mailMessage
        
        let file = writeToCVSFile()
        let fileURL = URL(fileURLWithPath: file)
        
        var objectsToShare = [AnyObject]()
        objectsToShare = [title as AnyObject, content as AnyObject, fileURL as AnyObject]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.setValue(title, forKey: "Subject")
        //activityVC.setValue("ankita.mittra@imarkinfotech.com", forKey: "ToRecipients")
        
        self.present(activityVC, animated: true, completion: nil)
        
        //presentViewController(activityViewController, animated: true, completion: {})
    }
    
    // MARK:- MFMailComposeViewController Delegate

//    func writeToCVSFile()->String
//    {
//        let text = writeContent()
//        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("file.pdf")
//
//        do{
//            try text.writeToFile(paths, atomically: false, encoding: NSUTF8StringEncoding)
//        }
//        catch{
//        }
//        return paths
//    }
    
    func writeToCVSFile()->String{
        
        let text = writeContent()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        do{
            try text.write(toFile: "\(documentsPath)/\(historyVC_fileName).csv", atomically: false, encoding: String.Encoding.utf8)
        }
        catch{
        }
        return "\(documentsPath)/\(historyVC_fileName).csv"
    }
    
    func writeContent()-> String{
        
        var glucStr = "\(datesText), \(timeText), \(bloodGlucoseText)(\(mmol_LUnitText)), \(bloodGlucoseText)(\(mg_dLUnitText)),\(hemoglobinText)(\(g_LUnitText)), \(pulseText), \(SpO2Text), \(bloodFlowVelocityText)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        dateFormatter.dateFormat = "YYYY/MM/dd"
        
        let stringFromDateArr = dateDictToShow.map{dateFormatter.string(from: $0)}
        
        for i in 0  ..< stringFromDateArr.count{
            glucStr += "\n \(stringFromDateArr[i]),\(self.time[i]),\(self.glucose_mmol_L[i]),\(self.glucose_mg_dL[i]),\(self.hb_g_L[i]),\(self.pulse[i]),\(self.oxSat[i]),\(self.bloodFlow[i])"
        }
        return glucStr
    }
    

    func shareButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject(historyVC_mailSubject)
        mailComposerVC.setMessageBody(historyVC_mailMessage, isHTML: false)
        
        let filePaths = writeToCVSFile()
        
        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePaths)) {
            mailComposerVC.addAttachmentData(fileData, mimeType: "text/csv", fileName: historyVC_fileName)//
        }

        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        Utility.showAlert(historyVC_alertTitle_mailNotSend, message: historyVC_alert_mailNotSend, viewController: self)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
