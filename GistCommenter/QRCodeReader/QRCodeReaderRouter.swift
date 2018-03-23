//
//  QRCodeReaderRouter.swift
//  GistCommenter
//
//  Created Bruno Gama on 21/03/2018.
//  Copyright © 2018 Bruno Gama. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

internal class QRCodeReaderRouter: QRCodeReaderWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> QRCodeReaderViewController {

        let view = QRCodeReaderViewController.instantiate()
        let interactor = QRCodeReaderInteractor()
        interactor.codeReader = QRCodeReder()
        let router = QRCodeReaderRouter()
        let presenter = QRCodeReaderPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
