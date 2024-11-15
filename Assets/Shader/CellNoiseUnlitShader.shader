Shader "Unlit/CellNoiseUnlitShader"
{
    Properties
    {
        _SquareNum ("SuareNum", int) = 1
        [HDR] _WaterColor("Water Color",Color) = (1,1,1,1)
        _FoamColor ("Foam Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "RenderPipeline"="UniversalPipeline"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            int _SquareNum;
            fixed4 _FoamColor;
            fixed4 _WaterColor;
            
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 st = i.uv;
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
                        float2 p = 0.5 + 0.5 * sin(random2(neighbor+ist));
                        float2 diff = neighbor + p - fst;
                        dist = min(dist,length(diff));
                        waveColor =  lerp(_WaterColor, _FoamColor, dist);
                    }
                }
                
                return waveColor;
            }
            ENDCG
        }   
    }
}
