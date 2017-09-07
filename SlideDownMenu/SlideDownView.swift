//
//  SlideDownView.swift
//  SlideDownMenu
//
//  Created by Matthijs on 04/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class SlideDownView: UIView {
    
    let slideDownViewBottomButtonDownImage = UIImage(named: "downChevronSmall")?.withRenderingMode(.alwaysTemplate)
    let slideDownViewBottomButtonUpImage = UIImage(named: "upChevronSmall")?.withRenderingMode(.alwaysTemplate)
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var slideDownButtonView: UIView!
    @IBOutlet weak var slideDownButtonBottomView: UIView!
    @IBOutlet weak var slideDownViewBottomButtonUpImageView: UIImageView!
    @IBOutlet weak var slideDownViewBottomButtonDownImageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var pullLabel: UILabel!
  
    enum swipeDirection {
        case down
        case up
    }
    
    var mySwipeDirection = swipeDirection.down
    var slideDownViewOut: Bool = false
    var slideDownViewStartPosition: CGFloat = 0.0
    var slideDownViewEndPosition: CGFloat = 100.0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        view = loadViewFromNib()
        view.frame = bounds
        view.backgroundColor = .clear
        addSubview(view)
        
        slideDownViewBottomButtonUpImageView.image = slideDownViewBottomButtonUpImage
        slideDownViewBottomButtonUpImageView.tintColor = .black
        slideDownViewBottomButtonDownImageView.image = slideDownViewBottomButtonDownImage
        slideDownViewBottomButtonDownImageView.tintColor = .red
        slideDownButtonBottomView.backgroundColor = .clear
        
        self.backgroundColor = .clear
        
        updateUI()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func updateUI() {
        slideDownViewStartPosition = -self.bounds.height + slideDownButtonBottomView.frame.height + slideDownViewEndPosition
        self.center = CGPoint(x: self.center.x, y:  self.frame.height / 2 + slideDownViewStartPosition)
        
        self.layoutIfNeeded()
    }
    
    func setViewAlpha(centerRatio: CGFloat) {
        let ratioToAlpha = 1.0 - centerRatio
        slideDownButtonBottomView.alpha = ratioToAlpha * 2
    }
    
    @IBAction func didTapslideDownButtonView(gestureRecognizer: UIGestureRecognizer) {
        setMenu()
    }
    
    func setMenu()  {
        if (!slideDownViewOut) {
            UIView.animate(withDuration: 0.5, animations: {
                self.center = CGPoint(x: self.center.x, y: self.frame.height / 2 + self.slideDownViewEndPosition)
                self.slideDownViewOut = true
                self.slideDownButtonBottomView.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.center = CGPoint(x: self.center.x, y:  self.frame.height / 2 + self.slideDownViewStartPosition)
                self.slideDownViewOut = false
                self.slideDownButtonBottomView.alpha = 1.0
            })
        }
    }

    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        let centerRatio = (self.frame.origin.y + -slideDownViewStartPosition) / (slideDownViewEndPosition + -slideDownViewStartPosition)
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        let translation = panGestureRecognizer.translation(in: self)
        
        // check if user is sliding up or down
        if velocity.y > 0 {
            mySwipeDirection = .down
        }
        else if velocity.y < 0 {
            mySwipeDirection = .up
        }
        
        switch panGestureRecognizer.state {
        case .changed:
            
            switch mySwipeDirection {
            case .down:
                self.center = CGPoint(x: self.center.x, y: min(self.center.y + translation.y, self.frame.height / 2 + slideDownViewEndPosition))
            case .up:
                self.center = CGPoint(x: self.center.x, y: max(self.center.y + translation.y, self.frame.height / 2 + slideDownViewStartPosition))
            }
            
            setViewAlpha(centerRatio: centerRatio)
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            if panGestureRecognizer.view != nil {
                var verticalDirectionTreshold: CGFloat = 0.0
                
                // set new center
                var newCenter = CGPoint(x: self.center.x, y: self.frame.height / 2 + slideDownViewEndPosition)
                
                switch mySwipeDirection {
                case .down:
                    verticalDirectionTreshold = -2.0
                case .up:
                    verticalDirectionTreshold = 2.0
                }
                
                if centerRatio < verticalDirectionTreshold  {
                    newCenter = CGPoint(x: self.center.x, y:  self.frame.height / 2 + slideDownViewStartPosition)
                    slideDownViewOut = false
                } else if Int(self.frame.origin.y) != Int(slideDownViewStartPosition) {
                    newCenter = CGPoint(x: self.center.x, y: self.frame.height / 2 + slideDownViewEndPosition)
                    slideDownViewOut = true
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                    self.setViewAlpha(centerRatio: centerRatio > verticalDirectionTreshold ? 1.0 : 0.0)
                    self.center = newCenter
                }, completion: nil)
            }
        default:
            break
        }
    }
}
