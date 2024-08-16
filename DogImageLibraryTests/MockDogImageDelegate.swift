//
//  MockDogImageDelegate.swift
//  DogImageLibraryTests
//
//  Created by Bhawanisingh Rao on 16/08/24.
//

import DogImageLibrary

class MockDogImageDelegate: DogImageDelegate {
    var showLoaderCalled = false
    var didReceiveErrorCalled = false
    var lastErrorMessage: String?
    
    func showHideloader(_ loading: Bool) {
        showLoaderCalled = loading
    }
    
    func didRecieveError(msg: String) {
        didReceiveErrorCalled = true
        lastErrorMessage = msg
    }
}

