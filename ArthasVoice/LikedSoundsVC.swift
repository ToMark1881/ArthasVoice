//
//  LikedSoundsVC.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 1/16/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class LikedSoundsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let soundCell = "likedCell"
    var player: AVAudioPlayer?
    var sounds: [Sound] = []
    var likedSounds: [Sound] = []
    var images: [String] = []
    
    let soundsTableView: UITableView = {
        let tv = UITableView()
        tv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tv.rowHeight = 88 + 30
        tv.separatorStyle = .none
        tv.backgroundColor = LIGHT_BACKGROUND_COLOR
        tv.separatorColor = UIColor.clear
        return tv
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likedSounds.count == 0 {
            self.soundsTableView.setEmptyMessage("Пока что нет любимых звуков! \n Добавь их на левом экране")
        }
        else {
            self.soundsTableView.restore()
        }
        return likedSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soundsTableView.dequeueReusableCell(withIdentifier: soundCell, for: indexPath) as! SoundTVC
        cell.soundName.text = likedSounds[indexPath.row].desc
        cell.favButton.tag = indexPath.row
        cell.playButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(addToFav(_:)), for: .touchUpInside)
        cell.playButton.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        
        let index = indexPath.row + 1
        let mod = index % COLORS.count
        cell.backView.backgroundColor = COLORS[mod]
        cell.backView.dropShadow()
        cell.shareButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        cell.playButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        cell.soundName.textColor = UIColor.white.withAlphaComponent(0.8)
        
        let imageMod = (indexPath.row + 1) % images.count
        cell.iconImageView.image = UIImage(named: images[imageMod])
        
        
        if likedSounds[indexPath.row].isLiked {
            cell.favButton.tintColor = UIColor.black.withAlphaComponent(0.8)
        }
        else {
            cell.favButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y > 0) {
            UIView.animate(withDuration: 1.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 1.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }
    
    @objc private func share(_ sender: UIButton) {
        let fileName = likedSounds[sender.tag].name
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {return}
        let activityVC = UIActivityViewController(activityItems: [url],applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @objc private func play(_ sender: UIButton) {
        let fileName = likedSounds[sender.tag].name
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    @objc private func addToFav(_ sender: UIButton) {
        let sound = likedSounds[sender.tag]
        sound.isLiked.toggle()
        likedSounds.remove(at: sender.tag)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        soundsTableView.deleteRows(at: [indexPath], with: .fade)
        soundsTableView.reloadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.images = IMAGES
        self.images.shuffle()
        loadData()
    }
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<Sound> = Sound.fetchRequest()
        do {
            sounds = try managedContext.fetch(fetchReq)
            likedSounds = []
        }
        catch let error as NSError {
            print(error)
        }
        
        for sound in sounds {
            if sound.isLiked {
                likedSounds.append(sound)
            }
        }
        DispatchQueue.main.async {
            self.soundsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundsTableView.delegate = self
        soundsTableView.dataSource = self
        soundsTableView.separatorStyle = .none
        soundsTableView.backgroundColor = LIGHT_BACKGROUND_COLOR
        soundsTableView.allowsSelection = false
        soundsTableView.register(SoundTVC.self, forCellReuseIdentifier: soundCell)
        self.view.addSubview(soundsTableView)
        self.view.backgroundColor = LIGHT_BACKGROUND_COLOR
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationController?.title = "Избранное"
        self.navigationController?.navigationBar.barTintColor = LIGHT_BACKGROUND_COLOR
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = LABEL_COLOR
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 22)
        messageLabel.sizeToFit()
        let img = UIImageView()
        img.image = UIImage(named: "roflanEbalo")
        img.frame = CGRect(x: self.bounds.size.width/2 - 32, y: self.bounds.size.height/2 + 30, width: 64, height: 64)
        messageLabel.addSubview(img)
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
