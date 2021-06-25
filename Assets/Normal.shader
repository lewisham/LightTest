Shader "Test/LightNormal"
{
       Properties
       {
              _myColor ("MainColor", color) = (1,1,1,1)
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
                     #pragma multi_compile LIGHTMAP_ON
                     #pragma multi_compile SHADOWS_DEPTH SHADOWS_SCREEN
                     #pragma multi_compile SHADOWS_SHADOWMASK
                     
                     #include "UnityCG.cginc"
                     #include "AutoLight.cginc"
                     #include "UnityStandardCore.cginc"
                     struct appdata
                     {
                           float4 vertex : POSITION;
                           float2 uv : TEXCOORD0;
                           float4 texcoord1:TEXCOORD1;//lightmap uv
                           float3 normal:NORMAL;
                     };
                     struct v2f
                     {
                           float4 uv : TEXCOORD0;
                           float4 pos : SV_POSITION;
                           float4 worldPos : TEXCOORD2;
                           float3 worldNormal : TEXCOORD3;
                     };
                     fixed4 _myColor;
                     
                     v2f vert (appdata v)
                     {
                           v2f o;
                           o.pos = UnityObjectToClipPos(v.vertex);
                           o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                           o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                           o.uv.zw = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                           o.worldNormal = UnityObjectToWorldNormal( v.normal);
                           return o;
                     }
                     
                     fixed4 frag (v2f i) : SV_Target
                     {
						   half3 ambient_contrib = ShadeSH9(float4(i.worldNormal, 1));

                           half directAtten = 1;
                           half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
						   i.worldNormal = normalize(i.worldNormal);
                           half3 directColor = dot(lightDir, i.worldNormal) * _LightColor0;
                           half3 indirectColor = ambient_contrib;
                           fixed bakedAtten = UnitySampleBakedOcclusion(i.uv.zw, i.worldPos);
                           half3 diffuse = (indirectColor.xyz + (directColor)  * bakedAtten * directAtten);
                           return fixed4(diffuse , 1);
                     }
                     ENDCG
              }
       }
}