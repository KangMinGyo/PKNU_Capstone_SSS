//
//  ViewController.swift
//  Team_SSS
//
//  Created by KangMingyo on 2022/05/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var easyReportView: UIView!
    @IBOutlet weak var reportHelmet: UIView!
    @IBOutlet weak var reportOther: UIView!
    @IBOutlet weak var reportRules: UIView!
    
    @IBOutlet weak var scooterImage: UIImageView!
    @IBOutlet weak var helmetImage: UIImageView!
    @IBOutlet weak var otherImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view 모서리 둥글게
        easyReportView.layer.cornerRadius = 20
        reportHelmet.layer.cornerRadius = 20
        reportOther.layer.cornerRadius = 20
        reportRules.layer.cornerRadius = 20
        
        //Image 투명도 조절
        scooterImage.alpha = 0.1
        helmetImage.alpha = 0.1
        otherImage.alpha = 0.1
    }


}

