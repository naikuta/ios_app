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
    
    var minSelected: Int = 0
    var secSelected: Int = 0
    var mSecSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        minPicker.dataSource = self
        minPicker.delegate = self
        minSecPickerView.delegate = self
        minSecPickerView.dataSource = self
        secPickerView.delegate = self
        secPickerView.dataSource = self
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
        } else {
            return dataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.minPicker {
            minSelected = dataSource[row]
        } else if pickerView == self.secPickerView {
            secSelected = dataSource[row]
        } else {
            mSecSelected = dataSource[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == self.minPicker {
            return String(dataSource[row])
        } else if pickerView == self.secPickerView {
            return String(secDataSource[row])
        } else {
            return String(dataSource[row])
        }
    }
    
    @IBAction func onResetButton(_ sender: Any) {
        pickerView(self.minPicker, didSelectRow: 0, inComponent: 0)
        pickerView(self.minPicker, didSelectRow: 0, inComponent: 1)
        pickerView(self.minPicker, didSelectRow: 0, inComponent: 2)
    }
}

