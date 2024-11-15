Shader "Unlit/ColorMaskOcclusionUnlitShader"
{
    SubShader
    {
        Tags {"Queue"="geometry-1"}
        ColorMask 0
        ZWrite On
        Pass {}
    }
}
