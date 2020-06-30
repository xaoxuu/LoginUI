//
//  ViewController.swift
//  LoginUI
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit
import ProHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        LoginUI.logo = UIImage(named: "logo")
        LoginUI.logo = UIImage(systemName: "icloud")
        LoginUI.title = "LoginUI"
        LoginUI.agreementURL = URL(string: "https://xaoxuu.com")
        LoginUI.dismissIcon = UIImage(named: "prohud.xmark")
        LoginUI.onTappedLogin { (usn, psw) in
            Alert.push("loading", scene: .loading) { (vc) in
                vc.update { (vm) in
                    vm.title = "正在登录"
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                LoginUI.unlockButtons()
                Alert.pop("loading")
            }
        }
        LoginUI.onTappedSignup { (usn, psw) in
            Alert.push("loading", scene: .loading) { (vc) in
                vc.update { (vm) in
                    vm.title = "正在注册"
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                LoginUI.unlockButtons()
                Alert.pop("loading")
            }
        }
        LoginUI.onPasswordInconsistent {
            Alert.push(scene: .error, title: "", message: "两次输入的密码不一致")
        }
        LoginUI.onTappedForgotPassword { (acc) in
            Alert.push("loading", scene: .loading) { (vc) in
                vc.update { (vm) in
                    vm.title = "正在重置密码"
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                LoginUI.unlockButtons()
                Alert.pop("loading")
            }
        }
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = LoginVC()
        present(vc, animated: true, completion: nil)
    }

}

