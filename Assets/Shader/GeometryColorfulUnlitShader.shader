Shader "Unlit/GeometryColorfulUnlitShader"
{
    Properties
    {
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
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2g
            {
                float4 vertex : POSITION;
            };

            struct g2f
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            //ランダムな値を返す
            float rand(float2 co)
            {
                return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
            }

            v2g vert(v2g v)
            {
                return v;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g input[3], inout TriangleStream<g2f> stream)
            {
                float3 center = (input[0].vertex+input[1].vertex+input[2].vertex)/3;
                
                float r = rand(center.xy);
                float g = rand(center.xz);
                float b = rand(center.yz);

                [unroll]
                for (int i = 0; i < 3; i++)
                {
                    v2g v = input[i];
                    g2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.color = fixed4(r,g,b,1);
                    stream.Append(o);
                }
            }

            fixed4 frag(g2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}