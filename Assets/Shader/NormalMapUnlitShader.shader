Shader "Unlit/NormalMapUnlitShader"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1,1,1,1)
        _Reflection ("Reflection", Range(0,1)) = 0.5
        _Specular ("Specular", Range(0,1)) = 0.5
        _NormalMap ("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags
        {
            "Queue"="Geometry"
            "RenderType"="Opaque"
            "LightMode"="UniversalForward"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4 _MainColor;
            float _Reflection;
            float _Specular;
            sampler2D _NormalMap;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
                float4 tangent:TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 lightDir:TEXCOORD1;
                float3 viewDir:TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                TANGENT_SPACE_ROTATION;

                o.lightDir = normalize(mul(rotation, ObjSpaceLightDir(v.vertex)));

                o.viewDir = normalize(mul(rotation, ObjSpaceViewDir(v.vertex)));

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //ノーマルマップから法線を取得
                float3 normal = UnpackNormal(tex2D(_NormalMap, i.uv));

                //反射ベクトルを計算
                float3 refVec = reflect(-i.lightDir, normal);

                //内積を求めて
                float dotVR = dot(refVec, i.viewDir);

                //0以下の内積を扱わないようにして
                dotVR = max(0,dotVR);
                dotVR = pow(dotVR,_Reflection);
                float3 specular = _LightColor0.xyz * _Specular;

                //内積を使って色を計算
                return lerp(_MainColor,float4(specular,1),dotVR);
            }
            ENDCG
        }
    }
}