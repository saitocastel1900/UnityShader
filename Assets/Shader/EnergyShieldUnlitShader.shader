Shader "Unlit/EnergyShieldUnlitShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _MainColor("Main Color", Color) = (1,1,1,1)
        _EdgeOffset("Edge Offset", Range(0, 1)) = 0.1
        _RimMultiplier ("Rim Multiplier", Range(0,10)) = 2
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
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

            fixed4 _MainColor;
            float _EdgeOffset;
            float _RimMultiplier;
            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
                float4 screenPos : TEXCOORD3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float rim = 1 - abs(dot(i.viewDir, i.worldNormal));
                float sceneDepth = LinearEyeDepth(
                    SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
                float depth = saturate(sceneDepth - i.screenPos.w);
                i.uv.x += _Time.x;
                half4 color = tex2D(_MainTex, i.uv);
                return fixed4(color.rgb * _MainColor.rgb ,max(color.r,0.1)) + fixed4(_MainColor.rgb,smoothstep(0,depth,_EdgeOffset) + pow(rim, _RimMultiplier));
            }
            ENDCG
        }
    }
}