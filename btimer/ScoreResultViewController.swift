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
    
    var totalScoreA:String = ""
    var totalScoreB:String = ""
    
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
}

