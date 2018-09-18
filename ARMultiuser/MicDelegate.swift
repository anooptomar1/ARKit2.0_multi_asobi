//
//  MicDelegate.swift
//  CS-proto
//
//  Created by admin on 2018/09/05.
//  Copyright © 2018年 Apple. All rights reserved.
//
import Foundation

//音 peak と average RMS power を渡す用意
protocol MicDelegate {
    func nortice(mP: Float, mA:Float)
}

