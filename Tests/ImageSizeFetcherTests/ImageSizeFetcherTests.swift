//
//  ImageSizeFetcherTests.swift
//  ImageSizeFetcher
//
//  Created by Daniele Margutti on 08/09/2018.
//  Copyright © 2018 ImageSizeFetcher. All rights reserved.
//

import Foundation
import XCTest
import ImageSizeFetcher

class ImageTestSource {
	var url: URL
	var expectedSize: CGSize
	
	public init(_ url: String, expSize: CGSize) {
		self.url = URL(string: url)!
		self.expectedSize = expSize
	}
	
	public func validate(with parser: ImageSizeFetcherParser?) -> Bool {
		guard let p = parser else { return false }
		return (p.size.equalTo(self.expectedSize))
	}
}

class ImageSizeFetcherTests: XCTestCase {
	
	let fetcher = ImageSizeFetcher()
	var testImages: [ImageTestSource] = []

	func random(from lower: UInt32, to upper: UInt32) -> CGFloat {
		let randomNumber = arc4random_uniform(upper - lower) + lower
		return CGFloat(randomNumber)
	}
	
	func generateImagesWithDummyImage(_ count: Int = 5, extension: String, in dest: inout [ImageTestSource]) {
		for _ in 0..<count {
			let size = CGSize(width: random(from: 50, to: 500), height: random(from: 50, to: 500))
			dest.append(ImageTestSource("https://dummyimage.com/\(Int(size.width))x\(Int(size.height)).png", expSize: size))
		}
	}
	
    func testFetcher() {
		let expectation = XCTestExpectation(description: "Download apple.com home page")

		generateImagesWithDummyImage(extension: "png", in: &self.testImages)
		generateImagesWithDummyImage(extension: "jpg", in: &self.testImages)
		generateImagesWithDummyImage(extension: "gif", in: &self.testImages)
		generateImagesWithDummyImage(extension: "bmp", in: &self.testImages)

		var remainingToCheck: Int = self.testImages.count
		
		print("Test will check \(remainingToCheck) images...")
		
		self.testImages.forEach {
			fetcher.sizeFor(atURL: $0.url) { (err, result) in
				if let op = self.testImages.first(where: { result?.sourceURL.absoluteString == $0.url.absoluteString }) {
					remainingToCheck -= 1
					if op.validate(with: result) == false {
						if result == nil {
							XCTFail("Failed to download image: \(err?.localizedDescription ?? "Unknnown error")")
						}
						XCTFail("Failed getting size of \(result!.sourceURL.absoluteString). Expected \(NSStringFromCGSize(op.expectedSize)), got \(NSStringFromCGSize(result!.size))")
					}
					if remainingToCheck == 0 {
						expectation.fulfill()
					}
					print("Image \(op.url.absoluteString) checked with \(result!.downloadedData) bytes, \(remainingToCheck) images remaining to check")
				}
			}
		}

		wait(for: [expectation], timeout: 60.0)
    }
    
    static var allTests = [
        ("testFetcher", testFetcher),
    ]
}
