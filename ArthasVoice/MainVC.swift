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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let soundCell = "soundCell"
    var player: AVAudioPlayer?
    var sounds: [Sound] = []
    
    static let colours = [UIColor(displayP3Red: 105/255, green: 212/255, blue: 97/255, alpha: 1),
                   UIColor(displayP3Red: 114/255, green: 87/255, blue: 223/255, alpha: 1),
                   UIColor(displayP3Red: 119/255, green: 137/255, blue: 199/255, alpha: 1),
                   UIColor(displayP3Red: 137/255, green: 154/255, blue: 149/255, alpha: 1),
                   UIColor(displayP3Red: 101/255, green: 174/255, blue: 36/255, alpha: 1),
                   UIColor(displayP3Red: 70/255, green: 100/255, blue: 76/255, alpha: 1),
                   UIColor(displayP3Red: 227/255, green: 45/255, blue: 49/255, alpha: 1),
                   UIColor(displayP3Red: 187/255, green: 76/255, blue: 31/255, alpha: 1)]
    
    let gradientColours = [[UIColor(displayP3Red: 105/255, green: 212/255, blue: 97/255, alpha: 1),
                                   UIColor(displayP3Red: 205/255, green: 212/255, blue: 97/255, alpha: 1)], //1
        
                                   [UIColor(displayP3Red: 114/255, green: 87/255, blue: 223/255, alpha: 1),
                                    UIColor(displayP3Red: 114/255, green: 130/255, blue: 223/255, alpha: 1)], //2
        
                                   [UIColor(displayP3Red: 119/255, green: 137/255, blue: 199/255, alpha: 1),
                                    UIColor(displayP3Red: 119/255, green: 137/255, blue: 235/255, alpha: 1)], //3
        
                                   [UIColor(displayP3Red: 137/255, green: 154/255, blue: 149/255, alpha: 1),
                                    UIColor(displayP3Red: 170/255, green: 154/255, blue: 149/255, alpha: 1)], //4
                                   
                                   [UIColor(displayP3Red: 101/255, green: 174/255, blue: 36/255, alpha: 1),
                                    UIColor(displayP3Red: 101/255, green: 174/255, blue: 100/255, alpha: 1)], //5
                                   
                                   [UIColor(displayP3Red: 70/255, green: 100/255, blue: 76/255, alpha: 1),
                                    UIColor(displayP3Red: 70/255, green: 100/255, blue: 130/255, alpha: 1)], //6
                                   
                                   [UIColor(displayP3Red: 227/255, green: 45/255, blue: 49/255, alpha: 1),
                                    UIColor(displayP3Red: 227/255, green: 100/255, blue: 49/255, alpha: 1)], //7
                                   
                                   [UIColor(displayP3Red: 187/255, green: 76/255, blue: 31/255, alpha: 1),
                                    UIColor(displayP3Red: 187/255, green: 76/255, blue: 75/255, alpha: 1)]] //8
    
    static var images = ["roflanBatya", "roflanBuldiga", "roflanChervyak", "roflanCoolStory", "roflanDaunich", "roflanDulya", "roflanDulyaEbalo", "roflanEbalo", "roflanGantelya", "roflanHm", "roflanHmm", "roflanKomment", "roflanKrasniy", "roflanKrik", "roflanKurtka", "roflanOru", "roflanPominki", "roflanPomoika", "roflanPzdc", "roflanStrashno", "roflanTsar", "roflanUkr", "roflanUvajenie"]
    
    let soundsName = ["aaaa", "da", "dada", "diakuju", "back", "dlia_menia_eto_ray", "eto_konets", "fiksiruyu", "gore", "haha_vot_eto_ls", "hello", "help_help", "help", "idu", "izi_dlia_velichaishego", "izi_izi_izi", "klassno_skoka_ih_net", "koshmar", "krik_uuu", "krys", "kto_eto_chto_eto_za_musor", "kto_luchshiy_v_mire", "kuda_ty_sobralsa_na", "legkost_bytiya", "luchshiy_v_mire", "mmmonsterkill", "na_na_na", "na_na", "na", "ne_igraite_v_dotu", "nenavizhu_dotu", "nice_ya_frag_vzial", "nyaaaaa.mp30", "op_izi", "papizi", "pobeda_blizka_parni", "puk_i_stuk_po_stolu", "razrulil_prosto", "rev_1", "rev_2", "rev_3", "seichas_ya_vas_budu_rezat", "shchas_by_kripa_ne_dobit", "shola", "siuda_podoshel", "slishkom_izi_dlia_velichaishego", "smeh_1", "smeh_2", "smeh_3", "smeh_4", "smeh_5", "smeh_6", "smeh_7", "smeh_8", "smeh_9", "smeh_10", "smeh_11", "solny_kontsert_by_papich", "sore_ty_v_ignore", "sori", "stuk_po_stolu_1", "stuk_po_stolu_6", "tak_ce_zhorstko", "uuu_chto_eto", "VIKA", "ya_ne_umru", "ya_ne_vizhu_kripov", "ya_tut_gays", "zafiksiroval", "i_am_legend", "dobriy_pochantek", "opa_f5", "analiz_sil", "da_eto_jestko", "net_nastroyenia", "slojno", "solevarnya", "somnitelnaya_informaciya", "yeah", "virki_jinki", "aaa_aa", "activiryem_skill", "alo_menya_slishno", "apelsini", "bit_papizi", "dratuti", "hiden_lool", "incredible", "o_vi_iz_centra", "obezyanich", "opa_f_ku", "plus_nol", "posmeyalis", "privet_rabotyagi", "sovpadenie", "strashno_virubai", "vernulsya_is_nebitiya", "vines_musor_v_solo", "zdarova_pukich", "bidlo", "balans-1", "chempion-1", "chto_vi_delaete-1", "korol_vernulsya-1", "kuda_sinok-1", "lejat-1", "op_mizantrop-1", "pahnet_solyaroi-1", "roflan_gorit-1", "roflanpoel-1", "shito_podelat", "shnir_kyrier", "skolko_pomoshi", "smeemsya_vsem_klassom", "that_was_an_error", "ti_kto_pomoika", "tutututututututututu", "ursich", "vsem_lejat", "vsem_poka", "ya_debil", "ymri", "your_soul", "zasoleno", "zdarova"]
    
    
    let soundsDescription = ["Ха-ха", "Да", "Да-да да-да-да", "Дякую, тварина", "Back!", "Для меня это рай", "Это конец", "Фиксирую", "Горе побеждённым", "Вот это лс", "Hello!", "Help!", "Heeelp!", "Я їду додому", "Изи для величайшего", "Изи, изи, изи", "Классно (нет)", "Кошмар!", "Ууу", "Крит! Нужен крит", "Что это за мусор?", "Кто лучший в мире?", "Куда ты собрался?!", "Лёгкость бытия", "Лучший в мире за работой", "M-m-m-m-monsterkill", "На! На! Наа!", "Ныа!", "Ныыыааа!", "Не играйте в доту", "Ненавижу доту", "Найс, я фраг взял", "Наа!", "Оп, изи", "Оп, изи 2", "Победа близка", "Пффф", "Разрулил", "Рёв", "Рёв 2", "Рёв 3", "Сейчас я буду резать", "Сейчас бы крипа не добить", "В соло", "Сюда подошел", "Слишком изи", "Смех", "Смех 2", "Смех 3", "Смех 4", "Смех 5", "Смех 6", "Смех 7", "Смех 8",  "Смех 9 ", "Смех 10", "Смех 11", "Сольный концерт by Папич", "Соре, ты в игноре", "Сорри", "Стук", "Стук 2", "Так, це жорстко", "Уууу, что это?", "VIKA", "Я не умру", "Я не вижу крипов", "Я тут, гайз", "Зафиксировал", "I am Legend!", "Dobry początek", "Опа Ф5", "Анализ сил", "Да, это жёстко", "Нет настроения", "Сложно", "Солеварня", "Сомнительная информация", "Yeah", "Вирки джинки", "Ааыы", "Активируем скилл", "Алло, меня слышно?", "Апельсины", "Быть Папизи...", "Дратути", "Hidden lool", "Incredible", "О, вы из центра", "Обезьяныч", "Опа, Ф-ку", "Плюс ноль", "Посмеялись", "Привет, работяги", "Совпадение? Не думаю", "Страшно, вырубай", "Вернулся из небытия", "Вынес мусор в соло", "Здарова, Пукич", "Быдло", "Баланс", "Чемпион", "Что вы делаете?", "Король вернулся", "Ты куда?", "Лежать", "Оп, мизантроп", "Пахнет солярой", "roflanGorit", "roflanPoel", "Щито поделать?", "Шнырь курьер", "Сколько помощи?", "Смеемся всем классом", "That was an error", "Ты кто? Помойка", "Тутутуту", "Урсич", "Всем лежать", "Всем пока", "Що мені робити? Вмерти чи жити?", "Умри", "Soul", "Засолено", "Здарова"]
    
    let soundsTableView: UITableView = {
        let tv = UITableView()
        tv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tv.rowHeight = 88 + 30
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.black
        tv.separatorColor = UIColor.clear
        return tv
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soundsTableView.dequeueReusableCell(withIdentifier: soundCell, for: indexPath) as! SoundTVC
        cell.soundName.text = sounds[indexPath.row].desc
        cell.favButton.tag = indexPath.row
        cell.playButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(addToFav(_:)), for: .touchUpInside)
        cell.playButton.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        
        let index = indexPath.row + 1
        let mod = index % MainVC.colours.count
        cell.backView.backgroundColor = MainVC.colours[mod]
        cell.backView.dropShadow()
        cell.shareButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        cell.playButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        cell.soundName.textColor = UIColor.white.withAlphaComponent(0.8)
        
        let imageMod = (indexPath.row + 1) % MainVC.images.count
        cell.iconImageView.image = UIImage(named: MainVC.images[imageMod])
        if sounds[indexPath.row].isLiked {
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
        let fileName = sounds[sender.tag].name
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {return}
        let activityVC = UIActivityViewController(activityItems: [url],applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @objc private func play(_ sender: UIButton) {
        player?.stop()
        let fileName = sounds[sender.tag].name
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
        let sound = sounds[sender.tag]
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
        for index in soundsName.indices {
            let sound = Sound(context: managedContext)
            sound.name = soundsName[index]
            sound.desc = soundsDescription[index]
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
    
    private func addNewSounds(from: Int, to: Int) {
        print("new sounds from \(from) to \(to)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        for index in from ... to {
            let sound = Sound(context: managedContext)
            sound.name = soundsName[index]
            sound.desc = soundsDescription[index]
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
        MainVC.images.shuffle()
        print("\(soundsName.count), \(soundsDescription.count)")
        soundsTableView.delegate = self
        soundsTableView.dataSource = self
        soundsTableView.separatorStyle = .none
        soundsTableView.backgroundColor = UIColor.white
        soundsTableView.allowsSelection = false
        soundsTableView.register(SoundTVC.self, forCellReuseIdentifier: soundCell)
        self.view.addSubview(soundsTableView)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationController?.title = "Звуки"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        loadData()
        
        if sounds.isEmpty {
            saveAllSoundsToCoreData()
        }
        else if sounds.count != soundsName.count {
            addNewSounds(from: sounds.count, to: soundsName.count - 1)
        }
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.23
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

extension UIView {
    func addGradientWith(_ colors: [UIColor]) {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = gradientView.frame.size
        gradientLayer.colors = colors
        //Use diffrent colors
        self.layer.insertSublayer(gradientLayer, at: 1)
        //self.addSubview(gradientView)
    }
}
