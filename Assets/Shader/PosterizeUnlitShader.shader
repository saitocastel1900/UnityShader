Shader "Unlit/PosterizeUnlitShader"
{
    Properties
    {
        _FrameRate ("FrameRate", Range(0.1,100)) = 15
        _MainTex ("Texture", 2D) = "white" {}
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

            float _FrameRate;
            float _Frequency;
            sampler2D _MainTex;

            float2 posterize(float2 In)
            {
                return floor(In * _FrameRate) / (_FrameRate);
            }

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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, posterize(i.uv));
            }
            ENDCG
        }
    }
}