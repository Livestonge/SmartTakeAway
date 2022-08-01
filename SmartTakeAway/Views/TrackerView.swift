//
//  TrackerView.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 10/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class TrackerView: UIView{
    
    private let timerLabel = UILabel()
    private let backgroundLayer = CAShapeLayer()
    private let foregroundLayer = CAShapeLayer()
    
    private lazy var formatter: DateComponentsFormatter = {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .positional
        dateComponentFormatter.includesTimeRemainingPhrase = true
        dateComponentFormatter.allowedUnits = [.minute, .second]
        return dateComponentFormatter
    }()
    
    private lazy var orderFinishedText: NSAttributedString = {
        
        let customFont = UIFont(name: "Helvetica Neue", size: 20)
        let text = "Your order is ready Bon appettit"
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font: customFont!])
        let color = UIColor.orange
        attributedString.addAttributes([.foregroundColor: color],
                                        range: NSRange(location: 20, length: 12))
        return attributedString
    }()
    
    private var outputString = ""
    
    // Countdouwn starts from 2 minutes
    private var seconds: TimeInterval = 120 {
        didSet{
            timerLabel.text = outputString
            foregroundLayer.strokeStart = CGFloat(seconds/120)
        }
    }
    
    override var isHidden: Bool{
        
        didSet{
            
            if !isHidden{
                _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ [weak self] myTimer in
                        guard let self = self else {return}
                               self.outputString = self.formatter.string(from: self.seconds)!
                               self.seconds -= 1
                               if self.seconds == 0{
                                   myTimer.invalidate()
                                   self.timerLabel.attributedText = self.orderFinishedText
                               } else if OrderBank.shared.isFoodListEmpty() {
                                   myTimer.invalidate()
                                   self.isHidden = true
                                   self.seconds = 120
                    }
                           }
            }
        }
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        addTimerLabelToView()
        buildLayers()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addTimerLabelToView()
        buildLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildLayers()
    }
    
    func addTimerLabelToView(){
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.numberOfLines = 2
        timerLabel.textAlignment = .center
        timerLabel.text = "Timer"
        addSubview(timerLabel)
        let timerWidth = timerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        let timerHeight = timerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4)
        let timerCenterX = timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        let timerCenterY = timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate([timerWidth,timerHeight,timerCenterX,timerCenterY])
    }
    
    func buildLayers(){
        
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                radius: bounds.width*0.4,
                                startAngle: .pi/2.8,
                                endAngle: .pi * 0.65,
                                clockwise: false)
        backgroundLayer.path = path.cgPath
        backgroundLayer.bounds = path.bounds
        layer.addSublayer(backgroundLayer)
        backgroundLayer.strokeColor = UIColor.systemBlue.cgColor
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = 12.0
        backgroundLayer.lineCap = .round
        backgroundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        foregroundLayer.path = path.cgPath
        foregroundLayer.bounds = path.bounds
        foregroundLayer.fillColor = nil
        foregroundLayer.strokeColor = UIColor.orange.cgColor
        foregroundLayer.lineWidth = backgroundLayer.lineWidth
        foregroundLayer.lineCap = backgroundLayer.lineCap
        foregroundLayer.strokeStart = 1.0
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.duration = 1.0
        foregroundLayer.add(animation, forKey: "stroke")
        
        layer.insertSublayer(foregroundLayer, above: backgroundLayer)
        foregroundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
    }
    
    
}
