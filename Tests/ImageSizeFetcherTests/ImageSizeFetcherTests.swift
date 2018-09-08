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

    func testExample() {
		let expectation = XCTestExpectation(description: "Download apple.com home page")

		let images = [
			ImageTestSource("https://zucchitours.com/wp-content/uploads/2018/01/TibetPalace-1250x650.jpg",
							expSize: CGSize(width: 1250, height: 650)),
			ImageTestSource("http://pngimg.com/uploads/microsoft/microsoft_PNG16.png",
							expSize: CGSize(width: 3447, height: 737)),
			ImageTestSource("https://dummyimage.com/301x402.png",
							expSize: CGSize(width: 301, height: 402)),
			ImageTestSource("https://dummyimage.com/301x402.jpg",
							expSize: CGSize(width: 301, height: 402)),
			ImageTestSource("https://dummyimage.com/301x402.gif",
							expSize: CGSize(width: 301, height: 402))
		]
		
		var remainingToCheck: Int = images.count
		
		images.forEach {
			fetcher.imageInfo(atURL: $0.url) { (err, result) in
				if let op = images.first(where: { result?.sourceURL.absoluteString == $0.url.absoluteString }) {
					if op.validate(with: result) == false {
						if result == nil {
							XCTFail("Failed to download image: \(err?.localizedDescription ?? "Unknnown error")")
						}
						XCTFail("Failed getting size of \(result!.sourceURL.absoluteString). Expected \(NSStringFromCGSize(op.expectedSize)), got \(NSStringFromCGSize(result!.size))")
					}
					remainingToCheck -= 1
					if remainingToCheck == 0 {
						expectation.fulfill()
					}
				}
			}
		}

		wait(for: [expectation], timeout: 60.0)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
