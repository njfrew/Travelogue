//
//  SingleTravelogueEntryViewController.swift
//  Travelogue
//
//  Created by Noah Frew on 12/10/20.
//

import UIKit
import CoreData

enum ImageType: String {
    case useCamera = "Take a Picture"
    case usePhotoLibrary = "Browse Photo Library"
}

class SingleTravelogueEntryViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePicker: UIPickerView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var trip: Trip?
    
    var existingTravelogueEntry: TravelogueEntry?
    let dateFormatter = DateFormatter()
    var imageType: ImageType = .useCamera
    let imagePickerController = UIImagePickerController()
    let pickerData = [ImageType.useCamera.rawValue, ImageType.usePhotoLibrary.rawValue]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        contentTextView.delegate = self
        
        imagePicker.delegate = self
        imagePicker.dataSource = self
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        title = existingTravelogueEntry?.title
        titleTextField.text = existingTravelogueEntry?.title
        contentTextView.text = existingTravelogueEntry?.content
        existingTravelogueEntry?.date = Date()
        imageView.image = existingTravelogueEntry?.image
        
        contentTextView.delegate = self
        contentTextView.isScrollEnabled = false
        contentTextView.layer.cornerRadius = 12.0
        contentTextView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        setupButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    func setupButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SingleTravelogueEntryViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
       
        if (gesture.view as? UIImageView) != nil {
            
            if imageType == .useCamera {
                takePhoto()
            } else {
                navigatePhotos()
            }
        }
    }
    
    // MARK: Photo Setup
    
    func takePhoto() {
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.cameraDevice = .rear

            present(imagePickerController, animated: true)
        } else {
            let alert = UIAlertController(title: nil, message: "Camera Device not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                (alertAction) -> Void in
                return
                
            }))
            present(alert, animated: true)
        }
    }
    
    func navigatePhotos() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }

        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }
    
    // MARK: Picker View Initialization
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return pickerData[row]
      }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            imageType = .useCamera
        } else {
            imageType = .usePhotoLibrary
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    // MARK: Image Picker Controller Setup
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            if let image = imageView.image {
                existingTravelogueEntry?.image = image
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Setup
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !titleTextField.isFirstResponder,
           let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @IBAction func saveTravelogueEntry(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        let date = Date()
        let image = imageView.image

        var travelogueEntry: TravelogueEntry?
        
        if let existingTravelogueEntry = existingTravelogueEntry {
            existingTravelogueEntry.title = title
            existingTravelogueEntry.content = content
            existingTravelogueEntry.date = date
            travelogueEntry = existingTravelogueEntry
        } else {
            travelogueEntry = TravelogueEntry(title: title, content: content, date: date, image: image)
        }
        
        if let travelogueEntry = travelogueEntry {
            trip?.addToRawTravelogueEntries(travelogueEntry)
            
            do {
                try travelogueEntry.managedObjectContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Document could not be created")
            }
        }
    }
    
    @IBAction func titleChanged(_ sender: Any) {
        title = titleTextField.text
    }
}


extension SingleTravelogueEntryViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
