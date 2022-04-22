//
//  ViewController.swift
//  TestApp1
//
//  Created by iku on 2022/02/08.
//

import UIKit

class ViewController: UIViewController, TimerModalViewControllerProtocol, ScoreModalViewControllerProtocol {
    
    @IBOutlet weak var timerMinLeft: UIImageView!
    @IBOutlet weak var timerMinRight: UIImageView!
    @IBOutlet weak var timerSecLeft: UIImageView!
    @IBOutlet weak var timerSecRight: UIImageView!
    @IBOutlet weak var timerMSecLeft: UIImageView!
    @IBOutlet weak var timerMSecRight: UIImageView!
    
    @IBOutlet weak var hScoreHundreds: UIImageView!
    @IBOutlet weak var hScoreTenth: UIImageView!
    @IBOutlet weak var hScoreFirst: UIImageView!
    @IBOutlet weak var aScoreHundreds: UIImageView!
    @IBOutlet weak var aScoreTenth: UIImageView!
    @IBOutlet weak var aScoreFirst: UIImageView!
    
    weak var timer: Timer!
    var startTime = Date()

    let scoreModalView = ScoreViewController()
    
    var selectedTeam:String = ""
    
    var scoreH:[[Int]] = [[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]]
    
    var scoreA:[[Int]] = [[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]
                          ,[0, 0, 0, 0, 0]]
    
    var setMin: Double = 0
    var setSec: Double = 0
    var setMSec: Double = 0
    var currentTime: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoreModalView.delegate = self
        // UIImage インスタンスの生成
        let imageZero:UIImage = UIImage(named:"zero")!
        timerMinLeft.image = imageZero
        timerMinRight.image = imageZero
        timerSecLeft.image = imageZero
        timerSecRight.image = imageZero
        timerMSecLeft.image = imageZero
        timerMSecRight.image = imageZero
        
        /*
        let imageZeroGreen:UIImage = UIImage(named:"zero_green")!
        hScoreHundreds.image = imageZeroGreen
        hScoreTenth.image = imageZeroGreen
        hScoreFirst.image = imageZeroGreen
        */
        /*
        let imageZeroYellow:UIImage = UIImage(named:"zero_yellow")!
        aScoreHundreds.image = imageZeroYellow
        aScoreTenth.image = imageZeroYellow
        aScoreFirst.image = imageZeroYellow
        */
        
        setScoreImageH()
        setScoreImageA()
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        //次の画面を変数化する
        if segue.destination is TimerModalViewController {
            
            let timerVC = segue.destination as! TimerModalViewController
            timerVC.delegate = self
        
        } else if segue.destination is ScoreViewController {
            
            let scoreVC = segue.destination as! ScoreViewController
            scoreVC.delegate = self
            
            if selectedTeam == "H" {
                scoreVC.scoreData = scoreH
                scoreVC.selectTeam = "H"
            } else if selectedTeam == "A" {
                scoreVC.scoreData = scoreA
                scoreVC.selectTeam = "A"
            }
            
        } else if segue.destination is ScoreResultViewController {
            
            let scoreResultVC = segue.destination as! ScoreResultViewController

            let scoreData = addTwoDimensionaryArray(before: scoreH, affter: scoreA)
            
            scoreResultVC.scoreArray = scoreData
            
            scoreResultVC.scoreDataH = scoreH
            scoreResultVC.scoreDataA = scoreA
        }
    }
    
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func modalbutton(_ sender: Any) {
        performSegue(withIdentifier: "ModalSeque", sender: nil)
        
        /*let modalVC = storyboard?.instantiateViewController(identifier: "ModalView")

        self.present(modalVC!, animated: true, completion: nil)*/
    }
    
    @IBAction func onTimerStop(_ sender: Any) {
        
        timer.invalidate()
        
        //let intervalTime = (setMin + setSec + setMSec) - currentTime
        let a = currentTime
        setMin = Double((Int)((currentTime / 60)) * 60)
        setSec = fmod(currentTime, 60)
        let b = setMin
        setMSec =  currentTime - floor(currentTime)
        
    }
    
    @IBAction func TimerStart(_ sender: Any) {
        
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
        
        startTime = Date()
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let intervalTime = Date().timeIntervalSince(startTime)
        // fmod() 余りを計算
        //let minute = 2 - (Int)(fmod((currentTime/60), 60))
        let a = intervalTime/60
        let b = setMin - a
        //let minute = (Int)((setMin - (currentTime/60))/60)
        let e = setSec
        let f = setMSec
        let setTime = setMin + setSec + setMSec
        let minute = (Int)((setTime - intervalTime)/60)
        
        // currentTime/60 の余り
        //let second = setSec - (Int)(fmod(currentTime, 60))
        let second = (Int)(fmod(setTime - intervalTime, 60))
        
        // floor 切り捨て、小数点以下を取り出して *100
        //let msec = 100 - (Int)((currentTime - floor(currentTime))*100)
        let d = (Double)(setTime)
        let intervalMSec = (Double)(setTime) - intervalTime
        let c = floor(intervalMSec)
        let msec = (Int)((intervalMSec - floor(intervalMSec)) * 100)
        
        currentTime = setTime - intervalTime
        
        timerMinLeft.image = intToImage(num: minute, use: "T")[1]
        timerMinRight.image = intToImage(num: minute, use: "T")[2]
        timerSecLeft.image = intToImage(num: second, use: "T")[1]
        timerSecRight.image = intToImage(num: second, use: "T")[2]
        timerMSecLeft.image = intToImage(num: msec, use: "T")[1]
        timerMSecRight.image = intToImage(num: msec, use: "T")[2]
        
        if minute <= 0 && second <= 0 && msec <= 0 {
            timer.invalidate()
            return
        }
    }
    
    @IBAction func OnTimerSetButton(_ sender: Any) {
        performSegue(withIdentifier: "TimerModalSeque", sender: nil)
    }
    
    /*
     タイマーセットモーダル 閉じる際に呼ばれる
     */
    func setTimer(s: String) {
        
        let sArray = s.split(separator: "-")
        
        let min = sArray[0]
        let sec = sArray[1]
        let msec = sArray[2]
        
        let minImage = intToImage(num: Int(min)!, use: "T")
        let secImage = intToImage(num: Int(sec)!, use: "T")
        let msecImage = intToImage(num: Int(msec)!, use: "T")
        
        timerMinLeft.image = minImage[1]
        timerMinRight.image = minImage[2]
        timerSecLeft.image = secImage[1]
        timerSecRight.image = secImage[2]
        timerMSecLeft.image = msecImage[1]
        timerMSecRight.image = msecImage[2]
        
        let a = Double(min)! * 60
        setMin = Double(min)! * 60
        setSec = Double(sec)!
        setMSec = Double(msec)! / 100
    }
    
    @IBAction func onHomeButton(_ sender: Any) {
        
        selectedTeam = "H"
        
        performSegue(withIdentifier: "scoreModalSegue", sender: nil)
    }
    
    @IBAction func onAwayButton(_ sender: Any) {
        
        selectedTeam = "A"
        
        performSegue(withIdentifier: "scoreModalSegue", sender: nil)
    }    
    
    @IBAction func onMenuButton(_ sender: Any) {
        performSegue(withIdentifier: "mainSegue", sender: nil)
    }
    
    /*
     スコアモーダル 閉じた際に呼ばれる
     */
    func scoreModalDidFinished(team:String, sd:[[Int]]){

        if team == "H" {
            
            scoreH = sd
            
            setScoreImageH()
            
        } else if team == "A" {

            scoreA = sd
            
            setScoreImageA()
        }
    }
    
    func addTwoDimensionaryArray(before:[[Int]], affter:[[Int]]) -> [[Int]] {
        
        let bArray = before
        let aArray = affter
        
        var totalArray:[[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 5), count:20)
        
        for i in 0..<aArray.count {
            for j in 0..<aArray[i].count {
                //totalArray[totalArray.count].append(aArray[i][j])
                totalArray[i][j] = aArray[i][j]
            }
        }
        
        var bCount: Int = 0
        var aCount: Int = 0
        
        for i in aArray.count..<(aArray.count + bArray.count) {
            for j in 0..<bArray[bCount].count {
                //totalArray[totalArray.count].append(bArray[i][j])
                totalArray[i][j] = bArray[aCount][j]
            }
            bCount = bCount + 1
            aCount = aCount + 1
        }
        return totalArray
    }
    
    func intToImage(num: Int, use: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        var leftImage: UIImage!
        var middleImage: UIImage!
        var rightImage: UIImage!
        
        var from: String.Index!
        var to: String.Index!
        var newString: String!
        var named: String!
        
        let text = String(format:"%03d", num)

        for k in 0...2 {
            
            if k == 0 {
                from = text.index(text.startIndex, offsetBy:0)
                to = text.index(text.startIndex, offsetBy:1)
                newString = String(text[from..<to])
            } else if k == 1 {
                from = text.index(text.startIndex, offsetBy:1)
                to = text.index(text.startIndex, offsetBy:1)
                newString = String(text[from...to])
            } else if k == 2 {
                from = text.index(text.startIndex, offsetBy:2)
                to = text.index(text.startIndex, offsetBy:2)
                newString = String(text[from...to])
            }
            
            switch newString {
            case "0":
                named = "zero"
            case "1":
                named = "one"
            case "2":
                named = "two"
            case "3":
                named = "three"
            case "4":
                named = "four"
            case "5":
                named = "five"
            case "6":
                named = "six"
            case "7":
                named = "seven"
            case "8":
                named = "eight"
            case "9":
                named = "nine"
            default:
                named = ""
            }
            
            if use == "H" {
                named = named + "_green"
            } else if use == "A" {
                named = named + "_yellow"
            }
            
            if k == 0 {
                leftImage = UIImage(named: named)
                imageArray.append(leftImage)
            } else if k == 1 {
                middleImage = UIImage(named: named)
                imageArray.append(middleImage)
            } else if k == 2 {
                rightImage = UIImage(named: named)
                imageArray.append(rightImage)
            }
        }
        return imageArray
    }
    
    func setScoreImageH() {
        
        var total:Int = 0
        
        for i in 0...9 {
            let point = scoreH[i][1]
            total += point
        }
        
        let hScoreImage = intToImage(num: total, use: "H")
        hScoreHundreds.image = hScoreImage[0]
        hScoreTenth.image = hScoreImage[1]
        hScoreFirst.image = hScoreImage[2]
    }
    
    func setScoreImageA() {
        
        var total:Int = 0
        
        for i in 0..<9 {
            let point = scoreA[i][1]
            total += point
        }
        
        let aScoreImage = intToImage(num: total, use: "A")
        aScoreHundreds.image = aScoreImage[0]
        aScoreTenth.image = aScoreImage[1]
        aScoreFirst.image = aScoreImage[2]
    }
}

