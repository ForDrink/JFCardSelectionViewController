//
//  JFCardSelectionCell.swift
//  JFCardSelectionViewController
//
//  Created by Jeremy Fox on 3/1/16.
//  Copyright © 2016 Jeremy Fox. All rights reserved.
//

import UIKit

class JFCardSelectionCell: UICollectionViewCell {

    static let reuseIdentifier = "JFCardSelectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    private weak var scrollView: UIScrollView!
    private var card: CardPresentable?
    private var rotation: CGFloat {
        guard let _scrollView = scrollView else { return 0 }
        guard let _superView = _scrollView.superview else { return 0 }
        let position = _superView.convertPoint(self.center, fromView: scrollView)
        let superViewCenterX = CGRectGetMidX(_superView.frame)
        return ((position.x - superViewCenterX) / superViewCenterX) / 1.3
    }
    private var centerY: CGFloat {
        let height = CGRectGetHeight(scrollView.frame)
        var y = rotation
        if rotation < 0.0 {
            y *= -1
            y *= (rotation * -1)
        } else {
            y *= rotation
        }
        return ((y * height) / 1.8) + (height / 2.5)
    }
    private var centerX: CGFloat {
        let midX = CGRectGetMidX(scrollView.frame)
        var x = rotation
        if rotation < 0.0 {
            x *= -1
            x *= (rotation * -1)
        } else {
            x *= rotation
        }
        return center.x //(x * midX) + midX
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        if let _imageURLString = card?.imageURLString {
            imageView.cancelImageLoadForImageURL(_imageURLString)
        }
        imageView.image = nil
        label.text = nil
    }
    
    func configureForCard(card: CardPresentable, inScrollView scrollView: UIScrollView) {
        
        self.card = card
        self.scrollView = scrollView
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        
        imageView.loadImageAtURL(card.imageURLString, withDefaultImage: card.placeholderImage)
        
        self.transform = CGAffineTransformMakeRotation(rotation)
        center.y = centerY
        
        label.attributedText = NSAttributedString(string: card.titleText, attributes: Shadow.labelAttributesSoft)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
//        if (card?.titleText ?? "") == "Avery Smith" {
        self.transform = CGAffineTransformMakeRotation(rotation)
//        center = CGPoint(x: centerX, y: centerY)
        center.y = centerY
//        }
    }

}
