//
//  NewBeersGradesViewController.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import UIKit

class NewBeerGradeViewController: UIViewController {
    
    @IBOutlet weak var imageBeerGrade: UIImageView!
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    private let beersGradesStorageModel: BeerGradeStorageModel
    public var imageIsChanged = false
    
    public var brewery: ManagedBrewery?
    
    init(beersGradesStorageModel: BeerGradeStorageModel) {
        self.beersGradesStorageModel = beersGradesStorageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTexField.delegate = self
        descriptionTextField.delegate = self
        setupTapGestureRecognizer()
        setupNavigationItem()
        nameTexField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBeer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageBeerGrade.addGestureRecognizer(tapGestureRecognizer)
        imageBeerGrade.isUserInteractionEnabled = true
    }
    
    @objc func saveBeer() {
        var image: UIImage?
        guard let brewery = brewery else { return }
        if imageIsChanged {
            image = imageBeerGrade.image
        } else {
            image = UIImage(named: Constants.imageBeer)
        }
        
        let imageData = image?.pngData()
        
        let beerGrade = BeerGrade(name: nameTexField.text, description: descriptionTextField.text, image: imageData)
        
        beersGradesStorageModel.saveBeerGrade(beerGrade: beerGrade, brewery: brewery)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBeers"), object: nil)
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

extension NewBeerGradeViewController: UITextFieldDelegate {
    
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

extension NewBeerGradeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        imageBeerGrade.image = info[.editedImage] as? UIImage
        imageBeerGrade.contentMode = .scaleAspectFill
        imageBeerGrade.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
