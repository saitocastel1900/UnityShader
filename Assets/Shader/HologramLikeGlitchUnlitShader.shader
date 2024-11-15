Shader "Unlit/HologramLikeGlitchUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _LinePositionY ("LinePositionY", Range(0, 1)) = 0.5
        _LineWidth ("LineWidth", Range(0, 1)) = 0.24
        _Deviation ("Deviation", Range(0, 1)) = 0.5
        _FrameRate ("FrameRate", Range(0, 30)) = 15
        _Frequency ("Frequency", Range(0, 10)) = 3
        _Alpha ("Alpha", Range(0, 1)) = 1

        _ScanLineMainColor ("ScanLineMainColor", Color) = (1,1,1,1)
        _ScanLineSubColor ("ScanLineSubColor", Color) = (1,1,1,1)
        _SliceSpace ("SliceSpace", Range(0,30)) = 15
        _FillRatio("FillRatio",Range(0,1)) = 1
        _ScanlineSpeedScale("ScanlineSpeedScale",Range(0,10)) = 1
        _ColorGap("ColorGap",Range(0,0.025)) = 0.1
    }
    SubShader
    {
        Tags
        {
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
            float _LinePositionY;
            float _LineWidth;
            float _Deviation;
            float _FrameRate;
            float _Frequency;
            float _Alpha;

            fixed4 _ScanLineMainColor;
            fixed4 _ScanLineSubColor;
            fixed _SliceSpace;
            fixed _FillRatio;
            fixed _ColorGap;
            fixed _ScanlineSpeedScale;

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
                float interpolation = step(frac((uv.y + _Time.z*_ScanlineSpeedScale) * _SliceSpace),_FillRatio);
                float4 scanlineColor = lerp(_ScanLineMainColor, _ScanLineSubColor, interpolation);
                
                float Line1 = step(_LinePositionY * rand(sin(posterize(_Time.w))), rand(uv.y+_LineWidth));
                float Line2 = step(_LinePositionY * rand(sin(posterize(_Time.w))) + _LineWidth, uv.y);
                uv.x += saturate(Line1-Line2) * _Deviation * sin(posterize(_Time.w) * _Frequency);
                float4 color = tex2D(_MainTex,uv);

                float r = tex2D(_MainTex,uv+_ColorGap*rand(sin(posterize(_Time.w)))).r;
                float b = tex2D(_MainTex,uv-_ColorGap*rand(sin(posterize(_Time.w)))).b;

                float2 ga = tex2D(_MainTex,uv).ga;
                float4 shiftColor = fixed4(r,ga.x,b,ga.y);
                
                color.a = _Alpha;
                return color * scanlineColor * shiftColor;
            }
            ENDCG
        }
    }
}