//
//  SoundCell.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 02.07.2020.
//  Copyright © 2020 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit

class SoundCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var playAction: (() -> Void)?
    var favAction: (() -> Void)?
    var shareAction: (() -> Void)?
    
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        self.favAction?()
    }
    @IBAction func didTapPlayButton(_ sender: Any) {
        self.playAction?()
        
    }
    @IBAction func didTapShareButton(_ sender: Any) {
        self.shareAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backView.addSoftUIEffectForView()
        favButton.addSoftUIEffectForButton()
        playButton.addSoftUIEffectForButton()
        shareButton.addSoftUIEffectForButton()
    }
    
}
