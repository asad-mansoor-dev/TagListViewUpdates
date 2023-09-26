//
//  FilterViewController.swift
//  EasyGift
//
//  Created by Asad Mehmood on 13/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import TagListView
import RangeSeekSlider

class FilterViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var categoryTextField: UITextField!
//    {
//        didSet {
//            if AppSettings.appLanguage == AppLanguage.arabic.rawValue {
//                self.categoryTextField.textAlignment = .right
//            }
//            else {
//                self.categoryTextField.textAlignment = .left
//            }
//        }
//    }
    @IBOutlet weak var occasionsTextField: UITextField!
//    {
//        didSet {
//            if AppSettings.appLanguage == AppLanguage.arabic.rawValue {
//                self.occasionsTextField.textAlignment = .right
//            }
//            else {
//                self.occasionsTextField.textAlignment = .left
//            }
//        }
//    }
    @IBOutlet weak var giftDeliveryDateTextField: UITextField!
//    {
//        didSet {
//            if AppSettings.appLanguage == AppLanguage.arabic.rawValue {
//                self.giftDeliveryDateTextField.textAlignment = .right
//            }
//            else {
//                self.giftDeliveryDateTextField.textAlignment = .left
//            }
//        }
//    }
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var femaleButton: RadioButton!
    @IBOutlet weak var maleButton: RadioButton!
    @IBOutlet weak var customDeliveryButton: RadioButton!
    @IBOutlet weak var sameDayDeliveryButton: RadioButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tagsList: TagListView!
    @IBOutlet weak var priceRangeSlider: RangeSeekSlider!
    @IBOutlet weak var backButtonImage: UIImageView!
//    {
//            didSet {
//                if AppSettings.appLanguage == AppLanguage.arabic.rawValue {
//                    backButtonImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//                }
//            }
//        }
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var occasionsTableView: UITableView!
    @IBOutlet weak var occasionsButton: UIButton!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var categoriesTableContainer: UIView!
    
    @IBOutlet weak var categoriesDropDownButton: UIButton!
    @IBOutlet weak var occasionsDropDownButton: UIButton!
    
    @IBOutlet weak var categoriesTableContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var occasionsTableContainer: UIView!
    @IBOutlet weak var occasionsTableContainerHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    
    // Delivery DatePicker view
    var datePicker = UIDatePicker()
    var datePickerToolBar = UIToolbar()

    // Filter tags default data
    var tags: [String] = ["", "\("SAR") 0 - \("SAR") 1000", "", "", ""]
    enum Tags : Int {
        case gender, priceRange, category, occasion, maxProcessingTime
    }
    let supportedGenders = ["Female", "Male"]
    var previousFilters: [String: String]?
    
    var categories : [Categories] = [] {
        didSet{
            self.categoriesTableView.reloadData()
        }
    }
    var occasions : [OccasionsModel] = [] {
        didSet{
            self.occasionsTableView.reloadData()
        }
    }
    var selectedCategoryId: String?
    var selectedOccasionId: String?
    var category: Categories?
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderRadioButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        sender.alternateButton![0].isSelected = false
        
        let index = Tags.gender.rawValue
        var title = ""
        if femaleButton.isSelected {
            title = "Female"
        } else if maleButton.isSelected {
            title = "Male"
        } else {
            tagsList.removeTag(tags[index])
            tags[index] = ""
            return
        }
        updateTagsData(index: index, title: title)
    }
    
    @IBAction func deliveryRadioButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        sender.alternateButton![0].isSelected = false
        
        let index = Tags.maxProcessingTime.rawValue
        
        if customDeliveryButton.isSelected {
            updateTagsData(index: Tags.maxProcessingTime.rawValue, title: "")
        
        } else {
//            self.giftDeliveryDateTextField.text = Utility.getCurrentFormattedDate()
//            updateTagsData(index: Tags.maxProcessingTime.rawValue, title: Utility.getCurrentFormattedDate())
        }
        updateTagsData(index: index, title: tags[index])
    }
    
    @IBAction func selectDateButtonPressed(_ sender: UIButton) {
        if customDeliveryButton.isSelected{
            self.createDatePicker()
            self.giftDeliveryDateTextField.layer.borderColor = UIColor.blue.cgColor
            calendarButton.tintColor = .black
        }
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        categoriesTableView.reloadData()
        self.view.layoutIfNeeded()
        categoriesTableContainer.isHidden = true
        UIView.transition(with: self.categoriesTableContainer, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            if self.categoriesTableContainerHeightConstraint.constant != 200 {
                                self.categoriesDropDownButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

                                self.categoriesTableContainer.isHidden = false
                                self.categoriesTableContainer.alpha = 1
                                self.categoriesTableContainerHeightConstraint.constant = 200
                            }
                            else {
                                self.categoriesDropDownButton.transform = CGAffineTransform.identity
                                self.categoriesTableContainerHeightConstraint.constant = 54
                                self.categoriesTableContainer.alpha = 0
                            }
                            self.view.layoutIfNeeded()
        })
    }
    @IBAction func occasionsButtonPressed(_ sender: UIButton) {
        
        occasionsTableView.reloadData()
        self.view.layoutIfNeeded()
        occasionsTableContainer.isHidden = true
        UIView.transition(with: self.occasionsTableContainer, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            if self.occasionsTableContainerHeightConstraint.constant != 200 {
                                self.occasionsDropDownButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                                self.occasionsTableContainer.isHidden = false
                                self.occasionsTableContainer.alpha = 1
                                self.occasionsTableContainerHeightConstraint.constant = 200
                            }
                            else {
                                self.occasionsDropDownButton.transform = CGAffineTransform.identity
                                self.occasionsTableContainerHeightConstraint.constant = 54
                                self.occasionsTableContainer.alpha = 0
                            }
                            self.view.layoutIfNeeded()
        })
    }
    func getNextDate(byAddingDays: Int, to date: Date) -> Date{
        var givenDate = date
        givenDate = givenDate.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        
        var dateComponent = DateComponents()
        dateComponent.day = byAddingDays
        dateComponent.timeZone = TimeZone.current
        
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: dateComponent, to: givenDate) else {
            fatalError("\(#function): Error in creating Date by Adding Components")
        }
        return date
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        var params: [String: String] = [:]
        for i in 0 ..< tags.count {
            if !tags[i].isReallyEmpty {
                // get hours from selected date
                if Tags.init(rawValue: i)! == Tags.maxProcessingTime {
                    
                    let nextDate = getNextDate(byAddingDays: 1, to: tags[i].stringToDate("dd-MM-yyyy")!)
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextDate)
                    components.hour = 0
                    components.minute = 0
                    components.second = 0
                    
                    let hoursRemaining = Calendar.current.dateComponents([.hour], from: Date(), to: Calendar.current.date(from: components)!).hour
                    params["maxProcessingTime"] = String(hoursRemaining!)
                    params["date"] = tags[i]
                }
                // get minimum and maximum price from PriceRangeSlider
                else if Tags.init(rawValue: i)! == Tags.priceRange {
                    let minMaxPrice = tags[i].split(separator: "-")
                    params["minPrice"] = minMaxPrice[0].filter("0123456789.".contains)
                    params["maxPrice"] = minMaxPrice[1].filter("0123456789.".contains)
                }
                else  if Tags.init(rawValue: i)! == Tags.gender {
                    params["gender"] = tags[i].uppercased()
                }
                if let _ = selectedCategoryId {
                    params["categoryId"] = selectedCategoryId!
                }
                if let _ = selectedOccasionId {
                    params["occasionId"] = selectedOccasionId!
                }
            }
        }
//        if let _ = filterParamsDelegate {
//            filterParamsDelegate!.setFilterParams(params: params)
//            backPressed(sender)
//        }
//        else {
//            let searchViewController = SearchViewController()
//            searchViewController.params = params
//            self.show(searchViewController, sender: nil)
//        }
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
//        filterParamsDelegate?.setFilterParams(params: ["":""])
        backPressed(sender)
    }
    
    //MARK:- Selectors
    @objc func datePickerDonePressed() {
//        if datePicker.date < Date() {
//            self.showAlert(title: "text_error".localized, message: "select_future_date".localized)
//            return
//        }
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd-MM-yyyy"
        giftDeliveryDateTextField.text = formatter.string(from: datePicker.date)
        updateTagsData(index: Tags.maxProcessingTime.rawValue, title: giftDeliveryDateTextField.text!)
        removeDatePickerView()
    }
    @objc func datePickerCancelPressed(){
            self.removeDatePickerView()
        }
    //MARK:- Private Functions
    private func setup() {
        // TagsListView
        tagsList.delegate = self
        tagsList.textFont = UIFont.systemFont(ofSize: 14)
        tagsList.marginY = 10
        tagsList.marginX = 14
            
        //Radio Buttons
        maleButton.isSelected = false
        femaleButton.isSelected = false
        maleButton.alternateButton = [femaleButton]
        femaleButton.alternateButton = [maleButton]
        femaleButton.setTitle("female", for: .normal)
        maleButton.setTitle("male", for: .normal)
//        femaleButton.centerTextAndImage(spacing: 11)
//        maleButton.centerTextAndImage(spacing: 11)
        
        customDeliveryButton.isSelected = true
        sameDayDeliveryButton.isSelected = false
        sameDayDeliveryButton.alternateButton = [customDeliveryButton]
        customDeliveryButton.alternateButton = [sameDayDeliveryButton]
        customDeliveryButton.setTitle("text_custom", for: .normal)
        sameDayDeliveryButton.setTitle("text_day", for: .normal)
//        customDeliveryButton.centerTextAndImage(spacing: 11)
//        sameDayDeliveryButton.centerTextAndImage(spacing: 11)
        
        // RangeSeekSlider
        priceRangeSlider.numberFormatter.numberStyle = .decimal
//        priceRangeSlider.numberFormatter.locale = nil
//        priceRangeSlider.numberFormatter.localizesFormat
        priceRangeSlider.minLabelFont = UIFont.systemFont(ofSize: 14)
        priceRangeSlider.maxLabelFont = UIFont.systemFont(ofSize: 14)
        priceRangeSlider.delegate = self
        
        //TextFields
//        giftDeliveryDateTextField.attributedPlaceholder = NSAttributedString(string: Utility.getCurrentFormattedDate(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayBorder])
        setPreviousFiltersData()
        self.setTags()
        
        categoriesTableView.register(UINib(nibName: "OccasionsCategroiesTableCell", bundle: nil), forCellReuseIdentifier: "occasionsCategroiesTableCell")
        occasionsTableView.register(UINib(nibName: "OccasionsCategroiesTableCell", bundle: nil), forCellReuseIdentifier: "occasionsCategroiesTableCell")
        
        fetchOccasions()
        if let _ = category {
            self.selectedCategoryId = category!.id
            self.categoryTextField.isEnabled = false
            self.categoryTextField.text = self.category!.name
            self.categoriesButton.isEnabled = false
            updateTagsData(index: Tags.category.rawValue, title: self.categoryTextField.text!)
            return
        }
        fetchCategories()
    }
    
    private func setPreviousFiltersData() {
        if let _ = previousFilters {
            // get and Set Genders
            if let gender = previousFilters!["gender"] {
                if gender == "MALE" || gender == "Male" {
                    self.maleButton.isSelected = true
                    self.tags[Tags.gender.rawValue] = "Male"
                }
                else {
                    self.femaleButton.isSelected = true
                    self.tags[Tags.gender.rawValue] = "Female"
                }
            }
            else {
                self.tags[Tags.gender.rawValue] = ""
                self.maleButton.isSelected = false
                self.femaleButton.isSelected = false
            }
            // get and set PriceRangeSlider values
            if let minPrice = previousFilters!["minPrice"] {
                if let maxPrice = previousFilters!["maxPrice"] {
                    self.tags[Tags.priceRange.rawValue] = "\("SAR") \(minPrice) - \("SAR") \(maxPrice)"
                    self.priceRangeSlider.selectedMinValue = CGFloat(Int(minPrice)!)
                    self.priceRangeSlider.selectedMaxValue = CGFloat(Int(maxPrice)!)
                }
            }
            else {
                self.tags[Tags.priceRange.rawValue] = ""
            }
            // get and set date value
            if let date = previousFilters!["date"] {
                self.tags[Tags.maxProcessingTime.rawValue] = date
                self.giftDeliveryDateTextField.text = date
                if date == Date().dateToString("dd-MM-yyyy"){
                    self.sameDayDeliveryButton.isSelected = true
                    self.customDeliveryButton.isSelected = false
                }
            }
        }
    }
    
    // Tags Methods
    private func updateTagsData(index: Int, title: String) {
        
        if !title.isReallyEmpty {
            
            if tags[index].isReallyEmpty {
                tagsList.addTag(title)
                tags[index] = title
                
            } else {
                
                for tagView in tagsList.tagViews {
                    
                    if tagView.titleLabel?.text == tags[index] {
                        tagView.setTitle(title, for: .normal)
                        tagView.frame.size.width = title.width(withConstrainedHeight: 25, font: UIFont.systemFont(ofSize: 14)) + 36
                        tagsList.frame.size.width = tagsList.frame.size.width + title.width(withConstrainedHeight: 25, font: UIFont.systemFont(ofSize: 14)) + 36
                        tags[index] = title
                    }
                }
            }
            tags[index] = title
        }
    }
    private func setTags(){
        
        for tag in tags {
            if !tag.isReallyEmpty {
                tagsList.addTag(tag)
            }
        }
    }
    
    // Delivery Date Picker View
    private func createDatePicker(){
        if !datePicker.isDescendant(of: self.view) {
            datePicker.removeFromSuperview()
            datePickerToolBar.removeFromSuperview()
            
            datePicker = UIDatePicker.init()
            datePicker.autoresizingMask = .flexibleWidth
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.backgroundColor = .white
//            datePicker.setValue(UIColor.secondary, forKey:"textColor")
            datePicker.setValue(false, forKey: "highlightsToday")
            datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(datePicker)
            
            datePickerToolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            let doneButton = UIBarButtonItem(title: "text_confirm", style: .done, target: self, action: #selector(datePickerDonePressed))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(datePickerCancelPressed))
            cancelButton.tintColor = UIColor.red
            datePickerToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            
            datePickerToolBar.tintColor = UIColor.blue
            datePickerToolBar.barTintColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1)
            datePickerToolBar.sizeToFit()
            self.view.addSubview(datePickerToolBar)
        }
    }

    private func removeDatePickerView() {
        datePicker.removeFromSuperview()
        datePickerToolBar.removeFromSuperview()
        giftDeliveryDateTextField.layer.borderColor = UIColor.gray.cgColor
        calendarButton.tintColor = UIColor.gray
    }
    
}

//MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriesTableView {
            return categories.count == 0 ? 4 : categories.count
        }
        else {
            return occasions.count == 0 ? 4 : occasions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "occasionsCategroiesTableCell") as! OccasionsCategroiesTableCell
        if tableView == categoriesTableView {
            if categories.count == 0 {
                cell.showSkeletonAnimation()
            }
            else {
                cell.hideSkeletonAnimation()
                cell.config(indexPath: indexPath, data: categories)
            }
        }
        else {
            if occasions.count == 0 {
                cell.showSkeletonAnimation()
            }
            else {
                cell.hideSkeletonAnimation()
                cell.config(indexPath: indexPath, data: occasions)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoriesTableView {
            if categories.count != 0 && indexPath.row <= categories.count {
                let dataForRow = categories[indexPath.row]
                self.categoryTextField.text = dataForRow.name
                self.selectedCategoryId = dataForRow.id
                categoryButtonPressed(categoriesButton)
                updateTagsData(index: Tags.category.rawValue, title: self.categoryTextField.text!)
            }
        }
        else {
            if occasions.count != 0 && indexPath.row <= occasions.count {
                let dataForRow = occasions[indexPath.row]
                self.occasionsTextField.text = dataForRow.name
                self.selectedOccasionId = dataForRow.id
                occasionsButtonPressed(occasionsButton)
                updateTagsData(index: Tags.occasion.rawValue, title: self.occasionsTextField.text!)
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
}
//MARK:- TagListViewDelegate
extension FilterViewController: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagsList.removeTag(title)
        if let index = tags.firstIndex(of: title) {
            tags[index] = ""
        }
        if supportedGenders.contains(title) {
            self.femaleButton.isSelected = false
            self.maleButton.isSelected = false
        }
//        updateTagsData(index: Tags.occasion.rawValue, title: self.occasionsTextField.text!)
        if tags[Tags.occasion.rawValue].isReallyEmpty {
            occasionsTextField.text = ""
            selectedOccasionId = nil
            
        }
//        updateTagsData(index: Tags.occasion.rawValue, title: self.occasionsTextField.text!)
        if tags[Tags.category.rawValue].isReallyEmpty {
            categoryTextField.text = ""
            selectedCategoryId = nil
            
            self.categoryTextField.isEnabled = true
            self.categoryTextField.text = ""
            self.categoriesButton.isEnabled = true
            fetchCategories()
        }
    }
}

//MARK:- RangeSeekSliderDelegate

extension FilterViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.updateTagsData(index: Tags.priceRange.rawValue, title: "\("SAR") \(Int(minValue)) - \("SAR") \(Int(maxValue))")
    }
}

//MARK: - ApiCall
extension FilterViewController {
    
    func fetchCategories(){
        Categories.fetchCategories { data, error, status, message in
            if let modelData = data {
                self.categories = modelData
            }
        }
    }
    func fetchOccasions(){
        OccasionsModel.fetchOccasions{ data, error, status, message in
            if let modelData = data {
                self.occasions = modelData
            }
        }
    }
}

extension Date {
    func dateToString(_ stringFormatter : String) -> String
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: self)
        let date = formatter.date(from: dateString)
        formatter.dateFormat = stringFormatter
        formatter.locale = Locale(identifier: "SAR")
        let returnString = formatter.string(from: date ?? self)
        
        return returnString
    }
}
