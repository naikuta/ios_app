//
//  ScoreTitleStackView.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/18.
//

import UIKit

class ScoreTitleStackView: UIStackView {
    
    override init(frame: CGRect) { // for using CustomView in code
      super.init(frame: frame)
        
        for i in 0..<6 {
            
            let label:UILabel = UILabel()
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.black.cgColor
            
            switch i {
            case 1:
                label.text = "SH"
            case 2:
                label.text = "P"
            case 3:
                label.text = "R"
            case 4:
                label.text = "A"
            case 5:
                label.text = "S"
            default:
                label.text = ""
            }
        }
    }

    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        
    }
}
