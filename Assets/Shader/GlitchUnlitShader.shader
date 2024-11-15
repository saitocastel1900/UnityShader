Shader "Unlit/GlitchUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _LinePositionY ("LinePositionY", Range(0, 1)) = 0.5
        _LineWidth ("LineWidth", Range(0, 1)) = 0.24
        _Deviation ("Deviation", Range(0, 1)) = 0.5
        _FrameRate ("FrameRate", Range(0, 30)) = 15
        _Frequency ("Frequency", Range(0, 10)) = 3
    }
    SubShader
    {
        Tags
        {
            "LightMode"="UniversalForward"
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _LinePositionY;
            float _LineWidth;
            float _Deviation;
            
            float _FrameRate;
            float _Frequency;

             float2 posterize(float2 In)
            {
                return floor(In * _FrameRate) / (_FrameRate);
            }
            
            float rand(float2 co)
            {
                return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
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
                float2 uv = i.uv;
                float Line1 = step(rand(_LinePositionY * rand(sin(posterize(_Time.w)))), rand(uv));
                float Line2 = step(rand(_LinePositionY * rand(sin(posterize(_Time.w))) )+ _LineWidth, uv.y);
                uv.x += saturate(Line1-Line2) * _Deviation * sin(posterize(_Time.w) * _Frequency);
                return tex2D(_MainTex,uv);
            }
            ENDCG
        }
    }
}