//
//  InfoVC.swift
//  ArthasVoice
//
//  Created by Vladyslav Vdovychenko on 1/16/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//

import UIKit
import StoreKit

class InfoVC: UIViewController {
    
    private var products = [SKProduct]()
    
    let contactDeveloperButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Жалобы и Предложения", for: .normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        b.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        b.backgroundColor = COLORS[7]
        b.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        return b
    }()
    
    let thanksButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Дякую @starode за допомогу!", for: .normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        b.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        b.backgroundColor = COLORS[0]
        b.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        return b
    }()
    
    let smallTipButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Небольшой донат", for: .normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        b.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        b.backgroundColor = COLORS[1]
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.titleLabel?.minimumScaleFactor = 0.2
        b.titleLabel?.numberOfLines = 0
        b.titleLabel?.textAlignment = .center
        b.addTarget(self, action: #selector(smallTip), for: .touchUpInside)
        return b
    }()
    
    let bigTipButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Большой донат", for: .normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        b.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.titleLabel?.minimumScaleFactor = 0.2
        b.backgroundColor = COLORS[2]
        b.titleLabel?.numberOfLines = 0
        b.titleLabel?.textAlignment = .center
        b.addTarget(self, action: #selector(bigTip), for: .touchUpInside)
        return b
    }()
    
    let versionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.font = UIFont(name: "HelveticaNeue", size: 20)
        l.textColor = UIColor.white
        l.backgroundColor = COLORS[6]
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.2
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
    
    @objc
    private func mailToDeveloper() {
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
    
    @objc
    private func openInstagram() {
        let username =  "starode" // Your Instagram Username here
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://instagram.com/\(username)")!
            application.open(webURL)
        }
    }
    
    @objc
    private func smallTip() {
        for product in products {
            let small = "smallTip"
            if product.productIdentifier == small {
                PKIAPHandler.shared.purchase(product: product) { (alert, product, transaction) in
                    if let _ = transaction, let _ = product {
                        let alert = UIAlertController(title: "roflanDovolen", message: "Большое спасибо за поддержку!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //use transaction details and purchased product as you want
                    }
                }
            }
            else {
                continue
            }
        }
    }
    
    @objc func bigTip() {
        for product in products {
            let big = "bigTip"
            if product.productIdentifier == big {
                PKIAPHandler.shared.purchase(product: product) { (alert, product, transaction) in
                    if let _ = transaction, let _ = product {
                        let alert = UIAlertController(title: "roflanDovolen", message: "Большое спасибо за поддержку!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //use transaction details and purchased product as you want
                    }
                }
            }
            else {
                continue
            }
        }
    }

    override func viewDidLoad() {
        guard let bottomBar = self.navigationController?.tabBarController?.tabBar.frame else { return }
        super.viewDidLoad()
        self.view.backgroundColor = BACK_COLOR
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationController?.title = "Другое"
        self.navigationController?.navigationBar.barTintColor = BACK_COLOR
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        getVersion()
        let startY: CGFloat = 126.0
        versionLabel.frame = CGRect(x: 20, y: startY, width: UIScreen.main.bounds.width - 40, height: 98)
        contactDeveloperButton.frame = CGRect(x: 20, y: bottomBar.minY - 82, width: UIScreen.main.bounds.width - 40, height: 74)
        thanksButton.frame = CGRect(x: 20, y: contactDeveloperButton.frame.minY - 86, width: UIScreen.main.bounds.width - 40, height: 74)
        smallTipButton.frame = CGRect(x: 20, y: thanksButton.frame.minY - 86, width: UIScreen.main.bounds.width/2 - 25, height: 74)
        bigTipButton.frame = CGRect(x: smallTipButton.frame.maxX + 10, y: thanksButton.frame.minY - 86, width: UIScreen.main.bounds.width/2 - 25, height: 74)

        versionLabel.dropShadow()
        thanksButton.dropShadow()
        contactDeveloperButton.dropShadow()
        smallTipButton.dropShadow()
        bigTipButton.dropShadow()
        
        versionLabel.layer.cornerRadius = 15
        thanksButton.layer.cornerRadius = 15
        contactDeveloperButton.layer.cornerRadius = 15
        smallTipButton.layer.cornerRadius = 15
        bigTipButton.layer.cornerRadius = 15
        
        versionLabel.clipsToBounds = true
        
        self.view.addSubview(contactDeveloperButton)
        self.view.addSubview(thanksButton)
        self.view.addSubview(versionLabel)
        self.view.addSubview(smallTipButton)
        self.view.addSubview(bigTipButton)
        loadPurchases()
    }
    
    fileprivate func loadPurchases() {
       PKIAPHandler.shared.setProductIds(ids: ["smallTip", "bigTip"])
        PKIAPHandler.shared.fetchAvailableProducts { [weak self] (products)   in
            guard let sSelf = self else {return}
            sSelf.products = products
            print(products)
        }
    }
    
    fileprivate func getVersion() {
        guard let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String else {return}
        guard let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String else {return}
        let about = "ArthasVoice 2019\nVladyslav Vdovychenko\nApplication\nVersion: \(version)\nBuild: \(build)"
        versionLabel.text = about
    }
    

}
