//
//  Extensions.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 31.12.2019.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setState() {
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: 2, height: 2)
        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
    }
    
    func resetState() {
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: -2, height: -2)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 2)
    }
    
    public func addSoftUIEffectForButton(cornerRadius: CGFloat = 15.0, themeColor: UIColor = UIColor(named: "BackColor")!) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor(named: "BottomShadow")?.cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor(named: "TopShadow")?.cgColor
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 2
        self.layer.insertSublayer(shadowLayer, below: self.imageView?.layer)
    }
}

extension UIView {
    
    public func addSoftUIEffectForView(cornerRadius: CGFloat = 15.0, themeColor: UIColor = UIColor(named: "BackColor")!, shadowRadius: CGFloat = 2.0, opacity: Float = 1, width: CGFloat? = nil) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        self.layer.shadowColor = UIColor(named: "BottomShadow")?.cgColor //bottom shadow
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: width ?? self.bounds.width, height: self.bounds.height)
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor(named: "TopShadow")?.cgColor
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius //top shadow
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}

var SCREEN_SIZE = UIScreen.main.bounds

var IMAGES = ["roflanBatya", "roflanBuldiga", "roflanChervyak", "roflanCoolStory", "roflanDaunich", "roflanDulya", "roflanDulyaEbalo", "roflanEbalo", "roflanGantelya", "roflanHm", "roflanHmm", "roflanKomment", "roflanKrasniy", "roflanKrik", "roflanKurtka", "roflanOru", "roflanPominki", "roflanPomoika", "roflanPzdc", "roflanStrashno", "roflanTsar", "roflanUkr", "roflanUvajenie"]

var SOUND_NAMES = ["aaaa", "da", "dada", "diakuju", "back", "dlia_menia_eto_ray", "eto_konets", "fiksiruyu", "gore", "haha_vot_eto_ls", "hello", "help_help", "help", "idu", "izi_dlia_velichaishego", "izi_izi_izi", "klassno_skoka_ih_net", "koshmar", "krik_uuu", "krys", "kto_eto_chto_eto_za_musor", "kto_luchshiy_v_mire", "kuda_ty_sobralsa_na", "legkost_bytiya", "luchshiy_v_mire", "mmmonsterkill", "na_na_na", "na_na", "na", "ne_igraite_v_dotu", "nenavizhu_dotu", "nice_ya_frag_vzial", "nyaaaaa.mp30", "op_izi", "papizi", "pobeda_blizka_parni", "puk_i_stuk_po_stolu", "razrulil_prosto", "rev_1", "rev_2", "rev_3", "seichas_ya_vas_budu_rezat", "shchas_by_kripa_ne_dobit", "shola", "siuda_podoshel", "slishkom_izi_dlia_velichaishego", "smeh_1", "smeh_2", "smeh_3", "smeh_4", "smeh_5", "smeh_6", "smeh_7", "smeh_8", "smeh_9", "smeh_10", "smeh_11", "solny_kontsert_by_papich", "sore_ty_v_ignore", "sori", "stuk_po_stolu_1", "stuk_po_stolu_6", "tak_ce_zhorstko", "uuu_chto_eto", "VIKA", "ya_ne_umru", "ya_ne_vizhu_kripov", "ya_tut_gays", "zafiksiroval", "i_am_legend", "dobriy_pochantek", "opa_f5", "analiz_sil", "da_eto_jestko", "net_nastroyenia", "slojno", "solevarnya", "somnitelnaya_informaciya", "yeah", "virki_jinki", "aaa_aa", "activiryem_skill", "alo_menya_slishno", "apelsini", "bit_papizi", "dratuti", "hiden_lool", "incredible", "o_vi_iz_centra", "obezyanich", "opa_f_ku", "plus_nol", "posmeyalis", "privet_rabotyagi", "sovpadenie", "strashno_virubai", "vernulsya_is_nebitiya", "vines_musor_v_solo", "zdarova_pukich", "bidlo", "balans-1", "chempion-1", "chto_vi_delaete-1", "korol_vernulsya-1", "kuda_sinok-1", "lejat-1", "op_mizantrop-1", "pahnet_solyaroi-1", "roflan_gorit-1", "roflanpoel-1", "shito_podelat", "shnir_kyrier", "skolko_pomoshi", "smeemsya_vsem_klassom", "that_was_an_error", "ti_kto_pomoika", "tutututututututututu", "ursich", "vsem_lejat", "vsem_poka", "ya_debil", "ymri", "your_soul", "zasoleno", "zdarova", "vedmak", "bababablabla", "chto_ya_sdelal", "i_will_crush_you", "kulityyy", "mochi_yroda", "piymav_na_gendzutsy", "sleduishii", "na_debilichah", "one_moment_plz", "podrubil_proveryaite", "sto_iz_decyati", "kyda_ocherednyari", "lejat_plus_lejat", "lololo", "chto_proishodit", "chto_smeshnogo", "eh", "eto_bila_oshibka", "shok_content", "shok", "shtoooo", "strashno_virubay", "sporno", "ta_za_sho", "ti_idiot", "tupo_domoi", "udachi_vam", "yasno"]


var SOUND_DECRIPTIONS = ["Ха-ха", "Да", "Да-да да-да-да", "Дякую, тварина", "Back!", "Для меня это рай", "Это конец", "Фиксирую", "Горе побеждённым", "Вот это лс", "Hello!", "Help!", "Heeelp!", "Я їду додому", "Изи для величайшего", "Изи, изи, изи", "Классно (нет)", "Кошмар!", "Ууу", "Крит! Нужен крит", "Что это за мусор?", "Кто лучший в мире?", "Куда ты собрался?!", "Лёгкость бытия", "Лучший в мире за работой", "M-m-m-m-monsterkill", "На! На! Наа!", "Ныа!", "Ныыыааа!", "Не играйте в доту", "Ненавижу доту", "Найс, я фраг взял", "Наа!", "Оп, изи", "Оп, изи 2", "Победа близка", "Пффф", "Разрулил", "Рёв", "Рёв 2", "Рёв 3", "Сейчас я буду резать", "Сейчас бы крипа не добить", "В соло", "Сюда подошел", "Слишком изи", "Смех", "Смех 2", "Смех 3", "Смех 4", "Смех 5", "Смех 6", "Смех 7", "Смех 8",  "Смех 9 ", "Смех 10", "Смех 11", "Сольный концерт by Папич", "Соре, ты в игноре", "Сорри", "Стук", "Стук 2", "Так, це жорстко", "Уууу, что это?", "VIKA", "Я не умру", "Я не вижу крипов", "Я тут, гайз", "Зафиксировал", "I am Legend!", "Dobry początek", "Опа Ф5", "Анализ сил", "Да, это жёстко", "Нет настроения", "Сложно", "Солеварня", "Сомнительная информация", "Yeah", "Вирки джинки", "Ааыы", "Активируем скилл", "Алло, меня слышно?", "Апельсины", "Быть Папизи...", "Дратути", "Hidden lool", "Incredible", "О, вы из центра", "Обезьяныч", "Опа, Ф-ку", "Плюс ноль", "Посмеялись", "Привет, работяги", "Совпадение? Не думаю", "Страшно, вырубай", "Вернулся из небытия", "Вынес мусор в соло", "Здарова, Пукич", "Быдло", "Баланс", "Чемпион", "Что вы делаете?", "Король вернулся", "Ты куда?", "Лежать", "Оп, мизантроп", "Пахнет солярой", "roflanGorit", "roflanPoel", "Щито поделать?", "Шнырь курьер", "Сколько помощи?", "Смеемся всем классом", "That was an error", "Ты кто? Помойка", "Тутутуту", "Урсич", "Всем лежать", "Всем пока", "Що мені робити? Вмерти чи жити?", "Умри", "Soul", "Засолено", "Здарова", "Ведьмак?", "Аблалалаба", "Что я сделал? Нееет!", "I will cruch You!", "Кулити", "Мочи урода", "Піймав на гендзюццу", "Следующий", "На дебилычах", "One moment plz", "Подрубил, проверяйте", "100/10", "Куда, очередняры?", "Лежать плюс лежать", "LoLoLo", "Что происходит?", "Что смешного?", "Эх", "Это была ошибка", "Шок-контент", "Шок", "Что?!?", "Страшно, вырубай", "Спорно", "Та за шо", "Ты идиот", "Тупо домой", "Удачи вам", "Ясно"]


let RED_COLOR: UIColor = {
    return UIColor(red: 215/255, green: 75/255, blue: 30/255, alpha: 1.0)
}()

