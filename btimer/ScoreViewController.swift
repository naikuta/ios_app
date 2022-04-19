//
//  SampleViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/15.
//

import UIKit

protocol ScoreModalViewControllerProtocol {
    func scoreModalDidFinished(team:String, sd:[[Int]])
}

class ScoreViewController: UIViewController {
    
    var delegate:ScoreModalViewControllerProtocol?
    
    @IBOutlet weak var scoreStack: UIStackView!
    
    @IBOutlet weak var scoreTitleStack: UIStackView!
    
    //@IBOutlet weak var scoreTable: UITableView!
    
    var scoreData:[[Int]] = []
    var selectTeam: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        makeView()
    }
    
    func makeView() {

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
  
        for h in 0..<6 {
            
            let label:UILabel = UILabel()
            label.layer.borderWidth = 0.5
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
            scoreTitleStack.addArrangedSubview(label)
            
            if h == 0  {
                label.widthAnchor.constraint(equalTo: scoreTitleStack.widthAnchor, multiplier: 0.2).isActive = true
            } else {
                label.widthAnchor.constraint(equalTo: scoreTitleStack.widthAnchor, multiplier: 0.16).isActive = true
            }
        }
        
        for i in 0 ..< 10 {
            let scoreView = UIStackView()
            scoreView.axis = .horizontal
            scoreView.distribution = .fillEqually
            //scoreView.addBorder(width: 0.5, color: UIColor.black, position: //.bottom)
            scoreView.backgroundColor = UIColor.gray
            
            for j in 0..<6 {

                //playerLabel.textAlignment = .center
                //playerLabel.text = "PLAYER"
                //playerLabel.backgroundColor = UIColor(red: 0, green: 0, blue: //10, alpha: 1.0)
                
                if j == 0 {
                    let playerLabel:PlayerLabel = PlayerLabel()
                    playerLabel.PlayerLabel(i: i)
                    
                    scoreView.addArrangedSubview(playerLabel)
                    
                    playerLabel.heightAnchor.constraint(equalTo: scoreView.heightAnchor, multiplier: 1).isActive = true
                    playerLabel.widthAnchor.constraint(equalTo: scoreView.widthAnchor, multiplier: 0.2).isActive = true
                } else {
                    let scoringView: UIStackView = UIStackView()
                    scoringView.axis = .vertical
                    scoringView.layer.borderWidth = 0.5
                    scoringView.layer.borderColor = UIColor.black.cgColor
                    //scoringView.backgroundColor = UIColor(red: 0, green: 0, blue: //10, alpha: 1.0)
                    
                    let scoreLabel:UILabel = UILabel()
                    scoreLabel.setTextConvert(score: scoreData[i][j-1])
                    scoreLabel.textAlignment = .center
                    
                    let buttonView:UIStackView = UIStackView()
                    buttonView.axis = .horizontal
                    buttonView.distribution = .fillEqually
                    
                    let view: UIView = UIView()
                    let view2: UIView = UIView()
                    
                    view.backgroundColor = UIColor(red: 0, green: 10, blue: 10, alpha: 1.0)
                    
                    let image1:UIImage = UIImage(named:"plus.circle.fill")!
                    let imageView = Gesture(image:image1)
                    
                    let image2:UIImage = UIImage(named:"minus.circle.fill")!
                    let image2View = Gesture(image:image2)
                    
                    imageView.tag = Int(String(j) + String(i))!
                    
                    // 画像の縦横サイズを取得
                    let imgWidth:CGFloat = image1.size.width
                    let imgHeight:CGFloat = image1.size.height
                    let a = scoreView.layer.bounds.width
                    let viewWidth = scoreView.layer.bounds.width / 6
                    //let viewWidth = buttonView.layer.bounds.width
                    
                    // 画像サイズをスクリーン幅に合わせる
                    let scale:CGFloat = viewWidth / imgWidth
                    let rect:CGRect =
                        //CGRect(x:0, y:0, width:imgWidth*scale, //height:imgHeight*scale)
                    CGRect(x:0, y:0, width:imgWidth, height:imgHeight)
                    // ImageView frame をCGRectで作った矩形に合わせる
                    imageView.frame = rect;
                    image2View.frame = rect;
                    
                    view.addSubview(imageView)
                    view2.addSubview(image2View)
                    
                    /*
                    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
                    imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
                    image2View.heightAnchor.constraint(equalTo: view2.heightAnchor, multiplier: 0.7).isActive = true
                    image2View.widthAnchor.constraint(equalTo: view2.widthAnchor, multiplier: 0.7).isActive = true
                    */
                    // タップジェスチャーの設定
                    imageView.isUserInteractionEnabled = true
                    
                    /*
                    let ges = UITapGestureRecognizer(
                        target: self,
                        action: #selector(gestureTap(sender:)))
                    imageView.addGestureRecognizer(ges)
                    */
                    
                    imageView.singleTap { (g) in
                        if UIGestureRecognizer.State.ended == g.state {
                            var point:Int = Int(scoreLabel.text ?? "00")!
                            point += 1
                            scoreLabel.text = NSString(format: "%02d", point) as String
                            
                            self.scoreData[i][1] = point
                        }
                    }
       
                    image2View.singleTap { (g) in
                        if UIGestureRecognizer.State.ended == g.state {
                            
                            if scoreLabel.text == "00" {
                                return
                            }
                            
                            var point:Int = Int(scoreLabel.text ?? "00")!
                            point -= 1
                            scoreLabel.text = NSString(format: "%02d", point) as String
                        
                            self.scoreData[i][1] = point
                        }
                    }
                    
                    buttonView.addArrangedSubview(view)
                    buttonView.addArrangedSubview(view2)
                    
                    scoringView.addArrangedSubview(scoreLabel)
                    scoringView.addArrangedSubview(buttonView)
                    
                    scoreView.addArrangedSubview(scoringView)
                    scoringView.heightAnchor.constraint(equalTo: scoreView.heightAnchor, multiplier: 1).isActive = true
                    scoringView.widthAnchor.constraint(equalTo: scoreView.widthAnchor, multiplier: 0.16).isActive = true
                    
                    scoreLabel.heightAnchor.constraint(equalTo: scoringView.heightAnchor, multiplier: 0.7).isActive = true
                }
            }
            scoreStack.addArrangedSubview(scoreView)
            scoreView.heightAnchor.constraint(equalTo: scoreStack.heightAnchor, multiplier: 0.1).isActive = true
            scoreView.widthAnchor.constraint(equalTo: scoreStack.widthAnchor, multiplier: 1).isActive = true
        }
    }
    
    @IBAction func onCloseModal(_ sender: Any) {
        let a = scoreData
        self.delegate?.scoreModalDidFinished(team:selectTeam, sd:self.scoreData)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func gestureTap(sender: UITapGestureRecognizer) {
        let t = sender.view?.tag
    }
}

