//
//  Downloader+URLSessionDelegate.swift
//  FileStreamer
//
//  Created by Syed Haris Ali on 1/6/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import os.log

extension Downloader: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line)

        completionHandler(.performDefaultHandling, nil)
    }
}

extension Downloader: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line)
        
        totalBytesLength = response.expectedContentLength
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line, data.count)

        totalBytesReceived += Int64(data.count)
        progress = Float(totalBytesReceived) / Float(totalBytesLength)
        delegate?.download(self, didReceiveData: data, progress: progress)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line)

        state = .completed
        delegate?.download(self, completedWithError: error)
        completionHandler?(error)
    }
}