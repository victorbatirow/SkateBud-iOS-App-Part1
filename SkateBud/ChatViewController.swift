//
//  ChatViewController.swift
//  SkateBud
//
//  Created by Victor on 2022-10-27.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ChatViewController: UIViewController {

    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var imagePartner: UIImage!
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height:36))
    var topLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    var partnerUsername: String!
    var partnerId: String!
    var placeholderLabel = UILabel()
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        setupInputContainer()
        setupNavigationBar()
        setupTableView()
        observeMessages()
        // Do any additional setup after loading the view.
    }
    
    func observeMessages() {
        Api.Message.receiveMessage(from: Api.User.currentUserId, to: partnerId) { (message) in
            print(message.id)
        }
        Api.Message.receiveMessage(from: partnerId, to: Api.User.currentUserId) { (message) in
            print(message.id)
        }
    }
    
    func setupPicker() {
        picker.delegate = self
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func setupInputContainer() {
        let mediaImg = UIImage(named: "attachment_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        mediaButton.setImage(mediaImg, for: UIControl.State.normal)
        mediaButton.tintColor = .lightGray
        
        let micImg = UIImage(named: "microphone_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        audioButton.setImage(micImg, for: UIControl.State.normal)
        audioButton.tintColor = .lightGray
        
        setupInputTextView()
    }
    
    func setupInputTextView() {
       
        inputTextView.delegate = self
        
        placeholderLabel.isHidden = false
        let placeholderX: CGFloat = self.view.frame.size.width / 75
        let placeholderY: CGFloat = 0
        let placeholderWidth: CGFloat = inputTextView.bounds.width - placeholderX
        let placeholderHeight: CGFloat = inputTextView.bounds.height
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLabel.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        placeholderLabel.text = "Write a message"
        placeholderLabel.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.textAlignment = .left
        
        inputTextView.addSubview(placeholderLabel)
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let containView = UIView(frame: CGRect(x: 0, y:  0, width: 36, height: 36))
        avatarImageView.image = imagePartner
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        containView.addSubview(avatarImageView)
        
        let rightBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        
        let attributed = NSMutableAttributedString(string: partnerUsername + "\n" , attributes: [.font : UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
        
        attributed.append(NSAttributedString(string: "Active", attributes: [.font : UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.green]))
        topLabel.attributedText = attributed
        
        self.navigationItem.titleView = topLabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendButtonDidTapped(_ sender: Any) {
        if let text = inputTextView.text, text != "" {
            inputTextView.text = ""
            self.textViewDidChange(inputTextView)
            sendToFirebase(dict: ["text": text as Any])
        }
    }
    
    @IBAction func mediaButtonDidTapped(_ sender: Any) {
        // Create alert
        let alert = UIAlertController(title: "SkateBud", message: "Select source", preferredStyle: UIAlertController.Style.actionSheet)
        
        // Create alert action: camera
        let camera = UIAlertAction(title: "Take a Picture", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        // Create alert action: library
        let library = UIAlertAction(title: "Choose an Image or a Video", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes =  [String(kUTTypeImage), String(kUTTypeMovie)]
                
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        // Create alert action: video camera
        let videoCamera = UIAlertAction(title: "Take a Video", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.picker.mediaTypes = [String(kUTTypeMovie)]
                self.picker.videoExportPreset = AVAssetExportPresetPassthrough
                self.picker.videoMaximumDuration = 30
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        // Create alert action: cancel
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        // Add actionds to alert
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        alert.addAction(videoCamera)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func sendToFirebase(dict: Dictionary<String, Any>) {
        let date: Double = Date().timeIntervalSince1970
        var value = dict
        value["from"] = Api.User.currentUserId
        value["to"] = partnerId
        value["date"] = date
        value["read"] = true
        
        Api.Message.sendMessage(from: Api.User.currentUserId, to: partnerId, value: value)
    }
    

}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            let text = textView.text.trimmingCharacters(in: spacing)
            sendButton.isEnabled = true
            sendButton.setTitleColor(.black, for: UIControl.State.normal)
            placeholderLabel.isHidden = true
        } else {
            sendButton.isEnabled = false
            sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
            placeholderLabel.isHidden = false
        }
    }
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl  = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            handleVideoSelectedForUrl(videoUrl)
        } else {
            handleImageSelectedForInfo(info)
        }
    }
    
    func handleVideoSelectedForUrl(_ url: URL) {
        // save video data
        let videoName = NSUUID().uuidString
        StorageService.saveVideoMessage(url: url, id: videoName, onSuccess: { (anyValue) in
            if let dict = anyValue as? [String: Any] {
                self.sendToFirebase(dict: dict)
            }
        }) { (errorMessage) in
            
        }
        
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = imageOriginal
        }
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = imageSelected
        }
        
        // save photo data
        let imageName = NSUUID().uuidString
        StorageService.savePhotoMessage(image: selectedImageFromPicker, id: imageName, onSuccess: { (anyValue) in
            if let dict = anyValue as? [String: Any] {
                self.sendToFirebase(dict: dict)
            }
        }) { (errorMessage) in
            
        }
        
        self.picker.dismiss(animated: true, completion: nil)
    }
}
