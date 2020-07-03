//
//  SoundCell.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 02.07.2020.
//  Copyright © 2020 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit

protocol SoundCellDelegate: class {
    func didTapOnPlayButton(_ sound: Sound?)
    func didTapOnFavoriteButton(_ sound: Sound?)
    func didTapOnShareButton(_ sound: Sound?)
}

class SoundCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!

    public var sound: Sound? {
        didSet {
            setupView()
        }
    }
    
    weak var soundDelegate: SoundCellDelegate?
    
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        sender.setState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            sender.resetState()
        }
        self.soundDelegate?.didTapOnFavoriteButton(sound)
    }
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        sender.setState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            sender.resetState()
        }
        self.soundDelegate?.didTapOnPlayButton(sound)
        
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        sender.setState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            sender.resetState()
        }
        self.soundDelegate?.didTapOnShareButton(sound)
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
    
    func setupView() {
        guard let sound = sound else { return }
        if sound.isLiked { favButton.tintColor = .black }
        else { favButton.tintColor = .systemRed }
        soundName.text = sound.desc
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backView.addSoftUIEffectForView(width: SCREEN_SIZE.width - 52)
        favButton.addSoftUIEffectForButton(cornerRadius: 24)
        playButton.addSoftUIEffectForButton(cornerRadius: 24)
        shareButton.addSoftUIEffectForButton(cornerRadius: 24)
    }
    
}
