//
//  PostViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 13.05.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import MapKit

class PostViewController: UIViewController, PassCoordinatesDelegate {

    @IBOutlet weak var postContent: UITextView!
    var postID = 0
    var coordinates: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Стиль окна ввода текста
        postContent.layer.borderWidth = 1.0
        postContent.layer.cornerRadius = 5.0
        postContent.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // Размещение поста по нажанию кнопки
    @IBAction func sendPost(_ sender: Any) {
        if !postContent.text.isEmpty {
            SendPost.send(text: postContent.text, coordinates: coordinates) { [weak self] postID in
                self?.postID = postID
            }
        } else {
            showAlertEmptyPost()
        }
        postContent.text = nil
        coordinates = nil
        showAlertSentPost()
    }
    func showAlertSentPost() {
        let alert = UIAlertController(title: "Пост отправлен", message: "Новый пост размещен на Вашей странице.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertEmptyPost() {
        let alert = UIAlertController(title: "Текст сообщения пуст", message: "Пожалуйста, введите текст сообщения.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  
    // Полученние координат из MapViewController
    @IBAction func addLocation(_ sender: Any) { }
    func passCoordinates(coordinates: CLLocation?) {
        self.coordinates = coordinates
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.addLocation {
            let sendingVC: MapViewController = segue.destination as! MapViewController
            sendingVC.delegate = self
        }
    }
    
    // MARK: - LogOff
    
    @IBAction func logOff(_ sender: Any) {
        AuthorizationViewController.logOff(self)
        self.dismiss(animated: true, completion: nil)
    }
    
}
