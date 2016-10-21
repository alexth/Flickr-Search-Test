//
//  DetailViewController.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/17/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage!

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchWith(pinch:)))
        imageView.addGestureRecognizer(pinch)
        pinch.delegate = self
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationWith(rotation:)))
        imageView.addGestureRecognizer(rotation)
        rotation.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
    }

    // MARK: Gestures

    func handlePinchWith(pinch: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale);
    }

    func handleRotationWith(rotation: UIRotationGestureRecognizer) {
        imageView.transform = imageView.transform.rotated(by: rotation.rotation);
        rotation.rotation = 0.0;
    }
}
