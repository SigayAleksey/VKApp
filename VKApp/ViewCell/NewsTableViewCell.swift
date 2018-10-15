//
//  NewsTableViewCell.swift
//  VKApp
//
//  Created by Алексей Сигай on 25.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

// CellHeightDelegate
protocol CellHeightDelegate: class {
    func setCellHeight(height: CGFloat)
}

class NewsTableViewCell: UITableViewCell {
    
    // CellHeightDelegate
    weak var delegate: CellHeightDelegate? = nil

    @IBOutlet weak var newPhoto: UIImageView!
    @IBOutlet weak var newText: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var repostImage: UIImageView!
    @IBOutlet weak var viewImage: UIImageView!

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var repostCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    var likeCount: Int?
    var commentCount: Int?
    var repostCount: Int?
    var viewCount: Int?
    var photoWidth: CGFloat?
    var photoHeight: CGFloat? {
        didSet {
            guard let likeCount = likeCount else { return }
            likeCountLabel.text = String(likeCount)
            guard let commentCount = commentCount else { return }
            commentCountLabel.text = String(commentCount)
            guard let repostCount = repostCount else { return }
            repostCountLabel.text = String(repostCount)
            guard let viewCount = viewCount else { return }
            viewCountLabel.text = String(viewCount)
            makeFrame()
        }
    }

    override func awakeFromNib() {
        newPhoto.translatesAutoresizingMaskIntoConstraints = false
        newText.translatesAutoresizingMaskIntoConstraints = false
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        repostImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        repostCountLabel.translatesAutoresizingMaskIntoConstraints = false
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        super.awakeFromNib()
    }
    
    func makeFrame() {
        newPhoto.frame = GetFrameNews.photo(bounds: bounds, widthOrig: photoWidth!, heightOrig: photoHeight!)
        newText.frame = GetFrameNews.text(bounds: bounds)

        viewCountLabel.frame = GetFrameNews.responseCount(bounds: bounds, text: viewCountLabel.text!, font: viewCountLabel.font, type: "view")
        viewImage.frame = GetFrameNews.responseImage(bounds: bounds)
        repostCountLabel.frame = GetFrameNews.responseCount(bounds: bounds, text: repostCountLabel.text!, font: repostCountLabel.font, type: "repost")
        repostImage.frame = GetFrameNews.responseImage(bounds: bounds)
        commentCountLabel.frame = GetFrameNews.responseCount(bounds: bounds, text: commentCountLabel.text!, font: commentCountLabel.font, type: "comment")
        commentImage.frame = GetFrameNews.responseImage(bounds: bounds)
        likeCountLabel.frame = GetFrameNews.responseCount(bounds: bounds, text: likeCountLabel.text!, font: likeCountLabel.font, type: "like")
        likeImage.frame = GetFrameNews.responseImage(bounds: bounds)

        // CellHeightDelegate
        if delegate != nil {
            let height = newPhoto.frame.size.height + 36
            delegate?.setCellHeight(height: height)
        }

    }
    
}
