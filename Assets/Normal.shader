Shader "Test/LightNormal"
{
       Properties
       {
              _myColor ("MainColor", color) = (1,1,1,1)
			  _MainTex("Texture", 2D) = "white" {}
       }
       SubShader
       {
              Tags { "RenderType"="Opaque" }
              LOD 100
              Pass
              {
				   Tags {
						"LightMode" = "ForwardBase"
					}
                     CGPROGRAM
                     #pragma vertex vert
                     #pragma fragment frag
                     
					 #pragma target 3.0
					#pragma vertex vert
					#pragma fragment frag
					#include "UnityStandardBRDF.cginc" 

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
					 sampler2D _MainTex;
					 float4 _MainTex_ST;
                     
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
						  i.worldNormal = normalize(i.worldNormal);
						   half3 ambient_contrib = ShadeSH9(float4(i.worldNormal, 1));

                           half directAtten = 1;
                           half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
						   
                           half3 directColor = dot(lightDir, i.worldNormal) * _LightColor0;
                           half3 IndirectColor = ambient_contrib;
						   float3 DirectLightResult = (directColor)* directAtten;
                           half3 diffuse = (IndirectColor.xyz + DirectLightResult);
                           return fixed4(diffuse, 1);
                     }
                     ENDCG
              }
       }
}