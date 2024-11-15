Shader "Unlit/fBmNoiseUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseScale ("Noise Scale", Range(1, 10)) = 1
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

            float _NoiseScale;

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

            float random(fixed2 p)
            {
                return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
            }

            float noise(fixed2 st)
            {
                fixed2 p = floor(st);
                return random(p);
            }

            float perlinNoise(fixed2 st)
            {
                fixed2 p = floor(st);
                fixed2 f = frac(st);

                float v00 = random(p + fixed2(0, 0));
                float v10 = random(p + fixed2(1, 0));
                float v01 = random(p + fixed2(0, 1));
                float v11 = random(p + fixed2(1, 1));

                fixed2 u = f * f * (3.0 - 2.0 * f);

                return lerp(lerp(dot(v00, f - fixed2(0, 0)), dot(v10, f - fixed2(1, 0)), u.x),
                                                lerp(dot(v01, f - fixed2(0, 1)), dot(v11, f - fixed2(1, 1)), u.x),
                                                u.y) + 0.5f;
            }

            float fBm(fixed2 st)
            {
                float f = 0;
                fixed2 q = st;

                f += 0.5000 * perlinNoise(q);
                q = q * 2.01;
                f += 0.2500 * perlinNoise(q);
                q = q * 2.02;
                f += 0.1250 * perlinNoise(q);
                q = q * 2.03;
                f += 0.0625 * perlinNoise(q);
                q = q * 2.01;

                return f;
            }


            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 c = fBm(i.uv * _NoiseScale);
                return c;
            }
            ENDCG
        }
    }
}