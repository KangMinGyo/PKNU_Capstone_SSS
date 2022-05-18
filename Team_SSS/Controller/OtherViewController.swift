//
//  OtherViewController.swift
//  Team_SSS
//
//  Created by KangMingyo on 2022/05/07.
//

import UIKit
import AVKit
import Alamofire
import AVFoundation
import MobileCoreServices

class OtherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var videoURL: URL?
    var thumbnailImage: UIImage?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoCountLabel: UILabel!
    
    let pickerData = ["원동기장치자전거면허 미소지", "(야간)야광띠 발광장치 미착용", "위험한 전동킥보드 운전", "어린이 운전금지", "초과탑승"]
    var pickerHide = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    //버튼 클릭하면 picker view
    @IBAction func pickerButton(_ sender: UIButton) {
        if pickerHide == true {
            pickerView.isHidden = false
            pickerHide = false
        } else {
            pickerView.isHidden = true
            pickerHide = true
        }
    }
    
    //PickerView 관련
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        otherLabel.text = pickerData[row]
        pickerView.isHidden = true
        pickerHide = true
    }
    
    //앨범에서 video 가져오는 버튼
    @IBAction func addImageButton(_ sender: UIButton) {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
    
    //신고하기 버튼
    @IBAction func reportButton(_ sender: UIBarButtonItem) {
        self.view.makeToast("신고가 완료되었습니다!", duration: 1.0, position: .center)
        do {
            otherViewUploadImage(imageURL: videoURL!)
        } catch {
            
        }
        //1초 후 실행
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//동영상 서버로 전달해주는 코드
func otherViewUploadImage(imageURL: URL?) {
        
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
enum otherViewVideoHelper {
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

extension OtherViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    }
}
