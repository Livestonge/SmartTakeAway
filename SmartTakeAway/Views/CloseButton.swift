//
//  CloseButton.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 12/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import UIKit

// Custom close button.
class CloseButton: UIButton {
    // Propriety for customizing the foregroundColor.
    var crossColor: UIColor

    init(crossColor: UIColor) {
        self.crossColor = crossColor
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //  Drawing and coloring the cross lines.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()

        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.addLines(between: [CGPoint(x: bounds.width * 0.2, y: bounds.width * 0.8),
                                   CGPoint(x: bounds.width * 0.8, y: bounds.width * 0.2)])

        context.addLines(between: [CGPoint(x: bounds.width * 0.2, y: bounds.width * 0.2),
                                   CGPoint(x: bounds.width * 0.8, y: bounds.width * 0.8)])

        crossColor.setStroke()
        context.strokePath()
    }
}
