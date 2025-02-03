Shader "Unlit/CubemapUnlitShader"
{
    Properties
    {
        _Cube("Cube",CUBE) = ""{}
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

            UNITY_DECLARE_TEXCUBE(_Cube);
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 viewDir : TEXCOORD1;
                float3 normal : NORMAL;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.viewDir = ObjSpaceViewDir(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 r = reflect(-i.viewDir,i.normal);
                float4 col = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0,r);
                //float4 col = UNITY_SAMPLE_TEXCUBE(_Cube,r);
                return col;
            }
            ENDCG
        }
    }
}
