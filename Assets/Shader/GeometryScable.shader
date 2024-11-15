Shader "Unlit/GeometryScable"
{
    Properties
    {
       _Color("Color",Color) = (1,1,1,1)
        _ScaleFactor("ScaleFactor",Float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom 
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _Color;
            float _ScaleFactor;
            
            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct g2f
            {
                float4 vertex : SV_POSITION;
            };

            appdata vert (appdata v)
            {
                return v;
            }

            [maxvertexcount(3)]
            void geom(triangle appdata input[3],inout TriangleStream<g2f> stream)
            {
                //ポリゴンの中心
                float3 center = (input[0].vertex + input[1].vertex + input[2].vertex) / 3;
                
                [unroll]
                for (int i = 0; i<3; i++)
                {
                    appdata v = input[i];
                    v.vertex.xyz = (v.vertex.xyz - center) * (1.0 - _ScaleFactor) + center;
                    g2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    stream.Append(o);
                }
            }
            
            fixed4 frag (g2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
