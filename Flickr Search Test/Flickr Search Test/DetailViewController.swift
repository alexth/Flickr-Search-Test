//
//  DetailViewController.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/17/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage!

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchWith(pinchGestureRecognizer:)))
        imageView.addGestureRecognizer(pinch)
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationWith(rotationGestureRecognizer:)))
        imageView.addGestureRecognizer(rotation)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
    }

    // MARK: Gestures

    func handlePinchWith(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale);
    }

    func handleRotationWith(rotationGestureRecognizer: UIRotationGestureRecognizer) {
        imageView.transform = imageView.transform.rotated(by: rotationGestureRecognizer.rotation);
        rotationGestureRecognizer.rotation = 0.0;
    }
}
