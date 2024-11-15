Shader "Unlit/UvScrollNoneTextureUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _SliceSpace("SliceSpace",Range(0,30)) = 15
        _FillRatio("FillRatio",Range(0,1)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            float1 _SliceSpace;
            float1 _FillRatio;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv.y + _Time.x;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                clip(frac(i.uv.y * _SliceSpace) - _FillRatio);
                return _Color;
            }
            ENDCG
        }
    }
}