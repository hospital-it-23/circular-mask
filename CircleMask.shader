Shader"Custom/CircleMask"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Radius ("Radius", Range(0, 1)) = 0.5
    }
    SubShader
    {
Cull Off
ZWrite Off
ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

#include "UnityCG.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
};

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}

sampler2D _MainTex;
float _Radius;

fixed4 frag(v2f i) : SV_Target
{
                // Aspect ratio correction
    float2 aspect = float2(_ScreenParams.x / _ScreenParams.y, 1);
    float2 uv = i.uv * aspect;
    float2 center = float2(0.5 * aspect.x, 0.5);

    float dist = distance(uv, center);
                
    if (dist > _Radius)
        return fixed4(0, 0, 0, 1); // Black outside the circle
    else
        return tex2D(_MainTex, i.uv); // Original color inside
}
            ENDCG
        }
    }
}