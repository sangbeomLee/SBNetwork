//
//  SBIndicatorView.swift
//  FBSnapshotTestCase
//
//  Created by 이상범 on 2020/08/19.
//

import Foundation

public class SBIndicatorView: UIActivityIndicatorView {
    init(width: CGFloat, height: CGFloat, style: UIActivityIndicatorView.Style = .white) {
        super.init(style: style)
        
        setup(centerX: width/2, centerY: height/2)
        self.style = style
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(centerX: CGFloat, centerY: CGFloat) {
        sizeToFit()
        color = .gray
        hidesWhenStopped = true
        center = CGPoint(x: centerX, y: centerY)
    }
}
