//
//  LoginUI.swift
//  LoginUI
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit
import Inspire

public struct LoginUI {
    
    public static var dismissIcon: UIImage?
    public static var logo: UIImage?
    public static var title = ""
    public static var tintColor = Inspire.shared.color.theme
    
    public static var loginTitle = "登录"
    public static var signupTitle = "注册"
    public static var resetTitle = "忘记密码？"
    public static var okTitle = "确定"
    public static var cancelTitle = "取消"
    
    public static var accountTitle = "账号"
    public static var accountPlaceholder = "请输入邮箱地址"
    public static var accountDefault: String?
    public static var passwordTitle = "密码"
    public static var passwordPlaceholder = "请输入密码"
    public static var repeatPlaceholder = "请再次输入密码"
    
    public static var agreementPrefix = "注册即代表阅读并同意"
    public static var agreementTitle = "服务条款"
    public static var agreementURL: URL?
    
    public static var textFieldFontName = "Courier-Bold"
    public static var margin = CGFloat(16)
    public static var padding = CGFloat(16)
    public static var cornerRadius = CGFloat(12)
    
    internal static var callbacks = [Event.Key: Any]()
    
    internal static var current: LoginVC?
    
    public struct Event {
        public typealias Key = String
        public typealias Login = (String, String) -> Void
        public typealias Signup = (String, String) -> Void
        public typealias ForgotPassword = (String) -> Void
        public typealias PasswordInconsistent = () -> Void
        public typealias Dismiss = () -> Void
    }
    
    /// 点击了登录
    /// - Parameter callback: 回调
    public static func onTappedLogin(callback: @escaping Event.Login) {
        callbacks[.onTappedLogin] = callback
    }
    
    /// 点击了注册
    /// - Parameter callback: 回调
    public static func onTappedSignup(callback: @escaping Event.Signup) {
        callbacks[.onTappedSignup] = callback
    }
    
    /// 点击了忘记密码
    /// - Parameter callback: 回调
    public static func onTappedForgotPassword(callback: @escaping Event.ForgotPassword) {
        callbacks[.onTappedForgotPassword] = callback
    }
    
    /// 注册时两次输入的密码不一致的提示语
    /// - Parameter callback: 回调
    public static func onPasswordInconsistent(callback: @escaping Event.PasswordInconsistent) {
        callbacks[.onPasswordInconsistent] = callback
    }
    
    /// 解锁按钮（点击登录或者注册时会锁定按钮，事件处理完毕后调用此函数来解锁）
    public static func unlockButtons() {
        if let cb = LoginUI.callbacks[.unlockButtons] as? () -> Void {
            cb()
        }
    }
    
    public static func lockButtons() {
        if let cb = LoginUI.callbacks[.lockButtons] as? () -> Void {
            cb()
        }
    }
    
    @discardableResult
    public static func present(from vc: UIViewController) -> LoginVC {
        current = LoginVC()
        vc.present(current!, animated: true, completion: nil)
        return current!
    }
    
    public static func dismiss() {
        current?.dismiss(animated: true, completion: {
            current = nil
        })
    }
    
}

internal extension LoginUI.Event.Key {
    static var onTappedLogin: LoginUI.Event.Key {
        return "onTappedLogin"
    }
    static var onTappedSignup: LoginUI.Event.Key {
        return "onTappedSignup"
    }
    static var onTappedForgotPassword: LoginUI.Event.Key {
        return "onTappedForgotPassword"
    }
    static var onPasswordInconsistent: LoginUI.Event.Key {
        return "onPasswordInconsistent"
    }
    static var onDismiss: LoginUI.Event.Key {
        return "onDismiss"
    }
    static var lockButtons: LoginUI.Event.Key {
        return "lockButtons"
    }
    static var unlockButtons: LoginUI.Event.Key {
        return "unlockButtons"
    }
}
 
