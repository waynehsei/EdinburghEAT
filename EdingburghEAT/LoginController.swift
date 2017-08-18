//
//  LoginControllerViewController.swift
//  EdingburghEAT
//
//  Created by Wayne on 16/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false // need specified
        
        // round the bounds
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true

        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:80, g:101, b:161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // need specified
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 61, g:91, b:151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        
    }
    
    func setupInputsContainerView(){
        
        // need x, y, width, height constrains for white box
        
        // define the center in teh middle of display
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // 12 center of the left and right
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        // height with 150
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        // add nametextfield
            // need x, y, width, height, constraints - where the textfield should be
            nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
            nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
            // for the name seperator
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
            nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
            // for email
            emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
            emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
            emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
            // for the email seperator
            emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
            emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            // for password
            passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
            passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    
    // setup Button
    func setupLoginRegisterButton(){
        // need x, y, width, height, constraints
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

