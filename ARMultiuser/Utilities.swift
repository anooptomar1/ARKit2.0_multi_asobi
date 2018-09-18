/*
takuto.ukawa

Abstract:
Convenience extensions on system types.
*/

import simd
import ARKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "できないよ"
        case .limited:
            return "ゆっくり動かしてね"
        case .extending:
            return "まだだよ"
        case .mapped:
            return "おっけいだよ"
        }
    }
}

extension float4x4 {
    var translation: float3 {
        return float3(columns.3.x, columns.3.y, columns.3.z)
    }

    init(translation vector: float3) {
        self.init(float4(1, 0, 0, 0),
                  float4(0, 1, 0, 0),
                  float4(0, 0, 1, 0),
                  float4(vector.x, vector.y, vector.z, 1))
    }
}

extension float4 {
    var xyz: float3 {
        return float3(x, y, z)
    }
}
