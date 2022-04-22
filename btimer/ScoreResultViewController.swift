//
//  ScoreResultViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/24.
//

import UIKit
import RealmSwift

class ScoreResultViewController: UIViewController {
    
    var scoreArray:[[Int]] = []
    
    var scoreDataH:[[Int]] = []
    var scoreDataA:[[Int]] = []
    
    var totalScoreA:String = ""
    var totalScoreB:String = ""
    
    
    @IBOutlet weak var hScoreStack: UIStackView!
    @IBOutlet weak var aScoreTitleStack: UIStackView!
    
    @IBOutlet weak var hStack: UIStackView!
    @IBOutlet weak var aStack: UIStackView!
    
    // モデルクラスを使用し、取得データを格納する変数を作成
    var tableCells: Results<Player>!
    var teamTableCells: Results<Team>!
    
    let alert: UIAlertController = UIAlertController(title: "register game result?", message:  "", preferredStyle:  UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmインスタンス取得
        let realm = try! Realm()
        // データ全件取得
        self.tableCells = realm.objects(Player.self)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            
            self.registPlayerScore(scoreData: self.scoreDataH)
            self.registPlayerScore(scoreData: self.scoreDataA)
            
            /*
            for i in 0...18 {
                // モデルクラスのインスタンスを取得
                let ScoreInstance:Player = Player()
                // Realmインスタンス取得
                let realm = try! Realm()
                
                for j in 0...5 {
                    
                    switch j {
                    
                    case 0:
                        ScoreInstance.team = self.createTeamId()
                    case 1:
                        ScoreInstance.player = "p" + String(i + 1)
                    case 2:
                        ScoreInstance.sh = self.scoreArray[i][j]
                    case 3:
                        ScoreInstance.p = self.scoreArray[i][j]
                    case 4:
                        ScoreInstance.a = self.scoreArray[i][j]
                    case 5:
                        ScoreInstance.r = self.scoreArray[i][j]
                    case 6:
                        ScoreInstance.s = self.scoreArray[i][j]
                    default:
                        break
                    }
                }
                // DB登録処理
                try! realm.write {
                    realm.add(ScoreInstance)
                }
            }
            */
            print("確定")
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
        
        makeView()
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
    
        if segue.destination is ViewController {
            let vc = segue.destination as! ViewController
            
            vc.scoreH = scoreDataH
            vc.scoreA = scoreDataA
        }
    }
    
    
    @IBAction func onReturn(_ sender: Any) {
        performSegue(withIdentifier: "mainSegue", sender: nil)
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
        
        makeScoreStack(stack: hStack, scoreData: scoreDataH)
        
        makeScoreStack(stack: aStack, scoreData: scoreDataA)
    }
    
    func makeTitleStack(titleStack: UIStackView) {
        
        for h in 0..<6 {
            
            let label:UILabel = UILabel()
            label.layer.borderWidth = 0.4
            label.layer.borderColor = UIColor.black.cgColor
            label.textAlignment = .center
            
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
                label.widthAnchor.constraint(equalTo: titleStack.widthAnchor, multiplier: 0.2).isActive = true
            } else {
                label.widthAnchor.constraint(equalTo: titleStack.widthAnchor, multiplier: 0.15).isActive = true
            }
        }
    }
    
    func makeScoreStack(stack: UIStackView, scoreData: [[Int]]) {
        
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
                    scoreLabel.setTextConvert(score: scoreData[i][j-1])
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
    
    func registPlayerScore(scoreData: [[Int]]) {
        
        for i in 0..<scoreData.count {
            // モデルクラスのインスタンスを取得
            let ScoreInstance:Player = Player()
            // Realmインスタンス取得
            let realm = try! Realm()
            
            for j in 0..<scoreData[i].count {
                
                switch j {
                
                case 0:
                    ScoreInstance.team = self.createTeamId()
                case 1:
                    ScoreInstance.player = "p" + String(i + 1)
                case 2:
                    ScoreInstance.sh = self.scoreArray[i][j]
                case 3:
                    ScoreInstance.p = self.scoreArray[i][j]
                case 4:
                    ScoreInstance.a = self.scoreArray[i][j]
                case 5:
                    ScoreInstance.r = self.scoreArray[i][j]
                case 6:
                    ScoreInstance.s = self.scoreArray[i][j]
                default:
                    break
                }
            }
            // DB登録処理
            try! realm.write {
                realm.add(ScoreInstance)
            }
        }
    }
}

