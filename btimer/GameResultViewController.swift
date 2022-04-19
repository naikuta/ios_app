//
//  GameResultViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/28.
//

import UIKit
import RealmSwift

class GameResultViewController: UIViewController {
    
    @IBOutlet weak var gameListStack: UIStackView!
    
    let realm = try! Realm()
    //var gameList: List<Game>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let resultGameTitle = realm.objects(Game.self).distinct(by: ["gameTitle"])
        
        for g in resultGameTitle {
            
            let resultGame = realm.objects(Game.self).filter("gameTitle=", g.gameTitle ?? "")
            
            let teamA = resultGame[0].team
            let teamB = resultGame[1].team
            
            
            let gameStack: UIStackView = UIStackView()
            gameStack.axis = .horizontal
            
            let gameTitleLabel: UILabel = UILabel()
            gameTitleLabel.text = g.gameTitle
            
            let gameContentsStack: UIStackView = UIStackView()
            gameContentsStack.axis = .vertical
            
            let teamStack: UIStackView = UIStackView()
            teamStack.axis = .horizontal
            
            let scoreStack: UIStackView = UIStackView()
            scoreStack.axis = .horizontal
            
            let teamALabel: UILabel = UILabel()
            teamALabel.text = "HOME"
            
            let hihunLabel: UILabel = UILabel()
            hihunLabel.text = "-"
            
            let teamBLabel: UILabel = UILabel()
            teamBLabel.text = "AWAY"
            
            let playersA = realm.objects(Player.self).filter("team == %@", teamA)
            let totalA: Int = playersA.sum(ofProperty: "p")
            
            let playersB = realm.objects(Player.self).filter("team == %@", teamB)
            let totalB: Int = playersB.sum(ofProperty: "p")
            
            let teamAScoreLabel: UILabel = UILabel()
            teamAScoreLabel.text = String(format: "%02d", totalA)
            
            let teamBScoreLabel: UILabel = UILabel()
            teamBScoreLabel.text = String(format: "%02d", totalB)
            
            teamStack.addArrangedSubview(teamALabel)
            teamStack.addArrangedSubview(hihunLabel)
            teamStack.addArrangedSubview(teamBLabel)
            
            scoreStack.addArrangedSubview(teamAScoreLabel)
            scoreStack.addArrangedSubview(hihunLabel)
            scoreStack.addArrangedSubview(teamBScoreLabel)
            
            gameContentsStack.addArrangedSubview(teamStack)
            gameContentsStack.addArrangedSubview(scoreStack)
            
            gameStack.addArrangedSubview(gameTitleLabel)
            gameStack.addArrangedSubview(scoreStack)
            
            gameListStack.addArrangedSubview(gameStack)
        }
    }
}
