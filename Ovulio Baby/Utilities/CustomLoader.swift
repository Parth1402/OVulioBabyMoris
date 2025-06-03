//
//  CustomLoader.swift
//  Ovulio Baby
//
//  Created by USER on 17/04/25.
//

import Foundation

import UIKit

class PinkCircleLoader: UIView {

    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupCircle()
        startAnimating()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircle()
        startAnimating()
    }

    private func setupCircle() {
        let lineWidth: CGFloat = 6
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi / 2,
            clockwise: true
        )

        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor(hex: "#FF76B7")?.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0.7
        layer.addSublayer(shapeLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        setupCircle()
    }

    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        layer.add(rotation, forKey: "rotate")
    }
}

extension UIViewController {

    func showCustomLoader() {
        // Avoid duplicates
        guard view.viewWithTag(9999) == nil else { return }

        // Background with pink pattern
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor(hex: "#FF76B7")
        backgroundView.tag = 9999

        // Optionally set image background (hearts)
        if let pattern = UIImage(named: "homeScreenBackground") { // Replace with your background
            backgroundView.backgroundColor = UIColor(patternImage: pattern)
        }

        view.addSubview(backgroundView)

        // Loader
        let loader = PinkCircleLoader(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        loader.center = CGPoint(x: view.center.x, y: view.center.y - 20)
        backgroundView.addSubview(loader)

        // Label
        let label = UILabel()
        label.text = "Generating names"
        label.textColor = appColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: loader.frame.maxY + 16, width: view.frame.width, height: 22)
        label.center.x = view.center.x
        backgroundView.addSubview(label)
    }

    func hideCustomLoader() {
        view.viewWithTag(9999)?.removeFromSuperview()
    }
}
