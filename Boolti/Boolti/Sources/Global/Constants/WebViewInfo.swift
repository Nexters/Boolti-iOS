//
//  WebViewInfo.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/3/25.
//

import WebKit

enum WebViewInfo {

    static let webViewBridgeName = "boolti"
    static let webViewUserAgent = "BOOLTI/IOS"
    static let UpdateWebViewHeight = "updateWebViewHeight"
    static let UpdateWebViewHeightScript = WKUserScript(
          source: """
              function updateWebViewHeight() {
                  // 문서 전체 높이 계산을 위한 함수
                  function getMaxHeight() {
                      // 기본 body 높이
                      var height = document.body.scrollHeight;
                      
                      // iframe 엘리먼트들의 높이 고려
                      var iframes = document.getElementsByTagName('iframe');
                      for (var i = 0; i < iframes.length; i++) {
                          var iframe = iframes[i];
                          var iframeBottom = iframe.getBoundingClientRect().bottom + window.pageYOffset;
                          height = Math.max(height, iframeBottom);
                      }
                      
                      // 모든 DOM 요소의 위치를 고려한 총 높이 계산
                      var allElements = document.getElementsByTagName('*');
                      for (var i = 0; i < allElements.length; i++) {
                          var element = allElements[i];
                          var elementBottom = element.getBoundingClientRect().bottom + window.pageYOffset;
                          height = Math.max(height, elementBottom);
                      }

                      return height + 16;
                  }
                  
                  // 유튜브 iframe이 로드되기까지 약간의 시간이 지연
                  setTimeout(function() {
                      var calculatedHeight = getMaxHeight();
                      window.webkit.messageHandlers.updateWebViewHeight.postMessage(calculatedHeight);
                  }, 500);
              }

              // 페이지 로드 시 실행
              window.addEventListener('load', function() {
                          updateWebViewHeight();
                  
                  // 유튜브 iframe을 위한 추가 지연 업데이트
                  setTimeout(updateWebViewHeight, 1000);
                  setTimeout(updateWebViewHeight, 2000);
              });

              // DOM 변경 감지
              const observer = new MutationObserver(function() {
                  updateWebViewHeight();
              });

              observer.observe(document.body, { 
                  subtree: true, 
                  childList: true,
                  attributes: true,
                  characterData: true
              });

              window.addEventListener('resize', function() {
                  updateWebViewHeight();
              });
          """,
          injectionTime: .atDocumentEnd,
          forMainFrameOnly: true
      )
}
