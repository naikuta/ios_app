//
//  GameResultViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/28.
//

import UIKit
import RealmSwift

class GameResultViewController: UIViewController {
   
    @IBOutlet weak var gameResultStack: UIStackView!
    
    let realm = try! Realm()
    //var gameList: List<Game>!
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    
    //var selectGameId: String = ""
    
    var gameId: String = ""
    
    var selectGame: Game!
    
    var rect:CGRect = CGRect()
    
    var closeImageViewSize = UIScreen.main.bounds.width * 0.8 * 0.5 * 0.1 * 0.5
    
    var alert: UIAlertController!
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {

        if segue.destination is ScoreResultViewController {
            
            let scoreResultVC = segue.destination as! ScoreResultViewController

            let game = self.getGameForPK(gameId: gameId)
            
            let teamH:Team = self.getTeamForPK(teamId: game.teamList[0].teamId)
            let teamA = self.getTeamForPK(teamId: game.teamList[1].teamId)
            
            scoreResultVC.teamH = teamH
            scoreResultVC.teamA = teamA
            
            let teamScoreH:Int = teamH.playerList.sum(ofProperty: "p")
            let teamScoreA:Int = teamA.playerList.sum(ofProperty: "p")
            
            scoreResultVC.game = game
            
            scoreResultVC.teamScoreH = String(teamScoreH)
            scoreResultVC.teamScoreA = String(teamScoreA)
            
            scoreResultVC.playersH = Array(teamH.playerList)
            scoreResultVC.playersA = Array(teamA.playerList)
        }
    }
    
    func initialize() {
        
        alert = UIAlertController(title: "Do delete game?", message:  "", preferredStyle:  UIAlertController.Style.alert)
        
        rect =
            CGRect(x:closeImageViewSize * 0.5, y:closeImageViewSize * 0.5, width:closeImageViewSize, height:closeImageViewSize)
        
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            
            let game = self.getGameForPK(gameId: self.selectGame.gameId!)
            
            self.deletePlayers(players: game.teamList[0].playerList)
            self.deletePlayers(players: game.teamList[1].playerList)
            
            self.deleteTeam(team: game.teamList)
            
            self.deleteGame(game: game)
            
            self.loadView()
            self.viewDidLoad()
        })
        
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            print("キャンセル")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initialize()
        
        let game = GameModel.dao.findAll()
        
        var lineCount = 0
        var gameCount = 0
        var lineStack: UIStackView! = nil
        
        for g in game {

            gameCount = gameCount + 1
            
            if gameCount % 2 == 1 {
                                
                lineCount = lineCount + 1
                
                lineStack = UIStackView()
                lineStack.distribution = .fillEqually

                gameResultStack.addArrangedSubview(lineStack)
                lineStack.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.16).isActive = true
                lineStack.widthAnchor.constraint(equalTo: gameResultStack.widthAnchor, multiplier: 1).isActive = true
            }
            
            let teamA = g.teamList[0]
            let teamB = g.teamList[1]
            
            let gameStack: UIStackView = UIStackView()
            gameStack.axis = .vertical
            gameStack.layer.borderWidth = 0.4
            
            let gameTitleStack: UIStackView = UIStackView()
            gameTitleStack.axis = .horizontal
            
            let karaView = UIView()
            
            let gameTitleLabel: LabelGesture = LabelGesture()
            gameTitleLabel.textAlignment = .center
            gameTitleLabel.text = g.gameTitle
            gameTitleLabel.isUserInteractionEnabled = true
            
            gameTitleLabel.singleTap { (ges) in
                if UIGestureRecognizer.State.ended == ges.state {
                    
                    self.gameId = g.gameId!
                    
                    self.performSegue(withIdentifier: "scoreResultSegue", sender: nil)
                }
            }
            
            let view: UIView = UIView()
            let imageClose:UIImage = UIImage(named:"close")!
            let imageCloseView = Gesture(image:imageClose)
            imageCloseView.frame = rect;
            
            view.addSubview(imageCloseView)
            
            gameTitleStack.addArrangedSubview(karaView)
            gameTitleStack.addArrangedSubview(gameTitleLabel)
            gameTitleStack.addArrangedSubview(view)
            
            karaView.widthAnchor.constraint(equalTo: gameTitleStack.widthAnchor, multiplier: 0.1).isActive = true
            karaView.heightAnchor.constraint(equalTo: gameTitleStack.heightAnchor, multiplier: 1).isActive = true
  
            gameTitleLabel.widthAnchor.constraint(equalTo: gameTitleStack.widthAnchor, multiplier: 0.8).isActive = true
            gameTitleLabel.heightAnchor.constraint(equalTo: gameTitleStack.heightAnchor, multiplier: 1).isActive = true
            
            imageCloseView.widthAnchor.constraint(equalTo: gameTitleStack.widthAnchor, multiplier: 0.1).isActive = true
            imageCloseView.heightAnchor.constraint(equalTo: gameTitleStack.heightAnchor, multiplier: 1).isActive = true
            
            // タップジェスチャーの設定
            imageCloseView.isUserInteractionEnabled = true
            
            imageCloseView.singleTap { [self] (ges) in
                if UIGestureRecognizer.State.ended == ges.state {
                    selectGame = g
                    present(alert, animated: true, completion: nil)
                }
            }
            
            let gameContentsStack: UIStackView = UIStackView()
            gameContentsStack.axis = .vertical
            
            let teamStack: UIStackView = UIStackView()
            teamStack.axis = .horizontal
            
            let scoreStack: UIStackView = UIStackView()
            scoreStack.axis = .horizontal
            
            let teamALabel = UILabel(frame: CGRect(x: view.center.x - 50, y: view.center.y - 7.5, width: 100, height: 15))
            teamALabel.text = g.teamList[0].teamName
            teamALabel.font = .systemFont(ofSize: 15)
            teamALabel.textAlignment = .center
            teamALabel.adjustsFontSizeToFitWidth = true
            
            let hihunLabel = UILabel(frame: CGRect(x: view.center.x - 50, y: view.center.y - 7.5, width: 100, height: 15))
            hihunLabel.text = "-"
            hihunLabel.font = .systemFont(ofSize: 15)
            hihunLabel.textAlignment = .center
            hihunLabel.adjustsFontSizeToFitWidth = true

            let teamBLabel = UILabel(frame: CGRect(x: view.center.x - 50, y: view.center.y - 7.5, width: 100, height: 15))
            teamBLabel.text = g.teamList[1].teamName
            teamBLabel.font = .systemFont(ofSize: 15)
            teamBLabel.textAlignment = .center
            teamBLabel.adjustsFontSizeToFitWidth = true
  
            let playersA = teamA.playerList
            let totalA: Int = playersA.sum(ofProperty: "p")
            
            let playersB = teamB.playerList
            let totalB: Int = playersB.sum(ofProperty: "p")
            
            let teamAScoreLabel: UILabel = UILabel()
            teamAScoreLabel.text = String(format: "%02d", totalA)
            teamAScoreLabel.textAlignment = .center
            
            let teamBScoreLabel: UILabel = UILabel()
            teamBScoreLabel.text = String(format: "%02d", totalB)
            teamBScoreLabel.textAlignment = .center
            
            scoreStack.addArrangedSubview(teamALabel)
            scoreStack.addArrangedSubview(teamAScoreLabel)
            scoreStack.addArrangedSubview(hihunLabel)
            scoreStack.addArrangedSubview(teamBScoreLabel)
            scoreStack.addArrangedSubview(teamBLabel)
            
            teamALabel.heightAnchor.constraint(equalTo: scoreStack.heightAnchor, multiplier: 1).isActive = true
            teamALabel.widthAnchor.constraint(equalTo: scoreStack.widthAnchor, multiplier: 0.2).isActive = true
            
            teamAScoreLabel.heightAnchor.constraint(equalTo: scoreStack.heightAnchor, multiplier: 1).isActive = true
            teamAScoreLabel.widthAnchor.constraint(equalTo: scoreStack.widthAnchor, multiplier: 0.2).isActive = true
            
            hihunLabel.heightAnchor.constraint(equalTo: scoreStack.heightAnchor, multiplier: 1).isActive = true
            hihunLabel.widthAnchor.constraint(equalTo: scoreStack.widthAnchor, multiplier: 0.2).isActive = true
            
            teamBScoreLabel.heightAnchor.constraint(equalTo: scoreStack.heightAnchor, multiplier: 1).isActive = true
            teamBScoreLabel.widthAnchor.constraint(equalTo: scoreStack.widthAnchor, multiplier: 0.2).isActive = true
            
            teamBLabel.heightAnchor.constraint(equalTo: scoreStack.heightAnchor, multiplier: 1).isActive = true
            teamBLabel.widthAnchor.constraint(equalTo: scoreStack.widthAnchor, multiplier: 0.2).isActive = true
            
            gameStack.addArrangedSubview(gameTitleStack)
            gameStack.addArrangedSubview(scoreStack)
            
            gameTitleStack.heightAnchor.constraint(equalTo: gameStack.heightAnchor, multiplier: 0.5).isActive = true
            
            lineStack?.addArrangedSubview(gameStack)
            
            gameStack.widthAnchor.constraint(equalTo: lineStack.widthAnchor, multiplier: 0.5).isActive = true
            gameStack.heightAnchor.constraint(equalTo: lineStack.heightAnchor, multiplier: 1).isActive = true
            
        }
        
    }
    
    @IBAction func onClickMenuButton(_ sender: Any) {
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch: UITouch in touches {
                performSegue(withIdentifier: "menuSegue", sender: nil)
            }
        }
    
    func getGameForPK(gameId: String) -> Game {
        
        var game:Game = Game()
       
        let realm: Realm
        do {
            realm = try Realm()
            // 条件として、nameが"yamada"のデータを検索し、ageの降順で並び替えます。
            game = realm.object(ofType: Game.self, forPrimaryKey: gameId)!
            
        } catch {
            // 必要に応じて、エラー処理を行います。
            
        }
        return game
    }
    
    func getTeamForPK(teamId: String) -> Team {
        
        var team = Team()
        let realm: Realm
        do {
            realm = try Realm()
            // 条件として、nameが"yamada"のデータを検索し、ageの降順で並び替えます。
            team = realm.object(ofType: Team.self, forPrimaryKey: teamId)!
            
        } catch {
            // 必要に応じて、エラー処理を行います。
        }
        return team
    }
    
    func deleteGame(game: Game) {
        GameModel.dao.delete(d: game)
    }
    
    func deleteTeam(team: List<Team>) {
        for t in team {
            TeamModel.dao.delete(d: t)
        }
    }
    
    func deletePlayers(players: List<Player>) {
        for p in players {
            PlayerModel.dao.delete(d: p)
        }
    }
}
