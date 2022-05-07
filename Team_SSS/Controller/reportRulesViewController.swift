//
//  reportRulesViewController.swift
//  Team_SSS
//
//  Created by KangMingyo on 2022/05/06.
//

import UIKit

class reportRulesViewController: UIViewController {

    var firstHide = true
    
    @IBOutlet weak var firstView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func firstButton(_ sender: UIButton) {
        if firstHide == false {
            firstView.isHidden = true
            firstHide = true
        } else {
            firstView.isHidden = false
            firstHide = false
        }
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
