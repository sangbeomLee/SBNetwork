//
//  SBIndicatorView.swift
//  FBSnapshotTestCase
//
//  Created by 이상범 on 2020/08/19.
//

import Foundation

public class SBIndicatorView: UIActivityIndicatorView {
    private func configure() {
        self.sizeToFit()
        self.color = .gray
        self.hidesWhenStopped = true
    }
    
    init(width: CGFloat, height: CGFloat, style: UIActivityIndicatorView.Style = .white) {
        super.init(style: style)
        configure()
        self.center = CGPoint(x: width/2, y: height/2)
        self.style = style
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
