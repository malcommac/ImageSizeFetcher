/*
* ImageSizeFetcher
* Finds the type/size of an image given its URL by fetching as little data as needed
*
* Created by:	Daniele Margutti
* Email:		hello@danielemargutti.com
* Web:			http://www.danielemargutti.com
* Twitter:		@danielemargutti
*
* Copyright © 2018 Daniele Margutti
*
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

#if os(macOS)
import AppKit
#else
import UIKit
#endif

internal class ImageSizeFetcherOp: Operation {
	
	/// Callback to call at the end of the operation
	let callback: ImageSizeFetcher.Callback?
	
	/// Request data task
	let request: URLSessionDataTask
	
	/// Partial data
	private(set) var receivedData = Data()
	
	/// URL of the operation
	var url: URL? {
		return self.request.currentRequest?.url
	}
	
	/// Initialize a new operation for a given url.
	///
	/// - Parameters:
	///   - request: request to perform.
	///   - callback: callback to call at the end of the operation.
	init(_ request: URLSessionDataTask, callback: ImageSizeFetcher.Callback?) {
		self.request = request
		self.callback = callback
	}
	
	///MARK: - Operation Override Methods
	
	override func start() {
		guard !self.isCancelled else { return }
		self.request.resume()
	}
	
	override func cancel() {
		self.request.cancel()
		super.cancel()
	}
	
	//MARK: - Internal Helper Methods
	
	func onReceiveData(_ data: Data) {
		guard !self.isCancelled else { return }
		self.receivedData.append(data)
		
		// not enough data collected for anything
		guard data.count >= 2 else { return }
		
		// attempt to parse received data, if enough we can stop download
		do {
			if let result = try ImageSizeFetcherParser(sourceURL: self.url!, data) {
				self.callback?(nil,result)
				self.cancel()
			}
			// nothing received, continue accumulating data
		} catch let err { // parse has failed
			self.callback?(err,nil)
			self.cancel()
		}
	}
	
	func onEndWithError(_ error: Error?) {
		// download has failed, return to callback with the description of the error
		self.callback?(ImageParserErrors.network(error),nil)
		self.cancel()
	}
	
}
