//
//  SubTableViewCell.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/16.
//

import UIKit

class SubTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreView.axis = .horizontal
        scoreView.distribution = .fillEqually
        scoreView.addBorder(width: 0.5, color: UIColor.black, position: .bottom)
        
        for i in 0..<5 {
        
            let playerLabel:UILabel = UILabel()
            playerLabel.textAlignment = .center
            playerLabel.text = "PLAYER"
            playerLabel.backgroundColor = UIColor(red: 0, green: 10, blue: 10, alpha: 1.0)
            
            if i == 0 {
                scoreView.addArrangedSubview(playerLabel)
                
                playerLabel.heightAnchor.constraint(equalTo: scoreView.heightAnchor, multiplier: 1).isActive = true
            }
            
            let scoringView: UIStackView = UIStackView()

            scoringView.axis = .vertical
            scoringView.layer.borderWidth = 0.5
            scoringView.layer.borderColor = UIColor.black.cgColor
            scoringView.backgroundColor = UIColor(red: 0, green: 0, blue: 10, alpha: 1.0)
            
            let label:UILabel = UILabel()
            label.text = "00"
            
            let buttonView:UIStackView = UIStackView()
            buttonView.axis = .horizontal
            buttonView.distribution = .fillEqually
            
            let view: UIView = UIView()
            let view2: UIView = UIView()
            
            let image1:UIImage = UIImage(named:"plus.circle.fill")!
            let imageView = UIImageView(image:image1)
            
            let image2:UIImage = UIImage(named:"minus.circle.fill")!
            let image2View = UIImageView(image:image2)
            
            let aa = self.superview?.superview
            let tableView = superview?.superview as! UITableView
            imageView.tag = Int(String(self.tag) + String(i))!
            
            // 画像の縦横サイズを取得
            let imgWidth:CGFloat = image1.size.width
            let imgHeight:CGFloat = image1.size.height
            
            let viewWidth = scoreView.layer.bounds.width / 5
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
            
            // タップジェスチャーの設定
            imageView.isUserInteractionEnabled = true
            /*
            let ges = UITapGestureRecognizer(
                target: self,
                action: #selector(gestureTap(sender:)))
            imageView.addGestureRecognizer(ges)
            */
            buttonView.addArrangedSubview(view)
            buttonView.addArrangedSubview(view2)
            
            scoringView.addArrangedSubview(label)
            scoringView.addArrangedSubview(buttonView)
            
            scoreView.addArrangedSubview(scoringView)
            
            label.heightAnchor.constraint(equalTo: scoringView.heightAnchor, multiplier: 0.7).isActive = true
            /*
            scoringView.widthAnchor.constraint(equalTo: scoreView.widthAnchor, multiplier: 0.15).isActive = true
            */
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }


    
}
    
