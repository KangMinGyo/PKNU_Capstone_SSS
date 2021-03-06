//
//  NoHelmetViewController.swift
//  Team_SSS
//
//  Created by KangMingyo on 2022/05/06.
//

import UIKit
import AVKit
import Alamofire
import AVFoundation
import MobileCoreServices
import Toast_Swift // 토스트

class NoHelmetViewController: UIViewController {
    
    let imgPickerController = UIImagePickerController()
    
    var videoURL: URL?
    var thumbnailImage: UIImage?
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPickerController.delegate = self
    }
    
    //앨범에서 video 가져오는 버튼
    @IBAction func addImageButton(_ sender: UIButton) {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        
    }
    
    //카메라로 video 촬영
    @IBAction func cameraButton(_ sender: UIButton) {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .camera
        camera.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        self.present(camera, animated: true, completion: nil)
    }
    
    //신고하기 버튼
    @IBAction func reportButtonClicked(_ sender: UIBarButtonItem) {
        self.view.makeToast("신고가 완료되었습니다!", duration: 1.0, position: .center)
        do {
            print("videoURL : \(videoURL!)")
            uploadImage(imageURL: videoURL!)
        } catch {
            
        }
        //1초 후 실행
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//동영상 서버로 전달해주는 코드
func uploadImage(imageURL: URL?) {
        
        let URL = "http://127.0.0.1:8000/uploadfiles"
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"]
    
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imageURL!, withName: "files", fileName: "video.mp4", mimeType: "video/mp4")
        
    }, to: URL, usingThreshold: UInt64.init(), method: .post, headers: header).response { response in
        guard let statusCode = response.response?.statusCode,
              statusCode == 200
        else { return }
    }
}

//앨범에서 동영상 가져오는거 도와주는 코드
enum VideoHelper {
  static func startMediaBrowser(
    delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate,
    sourceType: UIImagePickerController.SourceType
  ) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType)
      else { return }

    let mediaUI = UIImagePickerController()
    mediaUI.sourceType = sourceType
    mediaUI.mediaTypes = [kUTTypeMovie as String]
    mediaUI.allowsEditing = true
    mediaUI.delegate = delegate
    delegate.present(mediaUI, animated: true, completion: nil)
  }
}

extension NoHelmetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let pickedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            videoURL = pickedVideo
            
            //Thumbnail
            let myAsset = AVAsset(url: pickedVideo)
            let imageGenerator = AVAssetImageGenerator(asset: myAsset)
            let time: CMTime = CMTime(value: 600, timescale: 600)
            guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else { fatalError() }
            let uiImage = UIImage(cgImage: cgImage)
            thumbnailImage = uiImage
            thumbnailImageView.image = uiImage
            videoCountLabel.text = "1/1"
        
        }
        
        //동영상 저장
        if let url = info[.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(savedVideo), nil)
                }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func savedVideo(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
                if let error = error {
                    print(error)
                    return
                }
                print("success")
    }
}
