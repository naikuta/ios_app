//
//  PlayerLabel.swift
//  TimerAndStats
//
//  Created by iku on 2022/04/14.
//

import UIKit

class PlayerLabel: UILabel {
    
    func PlayerLabel(i :Int) {
        let tagFont = UIFont.systemFont(ofSize: 10)
        self.textAlignment = .center
        self.text = "PLAYER" + String(i)
        self.textColor = UIColor.black
        self.addBorder(width: 0.5, color: UIColor.black, position: .bottom)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.gray.cgColor
        self.font = tagFont
    }
}
