//
//  MainVC.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 1/6/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class MainVC: UIViewController {
    
    let soundCell = "soundCell"
    var player: AVAudioPlayer?
    var sounds: [Sound] = []
    var filteredSounds = [Sound]()
    
    @IBOutlet weak var soundsTableView: UITableView!
    
    var resultSearchController = UISearchController()
    
    @objc private func share(_ sender: UIButton) {
        let fileName = self.resultSearchController.isActive ? filteredSounds[sender.tag].name : sounds[sender.tag].name
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {return}
        let activityVC = UIActivityViewController(activityItems: [url],applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @objc private func play(_ sender: UIButton) {
        player?.stop()
        let fileName = self.resultSearchController.isActive ? filteredSounds[sender.tag].name : sounds[sender.tag].name
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
        let sound = self.resultSearchController.isActive ? filteredSounds[sender.tag] : sounds[sender.tag]
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
            if managedContext.hasChanges {
                sounds = try managedContext.fetch(fetchReq)
                DispatchQueue.main.async {
                    self.soundsTableView.reloadData()
                }
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    private func addNewSounds(from: Int, to: Int) {
        print("new sounds from \(from) to \(to)")
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
        self.view.addSubview(soundsTableView)
        self.view.backgroundColor = BACK_COLOR
        self.navigationController?.navigationBar.isTranslucent = true
        self.title = "Звуки"
        self.navigationController?.navigationBar.barTintColor = BACK_COLOR
        self.navigationController?.navigationBar.backgroundColor = BACK_COLOR
        let sortButton = UIBarButtonItem(image: UIImage(named: "reverse"), style: .plain, target: self, action: #selector(reverseArray))
        sortButton.tintColor = LABEL_COLOR
        self.navigationItem.rightBarButtonItem = sortButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
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
            controller.searchBar.backgroundColor = BACK_COLOR
            controller.searchBar.barTintColor = BACK_COLOR
            soundsTableView.tableHeaderView = controller.searchBar
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

extension MainVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredSounds.removeAll(keepingCapacity: false)

        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //let array = (sounds.map { $0.description } as NSArray).filtered(using: searchPredicate)
        //print("ARRAY:", array)
        filteredSounds = sounds.filter( {
            ($0.desc?.localizedCaseInsensitiveContains(searchController.searchBar.text!) ?? false)
        })

        self.soundsTableView.reloadData()
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.soundName.text = sound.desc
        cell.favButton.tag = indexPath.row
        cell.playButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.shareAction = { self.share(cell.shareButton) }
        cell.playAction = { self.play(cell.playButton) }
        cell.favAction = { self.addToFav(cell.favButton) }
        
        cell.backView.backgroundColor = BACK_COLOR
        let imageMod = (indexPath.row + 1) % IMAGES.count
        cell.iconImageView.image = UIImage(named: IMAGES[imageMod])
        if sound.isLiked {
            cell.favButton.tintColor = .black
        }
        else {
            cell.favButton.tintColor = .systemRed
        }
        return cell
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = LABEL_COLOR.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

extension UIView {
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
