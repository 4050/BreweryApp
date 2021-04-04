//
//  NewBreweryViewController.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import UIKit

class NewBreweryViewController: UIViewController {

    @IBOutlet weak var imageBreweries: UIImageView!
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    private let breweryStorageModel: BreweryStorageModel
    public var imageIsChanged = false
    
    init(breweryStorageModel: BreweryStorageModel) {
        self.breweryStorageModel = breweryStorageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageBreweries.isUserInteractionEnabled = true
        nameTexField.delegate = self
        descriptionTextField.delegate = self
        setupTapGestureRecognizer()
        setupNavigationItem()
        nameTexField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBrewery))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageBreweries.addGestureRecognizer(tapGestureRecognizer)
        imageBreweries.isUserInteractionEnabled = true
    }
    
    @objc func saveBrewery() {
        var image: UIImage?
        
        if imageIsChanged {
            image = imageBreweries.image
        } else {
            image = UIImage(named: Constants.imageBrewery)
        }
        
        let imageData = image?.pngData()
        
        let brewery = Brewery(name: nameTexField.text, description: descriptionTextField.text, image: imageData)
        
        breweryStorageModel.saveBrewery(brewery: brewery)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBreweries"), object: nil)
        dismiss(animated: true)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}

extension NewBreweryViewController: UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if nameTexField.text?.isEmpty == false {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

extension NewBreweryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageBreweries.image = info[.editedImage] as? UIImage
        imageBreweries.contentMode = .scaleAspectFill
        imageBreweries.clipsToBounds = true
     
        imageIsChanged = true
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
