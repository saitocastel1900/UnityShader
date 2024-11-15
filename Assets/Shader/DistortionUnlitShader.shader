Shader "Unlit/DistortionUnlitShader"
{
    Properties
    {
        _DistortionPower("Distortion Power",Range(0,0.01)) = 0.1
        _DistortionCycle("DistortionCycle",Range(1,100)) = 50
        [HDR]_MainColor("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "Renderpipeline"="UniversalPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            half4 _MainColor;
            half _DistortionPower;
            half _DistortionCycle;
            sampler2D _CameraOpaqueTexture;
            sampler2D _CameraDepthTexture;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 scrPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.scrPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 distoration = sin(i.uv.y * _DistortionCycle + _Time.w) * _DistortionPower;
                float4 depthUV = i.scrPos;
                depthUV.xy = i.scrPos.xy + distoration * 1.5f;
                
                float backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD(depthUV)));
                float surfaceDepth = (i.scrPos.w);
                float depthDiff = saturate(backgroundDepth - surfaceDepth);

                float2 uv = (i.scrPos.xy + distoration*depthDiff) / i.scrPos.w;
                
                return tex2D(_CameraOpaqueTexture,uv) * _MainColor;
            }
            ENDCG
        }
    }
}