Shader "Unlit/SpotlightUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TargetPosition ("Target Position", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags
        {
            "LightMode"="UniversalForward"
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TargetPosition;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            void BoundingBoxConvert_float(
                float3 Position, // モデルの頂点座標
                float3 BoundingMin, // バウンディングボックスの最小座標
                float3 BoundingMax, // バウンディングボックスの最大座標
                float3 TargetPosition, // モデルを追従
                out float3 Output // 変換後の頂点座標
            )
            {
                // モデル頂点のy座標が 0 ~ 1 の範囲に収まるように座標変換
                float y = (Position.y - BoundingMin.y) / (BoundingMax.y - BoundingMin.y);

                // バウンディングボックスを四角錐に変形
                float2 centerXZ = (BoundingMin.xz + BoundingMax.xz) / 2.0; // 中心座標
                Position.xz = lerp(Position.xz, centerXZ, y); // yが1に近づくにつれて、XZ座標は中心座標に近づく

                // 位置をずらす
                float3 ShiftPosition = Position + TargetPosition;

                // yが0に近づくほど、頂点座標はShiftPositionに近づく
                Output = lerp(ShiftPosition, Position, y);
            }

            v2f vert(appdata v)
            {
                v2f o;

                BoundingBoxConvert_float(v.vertex.xyz, float3(-1, -1, -1), float3(1, 1, 1), _TargetPosition,
                                          o.vertex.xyz);
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float a = i.uv.g;
                return fixed4(a, a, a, a);
            }
            ENDCG
        }
    }
}