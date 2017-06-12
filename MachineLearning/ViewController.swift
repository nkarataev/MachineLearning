//
//  ViewController.swift
//  MachineLearning
//
//  Created by Karataev Nikolay on 12.06.17.
//  Copyright © 2017 Karataev Nikolay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    let model = Resnet50()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func chooseAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let bounded = ImageProcessor.crop(image: pickedImage, withWidth: Double(pickedImage.size.width), andHeight: Double(pickedImage.size.width))
            let resized = ImageProcessor.RBResizeImage(image: bounded!, targetSize: CGSize(width: 224, height: 224))
            imageView.image = resized
            
            if let labelText = detection(forImage: resized) {
                textLabel.text = labelText
                textLabel.isHidden = false
            } else {
                textLabel.isHidden = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func detection(forImage image:UIImage) -> String? {
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!) {
            guard let scene = try? model.prediction(image: pixelBuffer) else {
                print("nothing")
                return nil
            }
            print(scene)
            return scene.classLabel
        }
        return nil
    }
}

