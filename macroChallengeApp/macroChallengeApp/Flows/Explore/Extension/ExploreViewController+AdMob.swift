//
//  ExploreViewController+AdMob.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 22/11/22.
//

import GoogleMobileAds

extension ExploreViewController: GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.adsNatives.append(nativeAd)
        print(nativeAd.images, nativeAd.body, nativeAd.headline, nativeAd.store, "carregou")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Falhou")
    }
}
