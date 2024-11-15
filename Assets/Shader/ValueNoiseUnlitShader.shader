Shader "Unlit/ValueNoiseUnlitShader"
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

            float valueNoise(fixed2 st)
            {
                fixed2 p = floor(st);
                fixed2 f = frac(st);

                float v00 = random(p+fixed2(0,0));
                float v10 = random(p+fixed2(1,0));
                float v01 = random(p+fixed2(0,1));
                float v11 = random(p+fixed2(1,1));

                fixed2 u = f*f*(3.0-2.0*f);

                float v0010 = lerp(v00,v10,u.x);
                float v0111 = lerp(v01,v11,u.x);

                return lerp(v0010,v0111,u.y);
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
                float4 c = valueNoise(i.uv*_NoiseScale);
                return c;
            }
            ENDCG
        }
    }
}
