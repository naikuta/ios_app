//
//  ScoreStackLabel.swift
//  TimerAndStats
//
//  Created by iku on 2022/05/05.
//

import UIKit

class ScoreStackLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
