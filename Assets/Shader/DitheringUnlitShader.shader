Shader "Unlit/DitheringUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DitherLevel("DitherLevel",Range(0,16)) = 1
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _DitherLevel;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
              };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD1;
            };

            static const int pattern[16]=
                {
                0,8,2,10,
                12,4,14,6,
                3,11,1,9,
                15,7,13,5
                };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 viewPortPos = i.screenPos.xy / i.screenPos.w;
                float2 screenPosInPixel = viewPortPos.xy * _ScreenParams.xy;

                int ditherUV_x = (int)fmod(screenPosInPixel.x,4.0f);
                int ditherUV_y = (int)fmod(screenPosInPixel.y,4.0f);
                float dither = pattern[ditherUV_x+ditherUV_y*4];

                clip(dither - _DitherLevel);
                
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}