Shader "Unlit/LocalSliceUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _SliceSpace("SliceSpace",Range(0,30)) = 15
        _FillRatio("FillRatio",Range(0,1)) = 1
    }
    SubShader
    {
        Pass
        {
            Tags { "RenderType"="Opaque" }
            LOD 100
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            half4 _Color;
            float _SliceSpace;
            float _FillRatio;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 localPos : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.localPos = v.vertex.xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                clip(frac(i.localPos.y * _SliceSpace) - 0.5);
                return _Color;
            }
            ENDCG
        }
    }
}
