//
//  SoundsVC.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 1/6/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SoundsVC: UIViewController {
    
    let soundCell = "soundCell"
    var player: AVAudioPlayer?
    var sounds: [Sound] = []
    var filteredSounds = [Sound]()
    
    @IBOutlet weak var soundsTableView: UITableView!
    
    var resultSearchController = UISearchController()
    
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            soundsTableView.reloadData()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func saveAllSoundsToCoreData() {
        print("all sounds saved!")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        for index in SOUND_NAMES.indices {
            let sound = Sound(context: managedContext)
            sound.name = SOUND_NAMES[index]
            sound.desc = SOUND_DECRIPTIONS[index]
            sound.isLiked = false
            do {
                try managedContext.save()
                sounds.append(sound)
                DispatchQueue.main.async {
                    self.soundsTableView.reloadData()
                }
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<Sound> = Sound.fetchRequest()
        do {
            sounds = try managedContext.fetch(fetchReq)
            DispatchQueue.main.async {
                self.soundsTableView.reloadData()
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    private func clearCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sound> = Sound.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                managedContext.delete(object)
            }
        } catch let error {
            print(error)
        }
        self.saveAllSoundsToCoreData()
    }
    
    private func addNewSounds(from: Int, to: Int) {
        print("new sounds from \(from) to \(to)")
        if from > to {
            clearCoreData()
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        for index in from ... to {
            let sound = Sound(context: managedContext)
            sound.name = SOUND_NAMES[index]
            sound.desc = SOUND_DECRIPTIONS[index]
            sound.isLiked = false
            do {
                try managedContext.save()
                sounds.append(sound)
                DispatchQueue.main.async {
                    self.soundsTableView.reloadData()
                }
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        IMAGES.shuffle()
        print("\(SOUND_NAMES.count), \(SOUND_DECRIPTIONS.count)")
        soundsTableView.register(UINib(nibName: "SoundCell", bundle: nil), forCellReuseIdentifier: soundCell)
        soundsTableView.contentInset.bottom = 34
        self.view.addSubview(soundsTableView)
        self.view.backgroundColor = UIColor(named: "BackColor")
        loadData()
        
        if sounds.isEmpty {
            saveAllSoundsToCoreData()
        }
        else if sounds.count != SOUND_NAMES.count {
            addNewSounds(from: sounds.count, to: SOUND_NAMES.count - 1)
        }
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.backgroundColor = UIColor(named: "BackColor")
            controller.searchBar.barTintColor = UIColor(named: "BackColor")
            controller.searchBar.tintColor = UIColor(named: "BackColor")
            controller.searchBar.backgroundImage = UIImage()
            return controller
        })()
        
        soundsTableView.reloadData()
    }
    
    @objc
    fileprivate func reverseArray() {
        self.sounds = self.sounds.reversed()
        self.soundsTableView.reloadSections([0], with: .fade)
    }
}

extension SoundsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredSounds.removeAll(keepingCapacity: false)
        filteredSounds = sounds.filter( {
            ($0.desc?.localizedCaseInsensitiveContains(searchController.searchBar.text!) ?? false)
        })
        
        self.soundsTableView.reloadData()
    }
    
}

extension SoundsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return resultSearchController.searchBar
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredSounds.count
        } else {
            return sounds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soundsTableView.dequeueReusableCell(withIdentifier: soundCell, for: indexPath) as! SoundCell
        let sound = self.resultSearchController.isActive ? filteredSounds[indexPath.row] : sounds[indexPath.row]
        cell.soundDelegate = self
        cell.sound = sound
        let imageMod = (indexPath.row + 1) % IMAGES.count
        cell.iconImageView.image = UIImage(named: IMAGES[imageMod])
        return cell
    }
}

extension SoundsVC: SoundCellDelegate {
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
