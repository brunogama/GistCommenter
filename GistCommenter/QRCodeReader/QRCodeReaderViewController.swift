//
//  QRCodeReaderViewController.swift
//  GistCommenter
//
//  Created Bruno Gama on 21/03/2018.
//  Copyright © 2018 Bruno Gama. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import AVFoundation
import UIKit

internal final class QRCodeReaderViewController: UIViewController,
                                               QRCodeReaderViewProtocol {

	var presenter: QRCodeReaderPresenterProtocol?
    @IBOutlet private weak var statusLabel: UILabel!
    var qrCodeViewFinder: UIView?
    override var title: String? {
        didSet {
            statusLabel.text = title
        }
    }

    // MARK: Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()

        setupViews()
        self.title = L10n.detecting
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    // MARK: - QRCodeReaderViewProtocol

    func loading() {
        self.title = L10n.detecting
        qrCodeViewFinder?.frame = CGRect.zero
    }

    func presentCameraPermissionWarning() {
        self.title = L10n.cameraNotAvailable

        let alert = alerController(L10n.alertTitleCameraPermission, L10n.alertMessageCameraPermission)

        let action = UIAlertAction(title: L10n.settings, style: .default) { _ in
            guard let appSettings = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }

            UIApplication.shared.canOpenURL(appSettings)
        }

        alert.addAction(action)

        let cancel = UIAlertAction(title: L10n.ok, style: .cancel)
        alert.addAction(cancel)

        self.present(alert, animated: true)
    }

    func showGistAlert() {
        let alert = alerController(L10n.detectedQRCode, L10n.validQrCodeMessage)

        let action = UIAlertAction(title: L10n.openGist, style: .default) { _ in Logger.d("Open next screen") }
        let cancel = UIAlertAction(title: L10n.ok, style: .cancel) { _ in self.presenter?.newReading() }

        alert.addAction(action)
        alert.addAction(cancel)

        self.present(alert, animated: true)
    }

    func showInvalidCodeAlert() {
        let alert = alerController(L10n.detectedQRCode, L10n.invalidQrCodeMessage)
        let cancel = UIAlertAction(title: L10n.ok, style: .cancel) { _ in self.presenter?.newReading() }

        alert.addAction(cancel)

        present(alert, animated: true)
    }

    func updateStatus(codeValue: String) {
        self.title = codeValue
    }

    func updateViewFinder(area: CGRect) {
        qrCodeViewFinder?.frame = area
    }

    // MARK: - Private methods

    fileprivate func alerController(_ title: String, _ message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }

    fileprivate func setupQrViewFinder() {
        qrCodeViewFinder = UIView()

        if let qrCodeViewFinder = qrCodeViewFinder {
            qrCodeViewFinder.layer.borderColor = UIColor.orange.cgColor
            qrCodeViewFinder.layer.borderWidth = 2
            self.view.addSubview(qrCodeViewFinder)
            self.view.bringSubview(toFront: qrCodeViewFinder)
        }
    }

    fileprivate func setupViews() {

        setupQrViewFinder()

        if let preview = presenter?.interactor?.codeReader?.videoPreview {
            preview.frame = view.layer.bounds
            self.view.layer.addSublayer(preview)
        }

        self.view.bringSubview(toFront: statusLabel)
        setupQrViewFinder()
    }
}
