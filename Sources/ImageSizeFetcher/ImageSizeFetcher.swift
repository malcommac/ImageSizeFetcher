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

public class ImageSizeFetcher: NSObject, URLSessionDataDelegate {
	
	/// Callback type alias
	public typealias Callback = ((Error?, ImageSizeFetcherParser?) -> (Void))
	
	/// URL Session used to download data
	private var session: URLSession!
	
	/// Queue of active operations
	private var queue = OperationQueue()
	
	/// Built-in in memory cache
	private var cache = NSCache<NSURL,ImageSizeFetcherParser>()
	
	/// Request timeout
	public var timeout: TimeInterval
	
	/// Initialize a new fetcher with in memory cache.
	///
	/// - Parameters:
	///   - configuration: url session configuration
	///   - timeout: timeout for request, by default is 5 seconds.
	public init(configuration: URLSessionConfiguration = .ephemeral, timeout: TimeInterval = 5) {
		self.timeout = timeout
		super.init()
		self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}
	
	/// Request for image info at given url.
	///
	/// - Parameters:
	///   - url: url of the image you want to analyze.
	///   - force: true to skip cache and force download.
	///   - callback: completion callback called to give out the result.
	public func sizeFor(atURL url: URL, force: Bool = false, _ callback: @escaping Callback) {
		guard force == false, let entry = cache.object(forKey: (url as NSURL)) else {
			// we don't have a cached result or we want to force download
			let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.timeout)
			let op = ImageSizeFetcherOp(self.session.dataTask(with: request), callback: callback)
			queue.addOperation(op)
			return
		}
		// return result from cache
		callback(nil,entry)
	}
	
	//MARK: - Helper Methods
	
	private func operation(forTask task: URLSessionTask?) -> ImageSizeFetcherOp? {
		return (self.queue.operations as! [ImageSizeFetcherOp]).first(where: { $0.url == task?.currentRequest?.url })
	}
	
	//MARK: - URLSessionDataDelegate
	
	public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		operation(forTask: dataTask)?.onReceiveData(data)
	}
	
	public func urlSession(_ session: URLSession, task dataTask: URLSessionTask, didCompleteWithError error: Error?) {
		operation(forTask: dataTask)?.onEndWithError(error)
	}
	
}
