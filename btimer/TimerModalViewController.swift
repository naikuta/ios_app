//
//  TimerModalViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/02/24.
//

import UIKit

protocol TimerModalViewControllerProtocol {
    func setTimer(s: String)
}

class TimerModalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: TimerModalViewControllerProtocol?
    
    @IBOutlet weak var minPicker: UIPickerView!
    @IBOutlet weak var secPickerView: UIPickerView!
    @IBOutlet weak var minSecPickerView: UIPickerView!
    
    private var dataSource = [Int](0...60)
    private var secDataSource = [Int](0...59)
    private var msecDataSource = [Int](0...99)
    
    var minSelected: Int = 0
    var secSelected: Int = 0
    var mSecSelected: Int = 0
    
    var time: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        minPicker.dataSource = self
        minPicker.delegate = self
        minSecPickerView.delegate = self
        minSecPickerView.dataSource = self
        secPickerView.delegate = self
        secPickerView.dataSource = self
        
        let timeStr = getRowNumFromTime(time: time)
        
        self.minPicker.selectRow(Int(timeStr[0])!, inComponent: 0, animated: false)
        self.secPickerView.selectRow(Int(timeStr[1])!, inComponent: 0, animated: false)
        self.minSecPickerView.selectRow(Int(timeStr[2])!, inComponent: 0, animated: false)
        
        minSelected = Int(timeStr[0])!
        secSelected = Int(timeStr[1])!
        mSecSelected = Int(timeStr[2])!
    }
    
    @IBAction func TimerModalClose(_ sender: Any) {
        
        let selectedTime = String(format:"%02d", minSelected) + "-" + String(format:"%02d", secSelected) + "-" + String(format:"%02d", mSecSelected)
        
        self.delegate?.setTimer(s: selectedTime)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.minPicker {
            return dataSource.count
        } else if pickerView == self.secPickerView {
            return secDataSource.count
        } else if pickerView == self.minSecPickerView {
            return msecDataSource.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.minPicker {
            minSelected = dataSource[row]
        } else if pickerView == self.secPickerView {
            secSelected = dataSource[row]
        } else if pickerView == self.minSecPickerView {
            mSecSelected = msecDataSource[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == self.minPicker {
            return String(dataSource[row])
        } else if pickerView == self.secPickerView {
            return String(secDataSource[row])
        } else if pickerView == self.minSecPickerView {
            return String(msecDataSource[row])
        } else {
            return String(0)
        }
    }
    
    @IBAction func onResetButton(_ sender: Any) {
        
        /*
        pickerView(self.minPicker, didSelectRow: 0, inComponent: 0)
        pickerView(self.minPicker, didSelectRow: 0, inComponent: 1)
        pickerView(self.minPicker, didSelectRow: 0, inComponent: 2)
        */
        
        self.minPicker.selectRow(0, inComponent: 0, animated: false)
        self.secPickerView.selectRow(0, inComponent: 0, animated: false)
        self.minSecPickerView.selectRow(0, inComponent: 0, animated: false)
        
        minSelected = 0
        secSelected = 0
        mSecSelected = 0
    }
    
    func getRowNumFromTime(time: String) -> [String.SubSequence] {
        
        return time.split(separator: ":")
    }
}

