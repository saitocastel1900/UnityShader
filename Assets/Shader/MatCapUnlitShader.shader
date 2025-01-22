Shader "Unlit/MatCapUnlitShader"
{
    Properties
    {
        _MatCap ("Mat Cap", 2D) = "white" {}
    }

    Subshader
    {
        Tags { "RenderType"="Opaque" }
        
        Pass
        {
            CGPROGRAM
           #include "UnityCG.cginc"
           #pragma vertex vert
           #pragma fragment frag

            sampler2D _MatCap;
                
            struct v2f
            {
                float4 pos  : SV_POSITION;
                half2 uv    : TEXCOORD0;
            };
                
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);

                //カメラ座標系の法線を取得
                float3 normal = mul((float3x3)UNITY_MATRIX_V,UnityObjectToWorldNormal(v.normal));
                //カメラ座標系の法線を-1.0~1.0の範囲に変換
                o.uv = normal.xy * 0.5 + 0.5;
                
                return o;
            }
                
            float4 frag (v2f i) : COLOR
            {
                return tex2D(_MatCap, i.uv);
            }

            ENDCG
        }
    }
}
