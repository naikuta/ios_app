//
//  ScoreResultViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/24.
//

import UIKit
import RealmSwift

class ScoreResultViewController: UIViewController {
    
    var scoreDataH:[[Int]] = []
    var scoreDataA:[[Int]] = []
    
    var totalScoreA:String = ""
    var totalScoreB:String = ""
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    @IBOutlet weak var hScoreStack: UIStackView!
    @IBOutlet weak var aScoreTitleStack: UIStackView!
    
    @IBOutlet weak var hStack: UIStackView!
    @IBOutlet weak var aStack: UIStackView!

    // モデルクラスを使用し、取得データを格納する変数を作成
    var teamTableCells: Results<Team>!
    
    var game: Game = Game()
    
    var playersH: Array<Player> = []
    var playersA: Array<Player> = []
    
    var teamH: Team = Team()
    var teamA: Team = Team()
    
    var teamScoreH = ""
    var teamScoreA = ""
    
    @IBOutlet weak var teamNameHLabel: UILabel!
    @IBOutlet weak var teamNameALabel: UILabel!
    
    @IBOutlet weak var teamScoreHLabel: UILabel!
    @IBOutlet weak var teamScoreALabel: UILabel!
    
    let alert: UIAlertController = UIAlertController(title: "register game result?", message:  "", preferredStyle:  UIAlertController.Style.alert)
    
    func initialize() {
        gameTitleLabel.text = game.gameTitle
        teamNameHLabel.text = teamH.teamName
        teamNameALabel.text = teamA.teamName
        teamScoreHLabel.text = teamScoreH
        teamScoreALabel.text = teamScoreA
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        initialize()
        
        makeView()
        
        // データ全件取得
        //self.tableCells = realm.objects(Player.self)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            
            if self.game.gameId == nil {
                
                self.createPlayer(players: self.playersH)
                self.createPlayer(players: self.playersA)
                
                let homeTeam = self.createTeam(players: self.playersH)
                let awayTeam = self.createTeam(players: self.playersA)
                
                let gameTitle = self.gameTitleLabel.text
                
                self.registGame(teams: [homeTeam, awayTeam], title: gameTitle!)
                
            } else {
                
                self.updatePlayer(players: self.playersH)
                self.updatePlayer(players: self.playersA)
                
                self.updateTeam(team: self.teamH)
                self.updateTeam(team: self.teamA)
                
                self.updateGame(game: self.game)
            }

            
            self.performSegue(withIdentifier: "gameResultSegue", sender: nil)
        })
        
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            print("キャンセル")
        })
        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
    
        if segue.destination is ViewController {
            let vc = segue.destination as! ViewController
            
            vc.playersH = playersH
            vc.playersA = playersA
        }
    }
    
    
    @IBAction func onReturn(_ sender: Any) {
        
        if game.gameId != nil {
            performSegue(withIdentifier: "gameResultSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "mainSegue", sender: nil)
        }
    }
    
    @IBAction func onRegistButton(_ sender: Any) {
        present(alert, animated: true, completion: nil)
    }
    
    
    func createTeamId() -> String {
        // Realmインスタンス取得
        let realm = try! Realm()
        // データ全件取得
        self.teamTableCells = realm.objects(Team.self)
        
        return "t" + String(self.teamTableCells.count + 1)
    }
    
    func makeView() {
        
        makeTitleStack(titleStack: hScoreStack)
        
        makeTitleStack(titleStack: aScoreTitleStack)
        
        makeScoreStack(stack: hStack, players: self.playersH)
        
        makeScoreStack(stack: aStack, players: self.playersA)

    }
    
    func makeTitleStack(titleStack: UIStackView) {
        
        for h in 0..<6 {
            
            let label:UILabel = UILabel()
            label.layer.borderWidth = 0.4
            label.layer.borderColor = UIColor.white.cgColor
            label.textAlignment = .center
            label.textColor = UIColor.white
            
            switch h {
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
            titleStack.addArrangedSubview(label)
            
            if h == 0  {
                label.widthAnchor.constraint(equalTo: titleStack.widthAnchor, multiplier: 0.25).isActive = true
            } else {
                label.widthAnchor.constraint(equalTo: titleStack.widthAnchor, multiplier: 0.15).isActive = true
            }
        }
    }
    
    func makeScoreStack(stack: UIStackView, players: [Player]) {
        
        for i in 0 ..< 10 {
            let scoreView = UIStackView()
            scoreView.axis = .horizontal
            scoreView.distribution = .fillEqually
            scoreView.backgroundColor = UIColor.white
            
            for j in 0..<6 {
                
                if j == 0 {
                    
                    let playerLabel:PlayerLabel = PlayerLabel()
                    playerLabel.PlayerLabel(i: i)
                    
                    scoreView.addArrangedSubview(playerLabel)
                    
                    playerLabel.heightAnchor.constraint(equalTo: scoreView.heightAnchor, multiplier: 1).isActive = true
                    playerLabel.widthAnchor.constraint(equalTo: scoreView.widthAnchor, multiplier: 0.25).isActive = true
                } else {
                    
                    let scoreLabel:UILabel = UILabel()
                    //scoreLabel.setTextConvert(score: scoreData[i][j-1])
                    scoreLabel.setScore(p: players[i], prop: j)
                    
                    scoreLabel.textAlignment = .center
                    scoreLabel.layer.borderWidth = 0.4
                    
                    scoreView.addArrangedSubview(scoreLabel)
                    
                    scoreLabel.heightAnchor.constraint(equalTo: scoreView.heightAnchor, multiplier: 1).isActive = true
                    scoreLabel.widthAnchor.constraint(equalTo: scoreView.widthAnchor, multiplier: 0.15).isActive = true
                }
            }
            stack.addArrangedSubview(scoreView)
            scoreView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.1).isActive = true
            scoreView.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        }
    }
    
    func createPlayer(scoreData: [[Int]]) -> [Player] {
        
        var players:[Player] = []
        let playerDao = PlayerModel.dao
        
        for i in 0..<scoreData.count {
            // モデルクラスのインスタンスを取得
            let player:Player = Player()
            
            player.playerId = playerDao.newId()!
            player.name = "p" + String(i + 1)
            
            for j in 0..<scoreData[i].count {
                
                switch j {
                
                case 0:
                    player.sh = scoreData[i][j]
                case 1:
                    player.p = scoreData[i][j]
                case 2:
                    player.a = scoreData[i][j]
                case 3:
                    player.r = scoreData[i][j]
                case 4:
                    player.s = scoreData[i][j]
                default:
                    break
                }
            }
            playerDao.add(d: player)
            players.append(player)
        }
        return players
    }
    
    func createPlayer(players: Array<Player>) {
        
        let playerDao = PlayerModel.dao
        
        for p in players {
            p.playerId = playerDao.newId()!
            playerDao.add(d: p)
        }
    }
    
    func createTeam(players: [Player]) -> Team {
        
        var teamName = ""
        let teamDao = TeamModel.dao
        let count = teamDao.findAll().count
        
        if count % 2 == 0 {
            teamName = "home" + String((count / 2) + 1)
        } else {
            teamName = "away" + String((count / 2) + 1)
        }
        
        let team:Team = Team()
        team.teamId = teamDao.newId()!
        team.teamName = teamName
        for p in players {
            team.playerList.append(p)
        }
        teamDao.add(d: team)
        return team
    }
    
    func registPlayerScore(players: [Player]) {
        
        for p in players {
            // Realmインスタンス取得
            let realm = try! Realm()
            // DB登録処理
            try! realm.write {
                realm.add(p)
            }
        }
    }
    
    func registTeam(team: Team, players: [Player]) {

        // Realmインスタンス取得
        let realm = try! Realm()
        try! realm.write {
            realm.add(team)
        }
        // Realmインスタンス取得
        let r = try! Realm()
        
        for p in players {
            try! r.write {
                team.playerList.append(p)
            }
        }
    }
    
    func registGame(teams: [Team], title: String) {
        
        let game: Game = Game()
        game.gameId = GameModel.dao.newId()!
        game.gameTitle = title
        
        // Realmインスタンス取得
        let realm = try! Realm()
        try! realm.write {
            realm.add(game)
        }
        // Realmインスタンス取得
        let r = try! Realm()
        
        for t in teams {
            try! r.write {
                game.teamList.append(t)
            }
        }
    }
    
    func updatePlayer(players: [Player])  {
        
        for p in players {
            PlayerModel.dao.update(d: p)
        }
    }

    func updateTeam(team: Team) {
        TeamModel.dao.update(d: team)
    }
    
    func  updateGame(game: Game) {
        GameModel.dao.update(d: game)
    }
}

