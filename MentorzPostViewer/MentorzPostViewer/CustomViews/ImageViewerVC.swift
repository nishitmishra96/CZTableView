//
//  ImageViewerVC.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 02/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import SDWebImage
open class ImageViewerVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var image = UIImageView()
    var url : URL?
    var delegate:ImagePickerDelegate?
    override open func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.imagePickerDissmissed()
    }
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
            delegate?.donePressed()
    }
    func initialSetup(){
        imageView.isUserInteractionEnabled = true
        self.scrollView.minimumZoomScale=1;
        self.scrollView.maximumZoomScale=6.0;
        self.scrollView.delegate=self
        self.imageView.image = UIImage(named: "loading_data_logo")
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadImage(url: url)
        self.scrollView.contentSize = CGSize.init(width: self.image.frame.width, height: self.image.frame.height)
    }
    
    func loadImage(url: URL?){
        if let _ = url{
            self.image.sd_setImage(with: url) { (image, error, cache, url) in
                if let _ = image{
                    self.imageView.image = image
                }else{
                    self.imageView.image = UIImage(named:"loading_data_logo")
                }
                self.scrollView.contentSize = CGSize.init(width: self.image.frame.width, height: self.image.frame.height)
            }
        }
    }


    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1{
            scrollView.setZoomScale(1, animated: true)
        }else{
            let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
            if scale != scrollView.zoomScale {
                let point = gestureRecognizer.location(in: imageView)

                let scrollSize = scrollView.frame.size
                let size = CGSize(width: scrollSize.width / scale,
                                  height: scrollSize.height / scale)
                let origin = CGPoint(x: point.x - size.width / 2,
                                     y: point.y - size.height / 2)
                scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
                print(CGRect(origin: origin, size: size))
        }
        }
    }

    
}


extension ImageViewerVC:UIScrollViewDelegate{
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
