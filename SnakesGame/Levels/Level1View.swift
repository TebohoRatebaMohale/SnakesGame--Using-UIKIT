//
//  Level1View.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/05/09.
//

import UIKit

protocol Level: UIView {
    
    var boundaries: [UIView] { get }
}

class Level1View: UIView, Level {
    var boundaries: [UIView] = []
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var boundary1: UIView!
    
    @IBOutlet weak var boundary2: UIView!
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initSubviews()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            initSubviews()
        }

        func initSubviews() {
          
            let nib = UINib(nibName: "Level1View", bundle: nil)
            nib.instantiate(withOwner: self, options: nil)
            contentView.frame = bounds
            contentView.isUserInteractionEnabled = false
            addSubview(contentView)
            for view in contentView.subviews {
                boundaries.append(view)
            }
        }
}


