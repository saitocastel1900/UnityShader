Shader "Unlit/UseCameraDistanceUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FarTex ("Texture", 2D) = "white" {}
    }
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

            sampler2D _MainTex;
            sampler2D _FarTex;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : WORLD_POS;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 nearCol = tex2D(_MainTex,i.uv);
                float4 farCol = tex2D(_FarTex,i.uv);

                float cameraToObjectLength = length(_WorldSpaceCameraPos - i.worldPos);
                
                return lerp(nearCol,farCol,cameraToObjectLength);
            }
            ENDCG
        }
    }
}
