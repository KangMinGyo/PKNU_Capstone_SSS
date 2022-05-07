//
//  OtherViewController.swift
//  Team_SSS
//
//  Created by KangMingyo on 2022/05/07.
//

import UIKit

class OtherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    
    let pickerData = ["원동기장치자전거면허 미소지", "(야간)야광띠 발광장치 미착용", "위험한 전동킥보드 운전", "어린이 운전금지", "초과탑승"]
    var pickerHide = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self

    }
    
    //버튼 클릭하면 picker view
    @IBAction func pickerButton(_ sender: UIButton) {
        if pickerHide == true {
            pickerView.isHidden = false
            pickerHide = false
        } else {
            pickerView.isHidden = true
            pickerHide = true
        }
    }
    
    //PickerView 관련
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        otherLabel.text = pickerData[row]
        pickerView.isHidden = true
        pickerHide = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
