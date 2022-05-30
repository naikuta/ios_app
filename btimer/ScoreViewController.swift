//
//  SampleViewController.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/15.
//

import UIKit

protocol ScoreModalViewControllerProtocol {
    func scoreModalDidFinished(team:String, sd:Array<Player>)
}

class ScoreViewController: UIViewController {
    
    var delegate:ScoreModalViewControllerProtocol?
    
    @IBOutlet weak var scoreStack: UIStackView!
    
    @IBOutlet weak var scoreTitleStack: UIStackView!
    
    var scoreData:[[Int]] = []
    var selectTeam: String = ""
    
    var players:Array<Player> = []
    
    var imageStackWidth = UIScreen.main.bounds.width * 0.7 * 0.16 * 0.5
    
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
            label.layer.borderColor = UIColor.gray.cgColor
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
            
            for j in 0..<6 {
                
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
                    scoringView.layer.borderColor = UIColor.gray.cgColor
                    
                    let scoreLabel:UILabel = UILabel()
                    //scoreLabel.setTextConvert(score: scoreData[i][j-1])
                    scoreLabel.setScore(p: players[i], prop: j)
                    scoreLabel.textAlignment = .center
                    scoreLabel.textColor = UIColor.white
                    scoreLabel.backgroundColor = UIColor.black
                    
                    let buttonView:UIStackView = UIStackView()
                    buttonView.axis = .horizontal
                    buttonView.distribution = .fillEqually
                    
                    let view: UIView = UIView()
                    let view2: UIView = UIView()
                    
                    view.backgroundColor = UIColor.black
                    view2.backgroundColor = UIColor.black
                    
                    let a = view.frame.width
                    let b = view.frame.height
                    
                    let image1:UIImage = UIImage(named:"plus.circle.fill")!
                    let imageView = Gesture(image:image1)
                    
                    let image2:UIImage = UIImage(named:"minus.circle.fill")!
                    let image2View = Gesture(image:image2)
                    
                    imageView.tag = Int(String(j) + String(i))!
                    
                    // 画像の縦横サイズを取得
                    let imgWidth:CGFloat = image1.size.width
                    let imgHeight:CGFloat = image1.size.height
                    let viewWidth = scoreView.layer.bounds.width / 6
                    //let viewWidth = buttonView.layer.bounds.width
                    
                    let expImageHeigth = imgHeight * ((imageStackWidth * 0.3) / imgWidth)
                    
                    let c = imageStackWidth
                    // 画像サイズをスクリーン幅に合わせる
                    let scale:CGFloat = viewWidth / imgWidth
                    let rect:CGRect =
                        //CGRect(x:0, y:0, width:imgWidth*scale, //height:imgHeight*scale)
                        CGRect(x:imageStackWidth * 0.3, y:0, width:imageStackWidth * 0.3, height:expImageHeigth)
                    // ImageView frame をCGRectで作った矩形に合わせる
                    imageView.frame = rect;
                    image2View.frame = rect;
                    
                    view.addSubview(imageView)
                    view2.addSubview(image2View)
                    
                    // タップジェスチャーの設定
                    imageView.isUserInteractionEnabled = true
                    image2View.isUserInteractionEnabled = true
                    
                    imageView.singleTap { (g) in
                        if UIGestureRecognizer.State.ended == g.state {
                            var point:Int = Int(scoreLabel.text ?? "0")!
                            point += 1
                            scoreLabel.text = String(point)
                            
                            //self.scoreData[i][1] = point
                            
                            switch j {
                            case 1:
                                self.players[i].sh = point
                            case 2:
                                self.players[i].p = point
                            case 3:
                                self.players[i].r = point
                            case 4:
                                self.players[i].a = point
                            case 5:
                                self.players[i].s = point
                            default:
                                break
                            }
                        }
                    }
       
                    image2View.singleTap { (g) in
                        if UIGestureRecognizer.State.ended == g.state {
                            
                            if scoreLabel.text == "0" {
                                return
                            }
                            
                            var point:Int = Int(scoreLabel.text ?? "0")!
                            point -= 1
                            scoreLabel.text = String(point)
                        
                            switch j {
                            case 1:
                                self.players[i].sh = point
                            case 2:
                                self.players[i].p = point
                            case 3:
                                self.players[i].r = point
                            case 4:
                                self.players[i].a = point
                            case 5:
                                self.players[i].s = point
                            default:
                                break
                            }
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

        self.delegate?.scoreModalDidFinished(team:selectTeam, sd:self.players)
        
        dismiss(animated: true, completion: nil)
    }
    
}

