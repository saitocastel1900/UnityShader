Shader "Unlit/WorldSliceUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _SliceSpace("SliceSpace",Range(0,30)) = 15
        _Scale("Scale",Range(0,1)) = 1
    }
    SubShader
    {
        Pass
        {   
            Tags { "RenderType"="Opaque" }
            LOD 100
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            fixed4 _Color;
            fixed _SliceSpace;
            fixed _Scale;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                //セマンティックでworldPosを取得すると宣言
                float3 worldPos : WORLD_POS;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                //unity_ObjectToWorld*頂点座標をすることで、ワールド座標を取得
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                clip(frac(i.worldPos.y - _SliceSpace)-_Scale);
                return _Color;
            }
            ENDCG
        }
    }
}
