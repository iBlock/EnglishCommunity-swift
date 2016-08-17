//
//  JFTweetListCell.swift
//  EnglishCommunity-swift
//
//  Created by zhoujianfeng on 16/8/11.
//  Copyright © 2016年 zhoujianfeng. All rights reserved.
//

import UIKit
import YYWebImage

protocol JFTweetListCellDelegate: NSObjectProtocol {
    
    func tweetListCell(cell: JFTweetListCell, didTappedAvatarButton button: UIButton)
    func tweetListCell(cell: JFTweetListCell, didTappedLikeButton button: UIButton)
    func tweetListCell(cell: JFTweetListCell, didTappedSuperLink url: String)
    func tweetListCell(cell: JFTweetListCell, didTappedAtUser nickname: String, sequence: Int)
}

class JFTweetListCell: UITableViewCell {
    
    // MARK: - 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let grayColor = UIColor.grayColor()
    
    weak var tweetListCellDelegate: JFTweetListCellDelegate?
    
    /// 动弹模型
    var tweet: JFTweet? {
        didSet {
            
            avatarButton.yy_setBackgroundImageWithURL(NSURL(string: tweet!.author!.avatar!), forState: .Normal, options: YYWebImageOptions.AllowBackgroundTask)
            nicknameLabel.text = tweet!.author!.nickname!
            contentLabel.attributedText = JFEmoticon.emoticonStringToEmoticonAttrString(tweet!.content!, font: UIFont.systemFontOfSize(16))
            pictureView.images = tweet?.images
            publishTimeLabel.text = tweet?.publishTime?.timeStampToDate().dateToDescription()
            appClientLabel.text = tweet?.appClient == 0 ? "iOS客户端" : "Android客户端"
            likeButton.setTitle("\(tweet!.likeCount)", forState: .Normal)
            likeButton.selected = tweet?.liked == 1
            commentButton.setTitle("\(tweet!.commentCount)", forState: .Normal)
            
            let margin: CGFloat = 10
            let width = (SCREEN_WIDTH - MARGIN * 2.5 - 40 - margin * 2) / 3
            
            // 更新配图区域尺寸
            pictureView.snp_updateConstraints { (make) in
                make.size.equalTo(pictureView.calculateViewSize(width, itemHeight: width, margin: margin))
            }
        }
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        selectionStyle = .None
        
        contentView.addSubview(avatarButton)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(publishTimeLabel)
        contentView.addSubview(appClientLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(lineView)
        
        avatarButton.snp_makeConstraints { (make) in
            make.left.top.equalTo(MARGIN)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nicknameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp_right).offset(MARGIN * 0.5)
            make.top.equalTo(avatarButton.snp_top)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp_bottom).offset(MARGIN * 0.5)
            make.width.equalTo(SCREEN_WIDTH - 2.5 * MARGIN - 40)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(MARGIN * 0.5)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(40)
        }
        
        publishTimeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(pictureView.snp_bottom).offset(MARGIN * 0.5)
        }
        
        appClientLabel.snp_makeConstraints { (make) in
            make.left.equalTo(publishTimeLabel.snp_right).offset(MARGIN * 0.5)
            make.centerY.equalTo(publishTimeLabel)
        }
        
        commentButton.snp_makeConstraints { (make) in
            make.right.equalTo(contentView.snp_right).offset(-MARGIN)
            make.centerY.equalTo(publishTimeLabel)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        
        likeButton.snp_makeConstraints { (make) in
            make.right.equalTo(commentButton.snp_left)
            make.centerY.equalTo(publishTimeLabel)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        
        lineView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.height.equalTo(0.5)
        }
        
    }
    
    /**
     修改cell点击后高亮颜色
     */
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            contentView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        } else {
            contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    /**
     计算cell行高
     */
    func getRowHeight(tweet: JFTweet) -> CGFloat {
        self.tweet = tweet
        layoutIfNeeded()
        return CGRectGetMaxY(publishTimeLabel.frame) + 15
    }
    
    // MARK: - 点击事件
    /**
     点击头像按钮
     */
    @objc private func didTappedAvatarButton(button: UIButton) {
        tweetListCellDelegate?.tweetListCell(self, didTappedAvatarButton: button)
    }
    
    /**
     点击赞按钮
     */
    @objc private func didTappedLikeButton(button: UIButton) {
        tweetListCellDelegate?.tweetListCell(self, didTappedLikeButton: button)
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTappedAvatarButton(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    /// 昵称
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(16)
        return label
    }()
    
    /// 动弹文字内容
    private lazy var contentLabel: FFLabel = {
        let label = FFLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(14)
        label.labelDelegate = self
        return label
    }()
    
    /// 动弹配图
    private lazy var pictureView = JFTweetPictureView()
    
    /// 动弹发布时间
    private lazy var publishTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = self.grayColor
        return label
    }()
    
    /// app客户端类型
    private lazy var appClientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = self.grayColor
        return label
    }()
    
    /// 动弹赞按钮
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "star_icon_normal"), forState: .Normal)
        button.setImage(UIImage(named: "star_icon_selected"), forState: .Selected)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setTitleColor(self.grayColor, forState: .Normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTappedLikeButton(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    /// 动弹评论按钮
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "comment_icon"), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setTitleColor(self.grayColor, forState: .Normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()
    
    /// 分割线
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = RGB(0.3, g: 0.3, b: 0.3, alpha: 0.2)
        return lineView
    }()
    
}

// MARK: - FFLabelDelegate
extension JFTweetListCell: FFLabelDelegate {
    
    /**
     选中高亮的文字后回调
     
     - parameter label: 所在的label
     - parameter text:  被选中的文字
     */
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        // 点击了 超链接
        if text.hasPrefix("http") {
            tweetListCellDelegate?.tweetListCell(self, didTappedSuperLink: text)
        }
        
        // 点击了 @昵称
        if text.hasPrefix("@") {
            guard let content = label.text else {
                return
            }
            
            if let sequence = content.checkAtUserNickname()?.indexOf(text) {
                let nickname = text.stringByReplacingOccurrencesOfString("@", withString: "")
                tweetListCellDelegate?.tweetListCell(self, didTappedAtUser: nickname, sequence: Int(sequence))
            }
            
        }
        
    }
    
    
}