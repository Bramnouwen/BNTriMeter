//
//  TestViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 14/10/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/*
 SOURCES
 Uploading to storage: https://www.youtube.com/watch?v=Bd4-6pnjjd8
 */

import UIKit
import MobileCoreServices
import Firebase
import FBSDKLoginKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.applyGradient()
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            FBSDKAccessToken.setCurrent(nil)
            performSegue(withIdentifier: "toLogin", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func testButtonClicked(_ sender: Any) {
        // Test something
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Upload image or movie
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadImageToFirebaseStore(data: Data) {
        let storageRef = Storage.storage().reference(withPath: "images/demoPic.jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        let uploadTask = storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                print("I received an error! \(error.localizedDescription)")
            } else if let metadata = metadata {
                print("Upoad complete! Here's some metadata! \(metadata)")
                print("Here's your download URL: \(metadata.downloadURL()?.absoluteString ?? "N/A")")
            }
        }
        // Update the progress bar
        uploadProgressBar(uploadTask)
    }
    
    func uploadMovieToFirebaseStorage(url: URL) {
        let storageRef = Storage.storage().reference(withPath: "videos/demoVideo.mov")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "video/quicktime"
        let uploadTask = storageRef.putFile(from: url, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                print("I received an error! \(error.localizedDescription)")
            } else if let metadata = metadata {
                print("Upoad complete! Here's some metadata! \(metadata)")
                print("Here's your download URL: \(metadata.downloadURL()?.absoluteString ?? "N/A")")
            }
        }
        // Update the progress bar
        uploadProgressBar(uploadTask)
    }
    
    func uploadProgressBar(_ uploadTask: StorageUploadTask) {
        uploadTask.observe(.progress) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            guard let progress = snapshot.progress else { return }
            strongSelf.progressView.progress = Float(progress.fractionCompleted)
        }
    }
}


extension TestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType: String = info[UIImagePickerControllerMediaType] as? String else {
            dismiss(animated: true, completion: nil)
            return
        }
        if mediaType == (kUTTypeImage as String) {
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let imageData = UIImageJPEGRepresentation(originalImage, 0.8) {
                uploadImageToFirebaseStore(data: imageData)
            }
        } else if mediaType == (kUTTypeMovie as String) {
            if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
                uploadMovieToFirebaseStorage(url: videoURL)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
