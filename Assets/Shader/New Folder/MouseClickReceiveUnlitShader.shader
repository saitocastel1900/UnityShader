Shader "Unlit/MouseClickReceiveUnlitShader"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _MousePosition;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : WORLD_POS;
            };
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 baseColor =(1,1,1,1);

                float dist = distance(_MousePosition, i.worldPos);

                if (dist < 0.1)
                {
                    baseColor *= float4(1,0,0,0);
                }
                
                return baseColor;
            }
            ENDCG
        }
    }
}
