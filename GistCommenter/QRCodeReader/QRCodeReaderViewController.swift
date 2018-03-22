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
    var codeReader: QRCodeReadable?
    private var hasCameraPermissions: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    @IBOutlet weak var statusLabel: UILabel!

    var qrCodeViewFinder: UIView?

    public override func viewDidLoad() {
        super.viewDidLoad()

        codeReader?.startReading { urlString, barCodeBounds in
            self.updateStatusLabelAndTitle(urlString)
            self.qrCodeViewFinder?.frame = barCodeBounds
        }

        setupViews()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateStatusLabelAndTitle(L10n.detecting)
        if !hasCameraPermissions {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    Logger.w("Denied camera permissions")
                    self.presentCameraPermissionWarning()
                }
            }
        }
    }

    // MARK: - Private methods

    fileprivate func setupQrViewFinder() {
        self.qrCodeViewFinder = UIView()

        if let qrCodeViewFinder = qrCodeViewFinder {
            qrCodeViewFinder.layer.borderColor = UIColor.orange.cgColor
            qrCodeViewFinder.layer.borderWidth = 2
            self.view.addSubview(qrCodeViewFinder)
            self.view.bringSubview(toFront: qrCodeViewFinder)
        }
    }

    internal func updateStatusLabelAndTitle(_ title: String) {
        statusLabel.text = title
        self.title = statusLabel.text
    }

    fileprivate func setupViews() {

        setupQrViewFinder()

        if let preview = codeReader?.videoPreview {
            preview.frame = view.layer.bounds
            self.view.layer.addSublayer(preview)
        }

        self.view.bringSubview(toFront: statusLabel)
        setupQrViewFinder()
    }

    // MARK: - QRCodeReaderViewProtocol

    func presentCameraPermissionWarning() {
        self.updateStatusLabelAndTitle(L10n.cameraNotAvailable)

        let alert = UIAlertController(title: L10n.alertTitleCameraPermission,
                                      message: L10n.alertMessageCameraPermission,
                                      preferredStyle: .alert)

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
}
