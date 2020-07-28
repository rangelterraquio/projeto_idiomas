//
//  CameraHandler.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//


import Foundation
import UIKit
import MobileCoreServices

class CamereHandler: NSObject{
    
    var currentVC: UIViewController!
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((URL) -> Void)?
    func camera(){
        //verifico se a câmera está disponível
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.allowsEditing = true
            //seta qual será o delagate do myPickerController
            //Usamos esses dois delagates para capturar a imagem escolhida pelo app
            myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            //seto qual será o tipo de dado (camera/photo libary/saephotosToalbum)
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeImage as String]
            //[UIImagePickerController.availableMediaTypes(for: .camera)]
            currentVC.present(myPickerController, animated: true, completion: nil)
            
        }
        
    }
    
   
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func editPhoto(){
         let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
       
    }
    
    func shwActionSheet(vc: UIViewController){
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
        
    }
    

    func savePhotosToGallery(imageView: UIImage?){
        guard let image = imageView else {
            return
        }
        let img = image.pngData()
        let compress = UIImage(data: img!)
        UIImageWriteToSavedPhotosAlbum(compress!, nil, nil, nil)
        let alert = UIAlertController(title: "Saved", message: "Photo saved with sucess", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        currentVC.present(alert, animated: true, completion: nil)
       
    }
    func saveVideoToGallery(video: URL?){
        if let videoURL = (video) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, nil, nil, nil)
            
        }
    }

}

extension CamereHandler: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    //Chamado após uma foto ser tirada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("entrou aqui apos salvar na galeria")
            self.imagePickedBlock?(image)
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    
}
