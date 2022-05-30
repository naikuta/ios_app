//
//  ScoreLabel.swift
//  TimerAndStats
//
//  Created by iku on 2022/04/04.
//

import UIKit

extension UILabel {
    
    func setTextConvert(score: Int) {
        self.text = String(score)
    }
    
    func setScore(p: Player, prop: Int) {
        
        switch prop {
        case 1:
            self.text = String(p.sh)
        case 2:
            self.text = String(p.p)
        case 3:
            self.text = String(p.a)
        case 4:
            self.text = String(p.r)
        case 5:
            self.text = String(p.s)
        default:
            break
        }
    }
}
