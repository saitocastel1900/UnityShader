Shader "Unlit/GeometryNormalMoveUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _PositionFactor("PositionFactor",Float) = 0.5
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
            float _PositionFactor;
            
            struct appdata
            {
                float4 vertex : POSITION;
            };

            //ジオメトリーシェーダーからフラグメントシェーダーに渡す値
            struct  g2f
            {
                float4 vertet : SV_POSITION;
            };
            

            appdata vert (appdata v)
            {
                return v;
            }

            [maxvertexcount(3)]
            void geom(triangle appdata input[3],inout  TriangleStream<g2f> stream)
            {
                float3 vec1 = input[1].vertex - input[0].vertex;
                float3 vec2 = input[2].vertex - input[0].vertex;

                float3 normal = normalize(cross(vec1,vec2));

                [unroll]
                for (int i = 0; i < 3; ++i)
                {
                 appdata v = input[i];
                    g2f o;
                    v.vertex.xyz += normal * sin(_Time.w) * _PositionFactor;
                    o.vertet = UnityObjectToClipPos(v.vertex);
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
