Shader "Unlit/DotUnlitShader"
{
    Properties
    {
        _Color1("Color1", Color) = (1,1,1,1)
        _Color2("Color1", Color) = (1,1,1,1)
        _Rotation("Rotation", Vector) = (1,1,1)
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

            fixed4 _Color1;
            fixed4 _Color2;
            float3 _Rotation;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float3 worldPos : WORLD_POS;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float interpolation = (dot(i.worldPos,normalize(_Rotation)));
                return lerp(_Color1,_Color2,interpolation);
            }
            ENDCG
        }
    }
}