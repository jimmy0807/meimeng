//
//  ZixunSelectProjectItemView.swift
//  meim
//
//  Created by jimmy on 2017/7/17.
//
//

import UIKit

class ZixunSelectProjectItemView: UIView, UITableViewDelegate, UITableViewDataSource
{
    enum SectionType : Int
    {
        case member
        case question
        case item
    }
    
    @IBOutlet weak var tableView : UITableView!
    private var sectionDictionary : [Int : SectionType] = [:]
    
    var questionItemIDs : [Int] = []
    var questionItemNames : [String] = []
    
    var member : CDMember?
    var memberID : Int?
    {
        didSet
        {
            if let memberID = self.memberID
            {
                self.member = BSCoreDataManager.current().findEntity("CDMember", withValue: memberID, forKey: "memberID") as? CDMember
                let request = BSFetchMemberDetailRequestN(memberID: memberID as NSNumber)
                request?.execute()
                request?.finished = {[weak self] dict in
                    self?.reloadSectionDictionary()
                }
            }
            else
            {
                self.member = nil
            }
            
            self.reloadSectionDictionary()
        }
    }
    
    lazy var projectItems : [CDProjectItem] = BSCoreDataManager.current().fetchProjectItems(with: kProjectItemDefault, bornCategorys: [kPadBornCategoryProject.rawValue], categoryIds: [], existItemIds: [], keyword: "", priceAscending: true) as! [CDProjectItem]
    
    func reloadSectionDictionary()
    {
        var index = 0
        if questionItemIDs.count > 0
        {
            sectionDictionary[index] = .question
            index += 1
        }
        
        if let count = member?.card?.array.count, count > 0
        {
            sectionDictionary[index] = .member
            index += 1
        }
        
        if projectItems.count > 0
        {
            sectionDictionary[index] = .item
            index += 1
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sectionDictionary.keys.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZixunSelectProjectItemTableViewCell") as! ZixunSelectProjectItemTableViewCell
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20;
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return UIView(frame: CGRect.zero)
    }
    
    /*
     Printing description of js:
     ;(function() { if (window.WebViewJavascriptBridge) { return; } if (!window.onerror) { window.onerror = function(msg, url, line) { console.log("WebViewJavascriptBridge: ERROR:" + msg + "@" + url + ":" + line); } } window.WebViewJavascriptBridge = { registerHandler: registerHandler, callHandler: callHandler, disableJavscriptAlertBoxSafetyTimeout: disableJavscriptAlertBoxSafetyTimeout, _fetchQueue: _fetchQueue, _handleMessageFromObjC: _handleMessageFromObjC }; var messagingIframe; var sendMessageQueue = []; var messageHandlers = {}; var CUSTOM_PROTOCOL_SCHEME = 'https'; var QUEUE_HAS_MESSAGE = '__wvjb_queue_message__'; var responseCallbacks = {}; var uniqueId = 1; var dispatchMessagesWithTimeoutSafety = true; function registerHandler(handlerName, handler) { messageHandlers[handlerName] = handler; } function callHandler(handlerName, data, responseCallback) { if (arguments.length == 2 && typeof data == 'function') { responseCallback = data; data = null; } _doSend({ handlerName:handlerName, data:data }, responseCallback); } function disableJavscriptAlertBoxSafetyTimeout() { dispatchMessagesWithTimeoutSafety = false; } function _doSend(message, responseCallback) { if (responseCallback) { var callbackId = 'cb_'+(uniqueId++)+'_'+new Date().getTime(); responseCallbacks[callbackId] = responseCallback; message['callbackId'] = callbackId; } sendMessageQueue.push(message); messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE; } function _fetchQueue() { var messageQueueString = JSON.stringify(sendMessageQueue); sendMessageQueue = []; return messageQueueString; } function _dispatchMessageFromObjC(messageJSON) { if (dispatchMessagesWithTimeoutSafety) { setTimeout(_doDispatchMessageFromObjC); } else { _doDispatchMessageFromObjC(); } function _doDispatchMessageFromObjC() { var message = JSON.parse(messageJSON); var messageHandler; var responseCallback; if (message.responseId) { responseCallback = responseCallbacks[message.responseId]; if (!responseCallback) { return; } responseCallback(message.responseData); delete responseCallbacks[message.responseId]; } else { if (message.callbackId) { var callbackResponseId = message.callbackId; responseCallback = function(responseData) { _doSend({ handlerName:message.handlerName, responseId:callbackResponseId, responseData:responseData }); }; } var handler = messageHandlers[message.handlerName]; if (!handler) { console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:", message); } else { handler(message.data, responseCallback); } } } } function _handleMessageFromObjC(messageJSON) { _dispatchMessageFromObjC(messageJSON); } messagingIframe = document.createElement('iframe'); messagingIframe.style.display = 'none'; messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE; document.documentElement.appendChild(messagingIframe); registerHandler("_disableJavascriptAlertBoxSafetyTimeout", disableJavscriptAlertBoxSafetyTimeout); setTimeout(_callWVJBCallbacks, 0); function _callWVJBCallbacks() { var callbacks = window.WVJBCallbacks; delete window.WVJBCallbacks; for (var i=0; i<callbacks.length; i++) { callbacks[i](WebViewJavascriptBridge); } } })();
     (lldb)
 
     */
}
