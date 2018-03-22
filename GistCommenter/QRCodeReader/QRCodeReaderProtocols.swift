//
//  QRCodeReaderProtocols.swift
//  GistCommenter
//
//  Created Bruno Gama on 21/03/2018.
//  Copyright © 2018 Bruno Gama. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

// MARK: Wireframe -
internal protocol QRCodeReaderWireframeProtocol: class {

}
// MARK: Presenter -
internal protocol QRCodeReaderPresenterProtocol: class {

    var interactor: QRCodeReaderInteractorInputProtocol? { get set }
}

// MARK: Interactor -
internal protocol QRCodeReaderInteractorOutputProtocol: class {

    /* Interactor -> Presenter */
}

internal protocol QRCodeReaderInteractorInputProtocol: class {

    var presenter: QRCodeReaderInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
}

// MARK: View -
internal protocol QRCodeReaderViewProtocol: class {

    var presenter: QRCodeReaderPresenterProtocol? { get set }
    var codeReader: QRCodeReadable? { get set }

    func presentCameraPermissionWarning()
    /* Presenter -> ViewController */
}
