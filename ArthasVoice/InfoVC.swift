//
//  InfoVC.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 1/16/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    
    let contactDeveloperButton: UIButton = {
        let b = UIButton()
        b.setTitle("Жалобы и Предложения", for: .normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        b.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        b.backgroundColor = MainVC.colours[4]
        b.layer.cornerRadius = 15
        b.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        return b
    }()
    
    let thanksLabel: UILabel = {
        let l = UILabel()
        l.text = "Дякую @starode за допомогу!"
        l.textAlignment = .center
        l.font = UIFont(name: "HelveticaNeue", size: 20)
        l.textColor = UIColor(white: 1, alpha: 1)
        l.backgroundColor = MainVC.colours[5]
        l.adjustsFontSizeToFitWidth = true
        l.layer.cornerRadius = 15
        l.minimumScaleFactor = 0.2
        l.clipsToBounds = true
        return l
    }()
    
    let versionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.font = UIFont(name: "HelveticaNeue", size: 20)
        l.textColor = UIColor(white: 1, alpha: 1)
        l.backgroundColor = MainVC.colours[6]
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.2
        l.layer.cornerRadius = 15
        l.clipsToBounds = true
        return l
    }()
    
    @objc private func donate() {
        guard let url = URL(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=A374CL5AHG44E&source=url") else {return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @objc private func mailToDeveloper() {
        let email = "vlad182ava@gmail.com"
        //print(email)
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    override func viewDidLoad() {
        guard let bottomBar = self.navigationController?.tabBarController?.tabBar.frame else { return }
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationController?.title = "Другое"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        getVersion()
        let startY: CGFloat = 126.0
        versionLabel.frame = CGRect(x: 20, y: startY, width: UIScreen.main.bounds.width - 40, height: 98)
        thanksLabel.frame = CGRect(x: 20, y: versionLabel.frame.maxY + 12, width: UIScreen.main.bounds.width - 40, height: 98)
        contactDeveloperButton.frame = CGRect(x: 20, y: bottomBar.minY - 82, width: UIScreen.main.bounds.width - 40, height: 74)
        
        self.view.addSubview(contactDeveloperButton)
        self.view.addSubview(thanksLabel)
        self.view.addSubview(versionLabel)
    }
    
    fileprivate func getVersion() {
        guard let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String else {return}
        guard let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String else {return}
        let about = "ArthasVoice 2019\nVladyslav Vdovychenko\nApplication\nVersion: \(version)\nBuild: \(build)"
        versionLabel.text = about
    }
    

}
