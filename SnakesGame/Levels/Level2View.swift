//
//  Level2View.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/05/15.
//

import UIKit
protocol Level2: UIView {
    
    var boundaries : [UIView] { get }
}

class Level2View: UIView, Level2{
    var boundaries: [UIView] = []
    
    @IBOutlet var contentView2: UIView!
    @IBOutlet weak var boundary3: UIView!
    
    @IBOutlet var boundary4: UIView!
    @IBOutlet weak var boundary5: UIView!
    
    @IBOutlet weak var boundary6: UIView!
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initSubviews()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            initSubviews()
        }

        func initSubviews() {
          
            let nib = UINib(nibName: "Level2View", bundle: nil)
            nib.instantiate(withOwner: self, options: nil)
            contentView2.frame = bounds
            contentView2.isUserInteractionEnabled = false
            addSubview(contentView2)
            for view in contentView2.subviews {
                boundaries.append(view)
            }
        }
}
