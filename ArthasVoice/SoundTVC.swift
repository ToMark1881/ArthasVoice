//
//  SoundTVC.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 1/6/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit

class SoundTVC: UITableViewCell {
    

    let backView: UIView = {
        let v = UIView()
        v.layoutIfNeeded()
        v.clipsToBounds = true
        v.layer.cornerRadius = 15
        //v.backgroundColor = UIColor.white
        //v.dropShadow()
        return v
    }()
    
    let iconImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let soundName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 20)
        lbl.textColor = UIColor.white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        return lbl
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton()
        let origImage = UIImage(named: "share")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.setImage(origImage, for: .selected)
        return btn
    }()
    
    let playButton: UIButton = {
        let btn = UIButton()
        let origImage = UIImage(named: "play")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.setImage(origImage, for: .selected)

        return btn
    }()
    
    let favButton: UIButton = {
        let btn = UIButton()
        let origImage = UIImage(named: "fav")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.setImage(origImage, for: .selected)

        return btn
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.frame.size.height = 88 + 30
        self.frame.size.width = UIScreen.main.bounds.width
        backView.frame = CGRect(x: 15, y: 10, width: self.frame.width - 30, height: self.frame.height - 20)
        addSubview(backView)
        self.backgroundColor = UIColor.white
        iconImageView.frame = CGRect(x: 12, y: 12, width: 64, height: 64)
        iconImageView.contentMode = .scaleAspectFill
        backView.addSubview(iconImageView)
        
        soundName.frame = CGRect(x: iconImageView.frame.maxX + 20, y: iconImageView.frame.minY, width: backView.frame.width - 116, height: 30)
        backView.addSubview(soundName)
        
        favButton.frame = CGRect(x: soundName.frame.minX, y: iconImageView.frame.maxY - 24, width: 24, height: 24)
        playButton.frame = CGRect(x: soundName.frame.midX - 12, y: iconImageView.frame.maxY - 24, width: 24, height: 24)
        shareButton.frame = CGRect(x: soundName.frame.maxX - 24, y: iconImageView.frame.maxY - 24, width: 24, height: 24)

        //playButton.center.x = view.center.x - 6

        backView.addSubview(favButton)
        backView.addSubview(playButton)
        backView.addSubview(shareButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
