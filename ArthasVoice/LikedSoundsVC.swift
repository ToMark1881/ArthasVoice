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
        tv.rowHeight = 198
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(named: "BackColor")
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
        let cell = soundsTableView.dequeueReusableCell(withIdentifier: soundCell, for: indexPath) as! SoundCell
        let sound = likedSounds[indexPath.row]
        cell.soundDelegate = self
        cell.sound = sound
        let imageMod = (indexPath.row + 1) % IMAGES.count
        cell.iconImageView.image = UIImage(named: IMAGES[imageMod])
        return cell
    }
    
    @objc private func share(_ sound: Sound) {
        let fileName = sound.name
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {return}
        let activityVC = UIActivityViewController(activityItems: [url],applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @objc private func play(_ sound: Sound) {
        player?.stop()
        let fileName = sound.name
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp4.rawValue)

            guard let player = player else { return }

            player.play()
        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    @objc private func addToFav(_ sound: Sound) {
        sound.isLiked.toggle()
        let index = likedSounds.firstIndex(of: sound)!
        likedSounds.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
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
        soundsTableView.backgroundColor = UIColor(named: "BackColor")
        soundsTableView.allowsSelection = false
        soundsTableView.register(UINib(nibName: "SoundCell", bundle: nil), forCellReuseIdentifier: soundCell)
        self.view.addSubview(soundsTableView)
        self.view.backgroundColor = UIColor(named: "BackColor")
    }
}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "TextColor")
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

extension LikedSoundsVC: SoundCellDelegate {
    
    func didTapOnPlayButton(_ sound: Sound?) {
        if let sound = sound { self.play(sound) }
    }
    
    func didTapOnFavoriteButton(_ sound: Sound?) {
        if let sound = sound { self.addToFav(sound) }
    }
    
    func didTapOnShareButton(_ sound: Sound?) {
        if let sound = sound { self.share(sound) }
        
    }
    
}
