//
//  DogImageLibraryTests.swift
//  DogImageLibraryTests
//
//  Created by Bhawanisingh Rao on 15/08/24.
//

import XCTest
@testable import DogImageLibrary


class DogImageFetcherTests: XCTestCase {
    
    var dogImageFetcher: DogImageFetcher!
    var mockDelegate: MockDogImageDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockDogImageDelegate()
        dogImageFetcher = DogImageFetcher()
        dogImageFetcher.delegate = mockDelegate
    }
    
    override func tearDown() {
        dogImageFetcher = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testGetImage_WithImages_ShouldReturnFirstImage() {
        // Given
        let expectedImage = UIImage()
        dogImageFetcher.images = [expectedImage]
        
        // When
        let expectation = self.expectation(description: "Image Fetch")
        dogImageFetcher.getImage { image in
            // Then
            XCTAssertEqual(image, expectedImage)
            XCTAssertEqual(self.dogImageFetcher.currentIndex, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetNextImage_ShouldReturnNextImage() {
        // Given
        let image1 = UIImage()
        let image2 = UIImage()
        dogImageFetcher.images = [image1, image2]
        dogImageFetcher.currentIndex = 0
        
        // When
        let expectation = self.expectation(description: "Next Image Fetch")
        dogImageFetcher.getNextImage { image in
            // Then
            XCTAssertEqual(image, image2)
            XCTAssertEqual(self.dogImageFetcher.currentIndex, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPreviousImage_ShouldReturnPreviousImage() {
        // Given
        let image1 = UIImage()
        let image2 = UIImage()
        let image3 = UIImage()
        dogImageFetcher.images = [image1, image2,image3]
        dogImageFetcher.currentIndex = 2
        
        // When
        let (image, isEnable) = dogImageFetcher.getPreviousImage()
        
        // Then
        XCTAssertEqual(image, image2)
        XCTAssertTrue(isEnable)
        XCTAssertEqual(dogImageFetcher.currentIndex, 1)
        
        
    }
    
    func testGetImage_WithNoImages_ShouldFetchImageFromService() {
        // Given
        let data = """
{
    "message":"star.fill",
    "status": "success"
}
""".data(using: .utf8)
        do {
            let successResponse = try JSONDecoder().decode(DogImage.self, from: data!)
            DogImageServiceMock.result = .success(successResponse)
            
            // When
            let expectation = self.expectation(description: "Multiple Image Fetch")
            dogImageFetcher.getImage { image in
                // Then
                XCTAssertNotNil(image)
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 1, handler: nil)
        } catch {
            print("Failed to decode DogImage: \(error)")
        }
    }
    
    func testGetPreviousImage_AtFirstImage_ShouldDisablePreviousButton() {
        // Given
        let image = UIImage()
        let image1 = UIImage()
        dogImageFetcher.images = [image,image1]
        dogImageFetcher.currentIndex = 1
        
        // When
        let (returnedImage, isEnable) = dogImageFetcher.getPreviousImage()
        
        // Then
        XCTAssertEqual(returnedImage, image)
        XCTAssertFalse(isEnable)
    }
    
    func testGetImage_WithMultipleImages_ShouldFetchMultipleImages() {
        // Given
        let data = """
    {
        "message": [
            "star.fill",
            "bell"
        ],
        "status": "success"
    }
""".data(using: .utf8)
        do {
            let successResponse = try JSONDecoder().decode(DogImage.self, from: data!)
            DogImageServiceMock.result = .success(successResponse)
            
            // When
            let expectation = self.expectation(description: "Multiple Image Fetch")
            dogImageFetcher.getImage(number: 2) { images in
                // Then
                XCTAssertEqual(images?.count, 2)
                XCTAssertNotNil(images?.first!)
                XCTAssertNotNil(images?.last!)
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 1, handler: nil)
        } catch {
            print("Failed to decode DogImage: \(error)")
        }
    }
}

