Shader "Unlit/ToonSeaUnlitShader"
{
    Properties
    {
        _EdgeColor("Edge Color", Color) = (1,1,1,1)
        _FoamColor ("Foam Color", Color) = (1,1,1,1)
        [HDR] _WaterColor("Water Color",Color) = (1,1,1,1)
        _SquareNum ("SaureNum", int) = 1
        _WaveSpeed ("Wave Speed", Range(0, 1)) = 0.5
        _FoamPower ("Foam Power", Range(0, 1)) = 0.5
        _DistortionPower("Distortion Power",Range(0,0.01)) = 0.1
        _DistortionCycle("DistortionCycle",Range(1,100)) = 50
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "RenderPipeline"="UniversalPipeline"
        }
        Blend SrcAlpha OneMinusSrcAlpha


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;
            sampler2D _CameraOpaqueTexture;
            fixed4 _EdgeColor;
            int _SquareNum;
            fixed4 _FoamColor;
            fixed4 _WaterColor;
            float _WaveSpeed;
            float _FoamPower;
            half _DistortionPower;
            half _DistortionCycle;

            float2 random2(float2 st)
            {
                st = float2(dot(st, float2(127.1, 311.7)),
                            dot(st, float2(269.5, 183.3)));
                return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
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
                float4 screenPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            float4 SeaPattern(float2 uv)
            {
                float2 st = uv;
                st *= _SquareNum;

                float2 ist = floor(st);
                float2 fst = frac(st);

                float4 waveColor = 0;
                float dist = 1;

                for (int y = -1; y <= 1; y++)
                {
                    for (int x = -1; x <= 1; x++)
                    {
                        float2 neighbor = float2(x, y);
                        float2 p = 0.5 + 0.5 * sin(random2(neighbor + ist) + _Time.y * _WaveSpeed);
                        float2 diff = neighbor + p - fst;
                        dist = min(dist, length(diff));
                        waveColor = lerp(_WaterColor, _FoamColor, smoothstep(_FoamPower, 1, dist));
                    }
                }

                return waveColor;
            }

            half WaterSurface(float4 screenPos)
            {
                half sceneDepth = LinearEyeDepth(
                    SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(screenPos)));
                half depth = 1 - saturate(sceneDepth - screenPos.w);
                return depth;
            }

            float4 Fluctuation(float2 uv, float4 screenPos)
            {
                float2 distoration = sin(uv.y * _DistortionCycle + _Time.w) * _DistortionPower;
                float4 depthUV = screenPos;
                depthUV.xy = screenPos.xy + distoration * 1.5f;

                float backgroundDepth = LinearEyeDepth(
                    SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(depthUV)));
                float surfaceDepth = (screenPos.w);
                float depthDiff = saturate(backgroundDepth - surfaceDepth);

                uv = (screenPos.xy + distoration * depthDiff) / screenPos.w;

                return tex2D(_CameraOpaqueTexture, uv);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 waveColor = SeaPattern(i.uv);
                half depth = WaterSurface(i.screenPos);

                return lerp(waveColor, _EdgeColor, depth) + Fluctuation(i.uv, i.screenPos);
            }
            ENDCG
        }
    }
}