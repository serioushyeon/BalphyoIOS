//
//  ScriptLoadingViewController.swift
//  Balphyo
//
//  Created by jin on 6/15/24.
//

import UIKit

class ScriptLoadingViewController: UIViewController {

    let loadingImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit // 이미지 비율 유지하며 뷰 크기에 맞춤
    }
    
    let instructionLabel = UILabel().then{
        $0.text = "원하시는 시간에 최적화된 대본을 만들어드릴게요"
        $0.textColor = .Primary
        $0.font = UIFont.Title().withSize(14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // GIF 파일 설정
        if let gifURL = Bundle.main.url(forResource: "Loading", withExtension: "gif"),
           let imageData = try? Data(contentsOf: gifURL),
           let gifImage = UIImage.gifImageWithData(imageData) {
            loadingImageView.image = gifImage
        }
        
        addSubView()
        configUI()
        
    }
    private func addSubView(){
        view.addSubview(loadingImageView)
        view.addSubview(instructionLabel)
    }
    private func configUI(){
        loadingImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(132)
            make.height.equalTo(122)
        }
        instructionLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingImageView.snp.bottom)
        }
    }
}

extension UIImage {
    // GIF 데이터를 UIImage로 변환
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("CGImageSourceCreateWithData failed")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }

    // CGImageSource로부터 애니메이션 이미지 생성
    private class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var gifDuration = 0.0

        for i in 0..<count {
            guard let imageRef = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                print("CGImageSourceCreateImageAtIndex failed for index \(i)")
                continue
            }
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any] else {
                continue
            }
            guard let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else {
                continue
            }
            guard let delayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double else {
                continue
            }

            let uiImage = UIImage(cgImage: imageRef)
            images.append(uiImage)
            gifDuration += delayTime
        }

        return UIImage.animatedImage(with: images, duration: gifDuration)
    }
}
