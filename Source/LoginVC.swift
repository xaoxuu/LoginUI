//
//  LoginVC.swift
//  LoginUI
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

public class LoginVC: UIViewController {
    
    public enum Mode: Int{
        case login = 1
        case signup = 2
        case reset = 3
    }
    var mode = Mode.login {
        didSet{
            switch mode {
            case .login:
                loginBtn.tag = Mode.login.rawValue
                signupBtn.tag = Mode.signup.rawValue
                resetBtn.tag = Mode.reset.rawValue
                loginBtn.setTitle(LoginUI.loginTitle, for: .normal)
                signupBtn.setTitle(LoginUI.signupTitle, for: .normal)
                resetBtn.setTitle(LoginUI.resetTitle, for: .normal)
                signupBtn.isHidden = false
                resetBtn.isHidden = false
                inputArea.addSubview(tf2)
                tf3.removeFromSuperview()
                tf1.prefix = LoginUI.accountTitle
                tf1.placeholder = LoginUI.accountPlaceholder
                if tf1.text?.isEmpty ?? true {
                    tf1.text = LoginUI.accountDefault
                }
                tf1.returnKeyType = .next
                tf2.prefix = LoginUI.passwordTitle
                tf2.placeholder = LoginUI.passwordPlaceholder
                tf2.returnKeyType = .done
            case .signup:
                loginBtn.tag = Mode.signup.rawValue
                signupBtn.tag = Mode.login.rawValue
                resetBtn.tag = Mode.reset.rawValue
                loginBtn.setTitle(LoginUI.signupTitle, for: .normal)
                signupBtn.setTitle(LoginUI.loginTitle, for: .normal)
                resetBtn.setTitle(LoginUI.resetTitle, for: .normal)
                signupBtn.isHidden = false
                resetBtn.isHidden = true
                inputArea.addSubview(tf2)
                inputArea.addSubview(tf3)
                tf1.placeholder = LoginUI.accountPlaceholder
                tf1.returnKeyType = .next
                tf2.returnKeyType = .next
            case .reset:
                loginBtn.tag = Mode.reset.rawValue
                signupBtn.tag = Mode.signup.rawValue
                resetBtn.tag = Mode.login.rawValue
                loginBtn.setTitle(LoginUI.okTitle, for: .normal)
                signupBtn.setTitle(LoginUI.signupTitle, for: .normal)
                resetBtn.setTitle(LoginUI.cancelTitle, for: .normal)
                signupBtn.isHidden = true
                resetBtn.isHidden = false
                tf2.removeFromSuperview()
                tf3.removeFromSuperview()
                tf1.placeholder = LoginUI.accountPlaceholder
                tf1.returnKeyType = .done
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                self.updateInputAreaLayout()
                self.view.layoutIfNeeded()
                self.tf1.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
    }
    
    let logo = UIImageView.init()
    let appName = UILabel.init()
    
    let inputArea = UIView.init()
    var accImgv = UIImageView()
    
    let tf1 = TF(returnKeyType: .next, isSecureTextEntry: false)
    let tf2 = TF(returnKeyType: .done, isSecureTextEntry: true)
    let tf3 = TF(returnKeyType: .done, isSecureTextEntry: true)
    
    
    let tfLeftView1 = TFLeftView()
    
    let loginBtn = UIButton.init(type: .system)
    let resetBtn = UIButton.init(type: .system)
    let signupBtn = UIButton.init(type: .system)
    let footerBtn = UIButton.init(type: .system)
    
    
    // MARK: - 初始化
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNavigation()
        setupBackground()
        setupSubviews()
        view.layoutIfNeeded()
        setupViewModel()
        onEditing(false)
        updateInputAreaLayout()
        view.layoutIfNeeded()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        mode = .login
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        onEditing(false)
    }
    
    public func onDismiss(callback: @escaping LoginUI.Event.Dismiss) {
        LoginUI.callbacks[.onDismiss] = callback
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        if let cb = LoginUI.callbacks[.onDismiss] as? LoginUI.Event.Dismiss {
            cb()
        }
    }
    
}

// MARK: - Setup Views
private extension LoginVC {
    
    func setupNavigation(){
        if self.navigationController?.viewControllers.count == 1 {
            let item = UIBarButtonItem.init(image: LoginUI.dismissIcon, style: .plain, target: self, action: #selector(didTappedDismissButton(sender:)))
            navigationItem.leftBarButtonItem = item
        } else {
            let btn = UIButton(frame: .zero)
            btn.setImage(LoginUI.dismissIcon, for: .normal)
            btn.imageEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
            view.addSubview(btn)
            btn.snp.makeConstraints { (mk) in
                mk.left.top.equalToSuperview()
                mk.width.height.equalTo(44)
            }
            btn.addTarget(self, action: #selector(didTappedDismissButton(sender:)), for: .touchUpInside)
        }
    }
    func setupBackground(){
        view.backgroundColor = .white
        view.tintColor = UIColor.accent
    }
    func setupSubviews(){
        // LOGO
        logo.image = LoginUI.logo
        logo.layer.cornerRadius = 0.5*logo.frame.size.width
        view.addSubview(logo)
        logo.contentMode = .scaleAspectFit
        logo.snp.remakeConstraints { (make) in
            make.width.height.equalTo(96)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view.frame.size.height * 0.2)
        }
        
        
        appName.text = LoginUI.title
        appName.font = UIFont.bold(20)
        view.addSubview(appName)
        appName.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(logo.snp.bottom).offset(LoginUI.padding)
        }
        
        
        inputArea.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        inputArea.layer.cornerRadius = LoginUI.cornerRadius
        view.addSubview(inputArea)
        
        // 输入框 
        inputArea.addSubview(tf1)
        tf1.returnKeyType = .next
        tf1.isSecureTextEntry = false
        inputArea.addSubview(tf2)
        inputArea.addSubview(tf3)
        setup(tf: tf1)
        setup(tf: tf2)
        setup(tf: tf3)
        tf3.prefix = LoginUI.passwordTitle
        tf3.placeholder = LoginUI.repeatPlaceholder
        if #available(iOS 11.0, *) {
            tf1.textContentType = UITextContentType.username
            tf2.textContentType = UITextContentType.password
            tf3.textContentType = UITextContentType.password
        } else {
            // Fallback on earlier versions
        }
        
        inputArea.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width - 2*LoginUI.margin)
            make.top.equalTo(self.view.frame.size.height * 0.4)
        }
        
        setup(btn: loginBtn)
        loginBtn.backgroundColor = view.tintColor
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = LoginUI.cornerRadius
        loginBtn.titleLabel?.font = UIFont.bold(15)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(inputArea.snp.bottom).offset(LoginUI.margin)
            make.left.right.equalTo(inputArea)
            make.height.equalTo(50)
        }
        loginBtn.tag = Mode.login.rawValue
        
        setup(btn: resetBtn)
        resetBtn.titleLabel?.font = UIFont.regular(14)
        view.addSubview(resetBtn)
        resetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(LoginUI.margin)
            make.left.equalTo(loginBtn)
        }
        resetBtn.tag = Mode.reset.rawValue
        
        setup(btn: signupBtn)
        signupBtn.titleLabel?.font = UIFont.regular(14)
        view.addSubview(signupBtn)
        signupBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(LoginUI.margin)
            make.right.equalTo(loginBtn.snp.right)
        }
        signupBtn.tag = Mode.signup.rawValue
        
        
        let footerArea = UIView()
        view.addSubview(footerArea)
        footerArea.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom).offset(-32)
            make.height.greaterThanOrEqualTo(40)
            make.left.greaterThanOrEqualTo(self.view.snp.left).offset(LoginUI.margin)
            make.right.lessThanOrEqualTo(self.view.snp.right).offset(-LoginUI.margin)
        }
        
        let footerLb = UILabel()
        footerLb.text = LoginUI.agreementPrefix
        footerLb.font = UIFont.regular(14)
        footerArea.addSubview(footerLb)
        footerLb.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(footerArea)
        }
        
        setup(btn: footerBtn)
        footerBtn.setTitle(LoginUI.agreementTitle, for: .normal)
        footerBtn.titleLabel?.font = UIFont.regular(14)
        footerArea.addSubview(footerBtn)
        footerBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(footerArea)
            make.left.equalTo(footerLb.snp.right).offset(1)
        }
        
    }
    
    func setupViewModel(){
        LoginUI.callbacks[.lockButtons] = { [weak self] in
            if self?.mode == .login {
                self?.loginBtn.isUserInteractionEnabled = false
                self?.loginBtn.alpha = 0.5
            } else if self?.mode == .signup {
                self?.signupBtn.isUserInteractionEnabled = false
                self?.signupBtn.alpha = 0.5
            }
        }
        LoginUI.callbacks[.unlockButtons] = { [weak self] in
            if self?.mode == .login {
                self?.loginBtn.isUserInteractionEnabled = true
                self?.loginBtn.alpha = 1
            } else if self?.mode == .signup {
                self?.signupBtn.isUserInteractionEnabled = true
                self?.signupBtn.alpha = 1
            }
        }
    }
    
    func setupObserver(){
        
    }
    private func setup(lb: UILabel) {
        lb.font = UIFont.regular(15)
    }
    
    private func setup(tf: UITextField) {
        tf.addTarget(self, action: #selector(didTappedReturn(sender:)), for: .editingDidEndOnExit)
        tf.addTarget(self, action: #selector(didEditingStatusChanged(sender:)), for: [.editingDidBegin, .editingDidEnd, .editingDidEndOnExit])
    }
    
    private func setup(btn: UIButton) {
        btn.addTarget(self, action: #selector(didTappedButton(sender:)), for: .touchUpInside)
    }
    private func updateInputAreaLayout(){
        if let _ = tf1.superview {
            tf1.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(LoginUI.padding)
                make.height.equalTo(32)
                make.bottom.lessThanOrEqualTo(inputArea).offset(-LoginUI.padding)
                make.left.equalToSuperview().offset(1*LoginUI.padding)
                make.right.equalToSuperview().offset(-2*LoginUI.padding)
            }
        }
        if let _ = tf2.superview {
            tf2.snp.remakeConstraints { (make) in
                make.top.equalTo(tf1.snp.bottom).offset(LoginUI.padding)
                make.height.equalTo(32)
                make.bottom.lessThanOrEqualTo(inputArea).offset(-LoginUI.padding)
                make.left.equalToSuperview().offset(1*LoginUI.padding)
                make.right.equalToSuperview().offset(-2*LoginUI.padding)
            }
        }
        if let _ = tf3.superview {
            tf3.snp.remakeConstraints { (make) in
                make.top.equalTo(tf2.snp.bottom).offset(LoginUI.padding)
                make.height.equalTo(32)
                make.bottom.lessThanOrEqualTo(inputArea).offset(-LoginUI.padding)
                make.left.equalToSuperview().offset(1*LoginUI.padding)
                make.right.equalToSuperview().offset(-2*LoginUI.padding)
            }
        }
    }
}


// MARK: - Actions
private extension LoginVC {
    
    @objc func didTappedButton(sender: UIButton) {
        if sender == loginBtn {
            if mode == .login {
                if tf1.text!.count == 0 {
                    tf1.becomeFirstResponder()
                    onEditing(true)
                } else if tf2.text!.count == 0 {
                    tf2.becomeFirstResponder()
                    onEditing(true)
                } else {
                    view.endEditing(true)
                    onEditing(false)
                    if let acc = tf1.text, let psw = tf2.text {
                        if let f = LoginUI.callbacks[.onTappedLogin] as? LoginUI.Event.Login {
                            LoginUI.lockButtons()
                            f(acc, psw)
                        }
                    }
                }
                
            } else if mode == .signup {
                if tf1.text!.count == 0 {
                    tf1.becomeFirstResponder()
                    onEditing(true)
                } else if tf2.text!.count == 0 {
                    tf2.becomeFirstResponder()
                    onEditing(true)
                } else if tf3.text!.count == 0 {
                    tf3.becomeFirstResponder()
                    onEditing(true)
                } else {
                    if tf2.text == tf3.text {
                        view.endEditing(true)
                        onEditing(false)
                        if let acc = tf1.text, let psw = tf2.text {
                            if let f = LoginUI.callbacks[.onTappedSignup] as? LoginUI.Event.Signup {
                                LoginUI.lockButtons()
                                f(acc, psw)
                            }
                        }
                    } else {
                        if let f = LoginUI.callbacks[.onPasswordInconsistent] as? LoginUI.Event.PasswordInconsistent {
                            f()
                        }
                        tf2.becomeFirstResponder()
                    }
                }
                
            } else if mode == .reset {
                if let email = tf1.text {
                    if let f = LoginUI.callbacks["onTappedForgotPassword"] as? LoginUI.Event.ForgotPassword {
                        f(email)
                    }
                }
            }
            
        } else if sender == resetBtn {
            mode = Mode.init(rawValue: sender.tag) ?? .reset
        } else if sender == signupBtn {
            mode = Mode.init(rawValue: sender.tag) ?? .signup
        } else if sender == footerBtn {
            if let url = LoginUI.agreementURL, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @objc func didTappedReturn(sender: UITextField) {
        sender.resignFirstResponder()
        if sender == tf1 {
            if mode == .reset {
                didTappedButton(sender: loginBtn)
            } else {
                tf2.becomeFirstResponder()
            }
        } else if sender == tf2 {
            if mode == .login {
                didTappedButton(sender: loginBtn)
            } else if mode == .signup {
                tf3.becomeFirstResponder()
            }
        } else if sender == tf3 {
            didTappedButton(sender: loginBtn)
        }
    }
    @objc func didEditingStatusChanged(sender: UITextField){
        if sender.isEditing == true {
            onEditing(true)
            LoginUI.unlockButtons()
        }
    }
    
    func onEditing(_ editing: Bool){
        tf1.layoutIfNeeded()
        tf2.layoutIfNeeded()
        tf3.layoutIfNeeded()
        if let _ = logo.superview {
            logo.snp.updateConstraints { (make) in
                if editing == true {
                    make.width.height.equalTo(76)
                    make.centerY.equalTo(self.view.frame.size.height * 0.12)
                } else {
                    make.width.height.equalTo(96)
                    make.centerY.equalTo(self.view.frame.size.height * 0.2)
                }
            }
        }
        if let _ = appName.superview {
            appName.snp.updateConstraints { (make) in
                if editing == true {
                    make.top.equalTo(logo.snp.bottom).offset(0)
                } else {
                    make.top.equalTo(logo.snp.bottom).offset(LoginUI.padding)
                }
            }
        }
        
        if let _ = inputArea.superview {
            inputArea.snp.updateConstraints { (make) in
                if editing == true {
                    make.top.equalTo(self.view.frame.size.height * 0.2)
                } else {
                    make.top.equalTo(self.view.frame.size.height * 0.4)
                }
            }
        }
        UIView.animate(withDuration: 0.38) {
            self.view.layoutIfNeeded()
            if editing == true {
                self.appName.alpha = 0
                self.appName.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            } else {
                self.appName.alpha = 1
                self.appName.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc func didTappedDismissButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
