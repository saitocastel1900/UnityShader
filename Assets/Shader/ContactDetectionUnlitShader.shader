Shader "Unlit/ContactDetectionUnlitShader"
{
    Properties
    {
        _EdgeColor("Edge Color", Color) = (1,1,1,1)
        _EdgeOffset("Edge Offset", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "RenderPipeline"="UniversalPipeline"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        ZWrite On

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;
            fixed4 _EdgeColor;
            half _EdgeOffset;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                //本来なら４回ほど座標変換が必要だが、これひとつで済む
                //クリップ空間はカメラに映っている描画するオブジェクトの3D空間。2Dで投影した場合どうなるのかを考慮した座標空間。それを変換することで、2Dの空間になる
                //ちなみにスクリーン空間は、クリップ空間を画面サイズに直したもの
                //（モデル座標→ワールド座標→ビュー座標→クリップ座標）
                o.vertex = UnityObjectToClipPos(v.vertex);
                //（クリップ座標→スクリーン座標）
                o.screenPos = ComputeScreenPos(o.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half sceneDepth = LinearEyeDepth(
                    SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
                half depth = 1 - saturate(sceneDepth - i.screenPos.w);
                return fixed4(_EdgeColor.rgb, step(_EdgeOffset, depth));
                //return fixed4(_EdgeColor.rgb,smoothstep(0,_EdgeOffset,depth));
            }
            ENDCG
        }
    }
}