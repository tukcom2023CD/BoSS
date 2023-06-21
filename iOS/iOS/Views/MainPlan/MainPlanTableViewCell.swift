//
//  MainPlanTableViewCell.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit
import Lottie

class MainPlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextArrowView: UIView!
    
    @IBOutlet weak var verticalLine: UIView!
    
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var totalSpending: UILabel!
    var animationView: LottieAnimationView?
    var nextanimationView: LottieAnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDownLine()
        setNextArraw()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDownLine() {
        // 기존의 animationView 제거
        animationView?.removeFromSuperview()
        // 새로운 animationView 생성 및 설정
        let newAnimationView = LottieAnimationView(name: "scrollDown")
        newAnimationView.frame = verticalLine.bounds
        newAnimationView.contentMode = .scaleAspectFit
        newAnimationView.loopMode = .loop
        verticalLine.addSubview(newAnimationView)
        newAnimationView.play()
        
        // animationView 업데이트
        animationView = newAnimationView
    }
    func setNextArraw() {
        // 기존의 animationView 제거
        nextanimationView?.removeFromSuperview()
        // 새로운 animationView 생성 및 설정
        let newAnimationView = LottieAnimationView(name: "right-arrow")
        newAnimationView.frame = nextArrowView.bounds
        newAnimationView.contentMode = .scaleAspectFit
        newAnimationView.loopMode = .loop
        nextArrowView.addSubview(newAnimationView)
        newAnimationView.play()
        
        // animationView 업데이트
        nextanimationView = newAnimationView
    }
    
}
