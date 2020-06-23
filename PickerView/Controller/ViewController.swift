//
//  ViewController.swift
//  PickerView
//
//  Created by Shawn Li on 4/30/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var country = ["China", "the United State", "India", "Japan", "the United Kindom"]
    var color = ["Blue","Black","White","Gray","Red","Pink"]
    var isDropDownVisable = false
    @IBOutlet weak var displayCountry: UITextField!
    @IBOutlet weak var countryList: UIPickerView!
    @IBOutlet weak var displayDate: UITextField!
    private var datePicker: UIDatePicker?
    @IBOutlet weak var colorDropDown: UITableView!
    @IBOutlet weak var colorBtnOutlet: UIButton!
    @IBOutlet weak var colorDropDownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pickerViewSetting()
        datePickerSetting()
        textFieldSetting()
//      gestureSetting()
        dropDownSetting()
        
    }
    
    // MARK: - Picker View Implementation
    
    func pickerViewSetting()
    {
        countryList.dataSource = self
        countryList.delegate = self
        displayCountry.delegate = self
        countryList.isHidden = true
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     {
        return country.count
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return country[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        displayCountry.text = country[row]
        countryList.isHidden = true
        displayCountry.resignFirstResponder()
    }
    

}

    // MARK: - TextField Implementation

extension ViewController: UITextFieldDelegate {
    
    func textFieldSetting()
    {
        nameInput.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if textField == displayCountry
        {
            displayCountry.inputView = countryList
            countryList.isHidden = false
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        nameInput.resignFirstResponder()
//        nameInput.endEditing(true)
        return true
    }
}

// MARK: - Date Picker Implementation

extension ViewController
{

    func datePickerSetting()
    {
        datePicker = UIDatePicker()
        displayDate.inputView = datePicker
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:  )), for: .valueChanged)
        dismissDatePicker()
    }
    
    @objc func dateChanged(datePicker: UIDatePicker)
    {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM/dd/yyyy"
           displayDate.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    func dismissDatePicker()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        displayDate.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissPicker()
    {
        displayDate.endEditing(true)
    }
}

// MARK: - Gesture Implementation for Dismissing the page
extension ViewController
{
    
    func gestureSetting()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
}

// MARK: - Drop Down Menue

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func dropDownSetting()
    {
        colorDropDown.delegate = self
        colorDropDown.dataSource = self
        colorDropDownHeightConstraint.constant = 0
    }
    
    @IBAction func selectColor(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.5)
        {
            if self.isDropDownVisable == false
            {
                self.isDropDownVisable = true
                self.colorDropDownHeightConstraint.constant = CGFloat(44.0 * Double(self.color.count))
            }
            else
            {
                self.colorDropDownHeightConstraint.constant = 0
                self.isDropDownVisable = false
            }
               self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return color.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "color",for: indexPath)
        cell.textLabel?.text = color[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        colorBtnOutlet.setTitle("\(color[indexPath.row])", for: .normal)
        UIView.animate(withDuration: 0.5)
        {
            self.colorDropDownHeightConstraint.constant = 0
            self.isDropDownVisable = false
            self.view.layoutIfNeeded()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
