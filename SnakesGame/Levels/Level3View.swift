//
//  Level3View.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/05/15.
//

import UIKit

protocol Level3: UIView {
    
    var boundaries: [UIView] { get }
}

class Level3View: UIView, Level3 {
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
          
            let nib = UINib(nibName: "Level3View", bundle: nil)
            nib.instantiate(withOwner: self, options: nil)
            contentView.frame = bounds
            contentView.isUserInteractionEnabled = false
            addSubview(contentView)
            for view in contentView.subviews {
                boundaries.append(view)
            }
        }
}
