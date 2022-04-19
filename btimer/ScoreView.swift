//
//  ScoreView.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/16.
//

import UIKit

class ScoreView: UIStackView {
    
    override init(frame: CGRect) { // for using CustomView in code
      super.init(frame: frame)
    
        self.viewWithTag(1)
    }

    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        
    }
}
