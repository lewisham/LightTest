Shader "Fishing3D/Fish/Opaque Bump"
{
  Properties
  {
    _Color ("主色调", Color) = (1,1,1,1)
    _SpecColor ("高光颜色", Color) = (1,1,1,1)
    _FlowColor ("流动颜色", Color) = (1,1,1,1)
    _GrayValue ("GrayValue", Range(0, 1)) = 0
    _HitColorValue ("击中颜色显示", Range(0, 1)) = 0
    _HitSaturation ("击中颜色饱和", Range(-10, 10)) = 0.2
    _HitColor ("击中最终颜色", Color) = (1,0,0,1)
    _PreHitColor ("pre hit color", Color) = (1,0,0,1)
    _TestGrayFlag ("gray flag", Range(0, 1)) = 1
    _TestGrayColor ("gray color", Color) = (0.1,0.1,0.1,0.1)
    _HitAniValue ("击中动画渐变", Range(0, 1)) = 0
    _FrozenColorValue ("冰冻颜色显示", Range(0, 1)) = 0
    _FrozenSaturation ("冰冻颜色饱和", Range(-10, 10)) = 0.2
    _FrozenColor ("冰冻颜色", Color) = (0.564,1,1,1)
    _Alpha ("透明度", float) = 1
    _MainTex ("主贴图(RGB)", 2D) = "White" {}
    _AlphaTex ("Alpha贴图(RA)", 2D) = "White" {}
    _AlphaA_Strength ("Alpha A Strength", Range(0, 2)) = 1
    _AlphaB_Strength ("Alpha B Strength", Range(0, 2)) = 1
    _BumpMap ("法线贴图", 2D) = "Bump" {}
    _Cube ("反射Cubemap", Cube) = "Black" {}
    _NoiseTex ("噪声贴图", 2D) = "White" {}
    _Albedo ("环境光强度", Range(0, 1)) = 0.5
    _Shininess ("亮度", Range(0.01, 3)) = 1.5
    _Gloss ("光泽度", Range(0, 1)) = 0.5
    _Reflection ("反射值", Range(0, 1)) = 0.5
    _FrezFalloff ("高光边缘衰减", Range(0, 10)) = 4
    _FlowStrenth ("流动强度", float) = 1
    _FlowTime ("流动增量时间", float) = 0
    _Scale ("阴影缩放", float) = 1
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
	Pass // ind: 1, name: FORWARD
	{
	  Name "FORWARD"
	  Tags
	  {
		"IGNOREPROJECTOR" = "False"
		"LIGHTMODE" = "FORWARDBASE"
		"QUEUE" = "Geometry+200"
		"RenderType" = "Opaque"
		"SHADOWSUPPORT" = "true"
	  }
	  Blend SrcAlpha OneMinusSrcAlpha
		// m_ProgramMask = 6
		CGPROGRAM
		#pragma multi_compile DIRECTIONAL
		//#pragma target 4.0

		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"
		#define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
		#define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
		#define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
		#define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)


		#define CODE_BLOCK_VERTEX
		// float4x4 unity_ObjectToWorld;
		// float4x4 unity_WorldToObject;
		// float4 unity_WorldTransformParams;
		// float4x4 unity_MatrixVP;
		 float4 _MainTex_ST;
		 float4 _BumpMap_ST;
		 float4 _AlphaTex_ST;
		// float3 _WorldSpaceCameraPos;
		// float4 _WorldSpaceLightPos0;
		float4 _LightColor0;
		float4 _SpecColor;
		 float _BumpScale;
		 float _Alpha;
		 float _AlphaA_Strength;
		 float _AlphaB_Strength;
		 float4 _FlowColor;
		 float4 _Color;
		 float _HitSaturation;
		 float _HitColorValue;
		 float4 _HitColor;
		 float _TestGrayFlag;
		 float4 _TestGrayColor;
		 float4 _PreHitColor;
		 float _HitAniValue;
		 float _FrozenSaturation;
		 float _FrozenColorValue;
		 float4 _FrozenColor;
		 float _Shininess;
		 float _Gloss;
		 float _Reflection;
		 float _Albedo;
		 float _FrezFalloff;
		 sampler2D _BumpMap;
		 sampler2D _AlphaTex;
		 sampler2D _MainTex;
		 samplerCUBE _Cube;
		struct appdata_t
		{
			float4 vertex :POSITION0;
			float4 tangent :TANGENT0;
			float3 normal :NORMAL0;
			float4 texcoord :TEXCOORD0;
		};

		struct OUT_Data_Vert
		{
			float4 texcoord :TEXCOORD0;
			float2 texcoord1 :TEXCOORD1;
			float4 texcoord2 :TEXCOORD2;
			float4 texcoord3 :TEXCOORD3;
			float4 texcoord4 :TEXCOORD4;
			float3 texcoord5 :TEXCOORD5;
			float4 texcoord7 :TEXCOORD7;
			float4 texcoord8 :TEXCOORD8;
			float4 vertex :SV_POSITION;
		};

		struct v2f
		{
			float4 texcoord :TEXCOORD0;
			float2 texcoord1 :TEXCOORD1;
			float4 texcoord2 :TEXCOORD2;
			float4 texcoord3 :TEXCOORD3;
			float4 texcoord4 :TEXCOORD4;
			float3 texcoord5 :TEXCOORD5;
		};

		struct OUT_Data_Frag
		{
			float4 color :SV_Target0;
		};

		float4 u_xlat0;
		float4 u_xlat1;
		float4 u_xlat2;
		float3 u_xlat3;
		OUT_Data_Vert vert(appdata_t in_v)
		{
			OUT_Data_Vert out_v;
			u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
			u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
			u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
			u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
			u_xlat0.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
			out_v.vertex = mul(unity_MatrixVP, u_xlat1);
			out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
			out_v.texcoord.zw = TRANSFORM_TEX(in_v.texcoord.xy, _BumpMap);
			out_v.texcoord1.xy = TRANSFORM_TEX(in_v.texcoord.xy, _AlphaTex);
			out_v.texcoord2.w = u_xlat0.x;
			u_xlat1.y = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
			u_xlat1.z = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
			u_xlat1.x = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
			u_xlat0.x = dot(u_xlat1.xyz, u_xlat1.xyz);
			u_xlat0.x = rsqrt(u_xlat0.x);
			u_xlat1.xyz = (u_xlat0.xxx * u_xlat1.xyz);
			u_xlat2.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).yzx);
			u_xlat2.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).yzx * in_v.tangent.xxx) + u_xlat2.xyz);
			u_xlat2.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).yzx * in_v.tangent.zzz) + u_xlat2.xyz);
			u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
			u_xlat0.x = rsqrt(u_xlat0.x);
			u_xlat2.xyz = (u_xlat0.xxx * u_xlat2.xyz);
			u_xlat3.xyz = (u_xlat1.xyz * u_xlat2.xyz);
			u_xlat3.xyz = ((u_xlat1.zxy * u_xlat2.yzx) + (-u_xlat3.xyz));
			u_xlat0.x = (in_v.tangent.w * unity_WorldTransformParams.w);
			u_xlat3.xyz = (u_xlat0.xxx * u_xlat3.xyz);
			out_v.texcoord2.y = u_xlat3.x;
			out_v.texcoord2.x = u_xlat2.z;
			out_v.texcoord2.z = u_xlat1.y;
			out_v.texcoord3.x = u_xlat2.x;
			out_v.texcoord4.x = u_xlat2.y;
			out_v.texcoord3.z = u_xlat1.z;
			out_v.texcoord4.z = u_xlat1.x;
			out_v.texcoord3.w = u_xlat0.y;
			out_v.texcoord4.w = u_xlat0.z;
			out_v.texcoord3.y = u_xlat3.y;
			out_v.texcoord4.y = u_xlat3.z;
			out_v.texcoord5.xyz = float3(0, 0, 0);
			out_v.texcoord7 = float4(0, 0, 0, 0);
			out_v.texcoord8 = float4(0, 0, 0, 0);
			return out_v;
		}

		#define CODE_BLOCK_FRAGMENT
		float3 u_xlat0_d;
		int u_xlatb0;
		float3 u_xlat1_d;
		float3 u_xlat10_1;
		int u_xlatb1;
		float4 u_xlat16_2;
		float3 u_xlat3_d;
		int u_xlatb3;
		float3 u_xlat16_4;
		float3 u_xlat16_5;
		float3 u_xlat6;
		float3 u_xlat16_7;
		float3 u_xlat16_8;
		float3 u_xlat9;
		int u_xlatb9;
		float3 u_xlat10;
		float3 u_xlat16_11;
		float3 u_xlat12;
		float2 u_xlat21;
		float u_xlat27;
		int u_xlatb27;
		float u_xlat28;
		float u_xlat16_29;
		float u_xlat16_31;
		OUT_Data_Frag frag(v2f in_f)
		{
			OUT_Data_Frag out_f;
			u_xlat0_d.x = in_f.texcoord2.w;
			u_xlat0_d.y = in_f.texcoord3.w;
			u_xlat0_d.z = in_f.texcoord4.w;
			u_xlat0_d.xyz = ((-u_xlat0_d.xyz) + _WorldSpaceCameraPos.xyz);
			u_xlat0_d.xyz = normalize(u_xlat0_d.xyz);
			float3 viewDir = u_xlat0_d.xyz;

			u_xlat10_1.xyz = tex2D(_BumpMap, in_f.texcoord.zw).xyz;
			u_xlat16_2.xyz = ((u_xlat10_1.xyz * float3(2, 2, 2)) + float3(-1, (-1), (-1)));
			u_xlat1_d.x = (u_xlat16_2.x * _BumpScale);
			u_xlat3_d.x = u_xlat1_d.x;
			u_xlat3_d.yz = u_xlat16_2.yz;
			u_xlat16_2.z = dot(in_f.texcoord4.xyz, u_xlat3_d.xyz);
			u_xlat1_d.yz = u_xlat3_d.yz;
			u_xlat16_2.x = dot(in_f.texcoord2.xyz, u_xlat1_d.xyz);
			u_xlat16_2.y = dot(in_f.texcoord3.xyz, u_xlat3_d.xyz);
			u_xlat27 = dot((-u_xlat0_d.xyz), u_xlat16_2.xyz);
			u_xlat27 = (u_xlat27 + u_xlat27);
			u_xlat1_d.xyz = ((u_xlat16_2.xyz * (-float3(u_xlat27, u_xlat27, u_xlat27))) + (-u_xlat0_d.xyz));
			u_xlat1_d.xyz = normalize(u_xlat1_d.xyz);
			u_xlat16_4.xyz = normalize(u_xlat16_2.xyz);
			u_xlat16_29 = dot(u_xlat1_d.xyz, u_xlat16_4.xyz);
			u_xlat10_1.xyz = texCUBE(_Cube, u_xlat1_d.xyz).xyz;
			u_xlat16_4.xyz = (u_xlat10_1.xyz * float3(float3(_Reflection, _Reflection, _Reflection)));
			u_xlat16_29 = ((-u_xlat16_29) + 1);
			u_xlat16_29 = log2(abs(u_xlat16_29));
			u_xlat16_31 = min(_FrezFalloff, 1);
			u_xlat16_29 = (u_xlat16_29 * u_xlat16_31);
			u_xlat16_29 = exp2(u_xlat16_29);
			u_xlat16_29 = (u_xlat16_29 + _Gloss);
			u_xlat27 = (u_xlat16_29 * _Alpha);
			u_xlat10_1.xyz = tex2D(_AlphaTex, in_f.texcoord1.xy).xyz;
			u_xlat28 = (u_xlat10_1.z * _AlphaB_Strength);
			u_xlat3_d.y = (u_xlat27 * u_xlat28);
			u_xlat3_d.x = (u_xlat28 * _Shininess);
			u_xlat21.xy = (u_xlat3_d.xy * float2(float2(_AlphaA_Strength, _AlphaA_Strength)));
			u_xlat16_29 = (u_xlat10_1.x * _FlowColor.w);
			u_xlatb1 = (u_xlat16_29 == 0);
			u_xlat16_5.xy = (int(u_xlatb1)) ? (u_xlat3_d.xy) : (u_xlat21.xy);
			u_xlatb3 = (0 < _HitColorValue);
			u_xlat16_31 = (u_xlatb3) ? (_Shininess) : (u_xlat16_5.x);
			u_xlat16_5.x = (u_xlatb3) ? (u_xlat27) : (u_xlat16_5.y);
			u_xlat16_31 = (u_xlat16_31 * 128);
			u_xlat12.xyz = normalize(u_xlat16_2.xyz);
			float3 normal = u_xlat12;

			u_xlat16_2.x = dot(u_xlat12.xyz, u_xlat0_d.xyz);
			u_xlat16_2.y = dot(u_xlat12.xyz, _WorldSpaceLightPos0.xyz);
			u_xlat16_2.xy = max(u_xlat16_2.xy, float2(0, 0));
			u_xlat16_2.x = log2(u_xlat16_2.x);
			u_xlat16_2.x = (u_xlat16_2.x * u_xlat16_31);
			u_xlat16_2.x = exp2(u_xlat16_2.x);
			u_xlat16_2.x = (u_xlat16_5.x * u_xlat16_2.x);
			u_xlat16_5.xyz = (_LightColor0.xyz * _SpecColor.xyz);
			u_xlat16_5.xyz = (u_xlat16_2.xxx * u_xlat16_5.xyz);
			u_xlatb0 = (u_xlat10_1.z >= 0.5);
			u_xlat9.xyz = (float3(u_xlat28, u_xlat28, u_xlat28) * _Color.xyz);
			u_xlat12.xyz = (float3(u_xlat28, u_xlat28, u_xlat28) * u_xlat16_4.xyz);
			u_xlat6.xyz = tex2D(_MainTex, in_f.texcoord.xy).xyz;
			float3 Albedo = u_xlat6.xyz;

			u_xlat9.xyz = (u_xlat9.xyz * u_xlat6.xyz);
			u_xlat16_7.xyz = (int(u_xlatb0)) ? (u_xlat9.xyz) : (u_xlat6.xyz);
			u_xlat0_d.x = dot(u_xlat16_7.xyz, _TestGrayColor.xyz);
			u_xlatb9 = (0 < _TestGrayFlag);
			u_xlat16_8.xyz = (int(u_xlatb9)) ? (u_xlat0_d.xxx) : (u_xlat16_7.xyz);
			u_xlat16_7.xyz = (int(u_xlatb3)) ? (u_xlat16_8.xyz) : (u_xlat16_7.xyz);
			u_xlat16_2.xzw = ((float3(u_xlat16_29, u_xlat16_29, u_xlat16_29) * _FlowColor.xyz) + u_xlat16_7.xyz);
			u_xlat16_7.xyz = (u_xlat16_2.xzw * float3(float3(_Albedo, _Albedo, _Albedo)));
			u_xlat16_2.xzw = (u_xlat10_1.yyy * u_xlat16_2.xzw);
			u_xlat16_8.xyz = (u_xlat16_7.xyz * _LightColor0.xyz);
			u_xlat16_5.xyz = ((u_xlat16_8.xyz * u_xlat16_2.yyy) + u_xlat16_5.xyz);
			u_xlat16_5.xyz = (u_xlat16_5.xyz + u_xlat16_5.xyz);
			u_xlat16_5.xyz = ((u_xlat16_7.xyz * in_f.texcoord5.xyz) + u_xlat16_5.xyz);
			u_xlat16_7.xyz = ((u_xlat16_2.xzw * u_xlat16_4.xyz) + (-u_xlat16_4.xyz));
			u_xlat0_d.xyz = ((u_xlat16_2.xzw * u_xlat12.xyz) + (-u_xlat12.xyz));
			u_xlat16_2.x = dot(u_xlat16_4.xyz, float3(0.219999999, 0.707000017, 0.0710000023));
			u_xlat16_2.x = clamp(u_xlat16_2.x, 0, 1);
			u_xlat16_2.x = (((-u_xlat16_2.x) * u_xlat16_2.x) + 1);
			u_xlat16_11.xyz = ((u_xlat16_2.xxx * u_xlat16_7.xyz) + u_xlat16_4.xyz);
			u_xlat0_d.xyz = ((u_xlat16_2.xxx * u_xlat0_d.xyz) + u_xlat12.xyz);
			u_xlat10.xyz = (u_xlat16_11.xyz * float3(float3(_AlphaA_Strength, _AlphaA_Strength, _AlphaA_Strength)));
			u_xlat12.xyz = (u_xlat0_d.xyz * float3(float3(_AlphaA_Strength, _AlphaA_Strength, _AlphaA_Strength)));
			u_xlat16_2.xyz = (int(u_xlatb1)) ? (u_xlat0_d.xyz) : (u_xlat12.xyz);
			u_xlat16_2.xyz = (int(u_xlatb3)) ? (u_xlat10.xyz) : (u_xlat16_2.xyz);
			u_xlat16_4.xyz = ((u_xlat16_2.xyz * float3(float3(_FrozenSaturation, _FrozenSaturation, _FrozenSaturation))) + _FrozenColor.xyz);
			u_xlat0_d.xyz = (u_xlat16_4.xyz * float3(float3(_FrozenColorValue, _FrozenColorValue, _FrozenColorValue)));
			u_xlatb27 = (0 < _FrozenColorValue);
			u_xlat16_2.xyz = (int(u_xlatb27)) ? (u_xlat0_d.xyz) : (u_xlat16_2.xyz);
			u_xlat16_4.xyz = (_HitColor.xyz + (-_PreHitColor.xyz));
			u_xlat0_d.xyz = ((u_xlat16_4.xyz * float3(_HitAniValue, _HitAniValue, _HitAniValue)) + _PreHitColor.xyz);
			u_xlat0_d.xyz = ((u_xlat16_2.xyz * float3(_HitSaturation, _HitSaturation, _HitSaturation)) + u_xlat0_d.xyz);
			u_xlat16_4.xyz = (u_xlat0_d.xyz * float3(_HitColorValue, _HitColorValue, _HitColorValue));
			u_xlat16_2.xyz = (int(u_xlatb3)) ? (u_xlat16_4.xyz) : (u_xlat16_2.xyz);

			
			half3 ambient_contrib = ShadeSH9(float4(normal, 1));
			float3 ambient = 0.03 * Albedo;
			float3 iblDiffuse = max(half3(0, 0, 0), ambient_contrib + ambient);
			float3 iblDiffuseResult = iblDiffuse  * Albedo;
			float3 IndirectResult = iblDiffuseResult;// +iblSpecularResult;
			//IndirectResult = float3(0, 0, 0);

			out_f.color.xyz = u_xlat16_2.xyz + u_xlat16_5.xyz + IndirectResult.xyz;
			//out_f.color.xyz = saturate(u_xlat16_5.xyz + IndirectResult.xyz);
			//out_f.color.xyz = u_xlat16_5.xyz + IndirectResult.xyz;
			out_f.color.w = 1;
			return out_f;
		}


		ENDCG

	  } // end phase
	  Pass // ind: 2, name: FORWARD
	  {
		Name "FORWARD"
		Tags
		{
		  "IGNOREPROJECTOR" = "False"
		  "LIGHTMODE" = "FORWARDADD"
		  "QUEUE" = "Geometry+200"
		  "RenderType" = "Opaque"
		}
		ZWrite Off
		Blend One One
			// m_ProgramMask = 6
			CGPROGRAM
			#pragma multi_compile POINT
			//#pragma target 4.0

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
			#define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
			#define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
			#define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)


			#define CODE_BLOCK_VERTEX
			// float4x4 unity_ObjectToWorld;
			// float4x4 unity_WorldToObject;
			// float4 unity_WorldTransformParams;
			// float4x4 unity_MatrixVP;
			 float4x4 unity_WorldToLight;
			 float4 _MainTex_ST;
			 float4 _BumpMap_ST;
			 float4 _AlphaTex_ST;
			// float3 _WorldSpaceCameraPos;
			// float4 _WorldSpaceLightPos0;
			 float4 _LightColor0;
			 float4 _SpecColor;
			 float _BumpScale;
			 float _Alpha;
			 float _AlphaA_Strength;
			 float _AlphaB_Strength;
			 float4 _FlowColor;
			 float4 _Color;
			 float _HitColorValue;
			 float _TestGrayFlag;
			 float4 _TestGrayColor;
			 float _Shininess;
			 float _Gloss;
			 float _Albedo;
			 float _FrezFalloff;
			 sampler2D _BumpMap;
			 sampler2D _AlphaTex;
			 sampler2D _MainTex;
			 sampler2D _LightTexture0;
			struct appdata_t
			{
				float4 vertex :POSITION0;
				float4 tangent :TANGENT0;
				float3 normal :NORMAL0;
				float4 texcoord :TEXCOORD0;
			};

			struct OUT_Data_Vert
			{
				float4 texcoord :TEXCOORD0;
				float2 texcoord1 :TEXCOORD1;
				float3 texcoord2 :TEXCOORD2;
				float3 texcoord3 :TEXCOORD3;
				float3 texcoord4 :TEXCOORD4;
				float3 texcoord5 :TEXCOORD5;
				float3 texcoord6 :TEXCOORD6;
				float4 texcoord7 :TEXCOORD7;
				float4 vertex :SV_POSITION;
			};

			struct v2f
			{
				float4 texcoord :TEXCOORD0;
				float2 texcoord1 :TEXCOORD1;
				float3 texcoord2 :TEXCOORD2;
				float3 texcoord3 :TEXCOORD3;
				float3 texcoord4 :TEXCOORD4;
				float3 texcoord5 :TEXCOORD5;
			};

			struct OUT_Data_Frag
			{
				float4 color :SV_Target0;
			};

			float4 u_xlat0;
			float4 u_xlat1;
			float4 u_xlat2;
			float3 u_xlat3;
			float u_xlat13;
			OUT_Data_Vert vert(appdata_t in_v)
			{
				OUT_Data_Vert out_v;
				out_v.vertex = UnityObjectToClipPos(in_v.vertex);
				out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
				out_v.texcoord.zw = TRANSFORM_TEX(in_v.texcoord.xy, _BumpMap);
				out_v.texcoord1.xy = TRANSFORM_TEX(in_v.texcoord.xy, _AlphaTex);
				u_xlat1.y = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
				u_xlat1.z = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
				u_xlat1.x = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
				u_xlat1.xyz = normalize(u_xlat1.xyz);
				u_xlat2.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).yzx);
				u_xlat2.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).yzx * in_v.tangent.xxx) + u_xlat2.xyz);
				u_xlat2.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).yzx * in_v.tangent.zzz) + u_xlat2.xyz);
				u_xlat2.xyz = normalize(u_xlat2.xyz);
				u_xlat3.xyz = (u_xlat1.xyz * u_xlat2.xyz);
				u_xlat3.xyz = ((u_xlat1.zxy * u_xlat2.yzx) + (-u_xlat3.xyz));
				u_xlat13 = (in_v.tangent.w * unity_WorldTransformParams.w);
				u_xlat3.xyz = (float3(u_xlat13, u_xlat13, u_xlat13) * u_xlat3.xyz);
				out_v.texcoord2.y = u_xlat3.x;
				out_v.texcoord2.x = u_xlat2.z;
				out_v.texcoord2.z = u_xlat1.y;
				out_v.texcoord3.x = u_xlat2.x;
				out_v.texcoord4.x = u_xlat2.y;
				out_v.texcoord3.z = u_xlat1.z;
				out_v.texcoord4.z = u_xlat1.x;
				out_v.texcoord3.y = u_xlat3.y;
				out_v.texcoord4.y = u_xlat3.z;
				out_v.texcoord5.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
				u_xlat0 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
				u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_WorldToLight).xyz);
				u_xlat1.xyz = ((conv_mxt4x4_0(unity_WorldToLight).xyz * u_xlat0.xxx) + u_xlat1.xyz);
				u_xlat0.xyz = ((conv_mxt4x4_2(unity_WorldToLight).xyz * u_xlat0.zzz) + u_xlat1.xyz);
				out_v.texcoord6.xyz = ((conv_mxt4x4_3(unity_WorldToLight).xyz * u_xlat0.www) + u_xlat0.xyz);
				out_v.texcoord7 = float4(0, 0, 0, 0);
				return out_v;
			}

			#define CODE_BLOCK_FRAGMENT
			float3 u_xlat0_d;
			float3 u_xlat1_d;
			float3 u_xlat10_1;
			int u_xlatb1;
			float3 u_xlat16_2;
			float3 u_xlat3_d;
			float3 u_xlat16_4;
			float3 u_xlat5;
			float3 u_xlat16_6;
			int u_xlatb7;
			int u_xlatb8;
			float u_xlat16_11;
			float2 u_xlat15;
			float u_xlat21;
			float u_xlat16_23;
			OUT_Data_Frag frag(v2f in_f)
			{
				OUT_Data_Frag out_f;
				u_xlat0_d.xyz = ((-in_f.texcoord5.xyz) + _WorldSpaceCameraPos.xyz);
				u_xlat0_d.xyz = normalize(u_xlat0_d.xyz);
				u_xlat10_1.xyz = tex2D(_BumpMap, in_f.texcoord.zw).xyz;
				u_xlat16_2.xyz = ((u_xlat10_1.xyz * float3(2, 2, 2)) + float3(-1, (-1), (-1)));
				u_xlat1_d.x = (u_xlat16_2.x * _BumpScale);
				u_xlat3_d.x = u_xlat1_d.x;
				u_xlat3_d.yz = u_xlat16_2.yz;
				u_xlat16_2.z = dot(in_f.texcoord4.xyz, u_xlat3_d.xyz);
				u_xlat1_d.yz = u_xlat3_d.yz;
				u_xlat16_2.x = dot(in_f.texcoord2.xyz, u_xlat1_d.xyz);
				u_xlat16_2.y = dot(in_f.texcoord3.xyz, u_xlat3_d.xyz);
				u_xlat21 = dot((-u_xlat0_d.xyz), u_xlat16_2.xyz);
				u_xlat21 = (u_xlat21 + u_xlat21);
				u_xlat1_d.xyz = ((u_xlat16_2.xyz * (-float3(u_xlat21, u_xlat21, u_xlat21))) + (-u_xlat0_d.xyz));
				u_xlat1_d.xyz = normalize(u_xlat1_d.xyz);
				u_xlat16_4.xyz = normalize(u_xlat16_2.xyz);
				u_xlat16_23 = dot(u_xlat1_d.xyz, u_xlat16_4.xyz);
				u_xlat16_23 = ((-u_xlat16_23) + 1);
				u_xlat16_23 = log2(abs(u_xlat16_23));
				u_xlat16_4.x = min(_FrezFalloff, 1);
				u_xlat16_23 = (u_xlat16_23 * u_xlat16_4.x);
				u_xlat16_23 = exp2(u_xlat16_23);
				u_xlat16_23 = (u_xlat16_23 + _Gloss);
				u_xlat21 = (u_xlat16_23 * _Alpha);
				u_xlat10_1.xy = tex2D(_AlphaTex, in_f.texcoord1.xy).xz;
				u_xlat15.x = (u_xlat10_1.y * _AlphaB_Strength);
				u_xlat3_d.y = (u_xlat21 * u_xlat15.x);
				u_xlat3_d.x = (u_xlat15.x * _Shininess);
				u_xlat5.xyz = (u_xlat15.xxx * _Color.xyz);
				u_xlat15.xy = (u_xlat3_d.xy * float2(float2(_AlphaA_Strength, _AlphaA_Strength)));
				u_xlat16_23 = (u_xlat10_1.x * _FlowColor.w);
				u_xlatb1 = (u_xlat10_1.y >= 0.5);
				u_xlatb8 = (u_xlat16_23 == 0);
				u_xlat16_4.xy = (int(u_xlatb8)) ? (u_xlat3_d.xy) : (u_xlat15.xy);
				u_xlatb8 = (0 < _HitColorValue);
				u_xlat16_4.x = (u_xlatb8) ? (_Shininess) : (u_xlat16_4.x);
				u_xlat16_11 = (u_xlatb8) ? (u_xlat21) : (u_xlat16_4.y);
				u_xlat16_4.x = (u_xlat16_4.x * 128);
				u_xlat3_d.xyz = normalize(u_xlat16_2.xyz);
				u_xlat16_2.x = dot(u_xlat3_d.xyz, u_xlat0_d.xyz);
				u_xlat16_2.x = max(u_xlat16_2.x, 0);
				u_xlat16_2.x = log2(u_xlat16_2.x);
				u_xlat16_2.x = (u_xlat16_2.x * u_xlat16_4.x);
				u_xlat16_2.x = exp2(u_xlat16_2.x);
				u_xlat16_2.x = (u_xlat16_11 * u_xlat16_2.x);
				u_xlat16_4.xyz = (_LightColor0.xyz * _SpecColor.xyz);
				u_xlat16_2.xyz = (u_xlat16_2.xxx * u_xlat16_4.xyz);
				u_xlat0_d.xyz = tex2D(_MainTex, in_f.texcoord.xy).xyz;
				u_xlat5.xyz = (u_xlat5.xyz * u_xlat0_d.xyz);
				u_xlat16_4.xyz = (int(u_xlatb1)) ? (u_xlat5.xyz) : (u_xlat0_d.xyz);
				u_xlat0_d.x = dot(u_xlat16_4.xyz, _TestGrayColor.xyz);
				u_xlatb7 = (0 < _TestGrayFlag);
				u_xlat16_6.xyz = (int(u_xlatb7)) ? (u_xlat0_d.xxx) : (u_xlat16_4.xyz);
				u_xlat16_4.xyz = (int(u_xlatb8)) ? (u_xlat16_6.xyz) : (u_xlat16_4.xyz);
				u_xlat16_4.xyz = ((float3(u_xlat16_23, u_xlat16_23, u_xlat16_23) * _FlowColor.xyz) + u_xlat16_4.xyz);
				u_xlat16_4.xyz = (u_xlat16_4.xyz * float3(float3(_Albedo, _Albedo, _Albedo)));
				u_xlat16_4.xyz = (u_xlat16_4.xyz * _LightColor0.xyz);
				u_xlat0_d.xyz = ((-in_f.texcoord5.xyz) + _WorldSpaceLightPos0.xyz);
				u_xlat0_d.xyz = normalize(u_xlat0_d.xyz);
				u_xlat16_23 = dot(u_xlat3_d.xyz, u_xlat0_d.xyz);
				u_xlat16_23 = max(u_xlat16_23, 0);
				u_xlat16_2.xyz = ((u_xlat16_4.xyz * float3(u_xlat16_23, u_xlat16_23, u_xlat16_23)) + u_xlat16_2.xyz);
				u_xlat0_d.xyz = (in_f.texcoord5.yyy * conv_mxt4x4_1(unity_WorldToLight).xyz);
				u_xlat0_d.xyz = ((conv_mxt4x4_0(unity_WorldToLight).xyz * in_f.texcoord5.xxx) + u_xlat0_d.xyz);
				u_xlat0_d.xyz = ((conv_mxt4x4_2(unity_WorldToLight).xyz * in_f.texcoord5.zzz) + u_xlat0_d.xyz);
				u_xlat0_d.xyz = (u_xlat0_d.xyz + conv_mxt4x4_3(unity_WorldToLight).xyz);
				u_xlat0_d.x = dot(u_xlat0_d.xyz, u_xlat0_d.xyz);
				u_xlat0_d.x = tex2D(_LightTexture0, u_xlat0_d.xx).x;
				u_xlat16_23 = (u_xlat0_d.x + u_xlat0_d.x);
				out_f.color.xyz = (float3(u_xlat16_23, u_xlat16_23, u_xlat16_23) * u_xlat16_2.xyz);
				out_f.color.w = 1;
				return out_f;
			}


			ENDCG

		  } // end phase
    Pass // ind: 2, name: 
    {
      Tags
      { 
      }
      ZWrite Off
      Stencil
      { 
        Ref 0
		Comp equal
		Pass incrWrap
		Fail keep
		ZFail keep
      } 
      Blend SrcAlpha OneMinusSrcAlpha
      ColorMask RGB
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      // float4x4 unity_ObjectToWorld;
      // float4x4 unity_MatrixVP;
       float4 _ShadowPlane;
       float4 _ShadowProjDir;
       float4 _WorldPos;
       float _ShadowInvLen;
       float _Scale;
       float4 _ShadowFadeParams;
       float _Alpha;
      struct appdata_t
      {
          float4 vertex :POSITION0;
      };
      
      struct OUT_Data_Vert
      {
          float4 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float u_xlat2;
      float u_xlat6;
      float u_xlat7;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.xyz = (in_v.vertex.xyz * float3(float3(_Scale, _Scale, _Scale)));
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat0.xyw = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * u_xlat0.zzz) + u_xlat0.xyw);
          u_xlat0.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
          u_xlat6 = dot(_ShadowPlane.xyz, u_xlat0.xyz);
          u_xlat6 = ((-u_xlat6) + _ShadowPlane.w);
          u_xlat1.x = dot(_ShadowProjDir, _ShadowProjDir);
          u_xlat1.x = rsqrt(u_xlat1.x);
          u_xlat1.xyz = (u_xlat1.xxx * _ShadowProjDir.xyz);
          u_xlat7 = dot(_ShadowPlane.xyz, u_xlat1.xyz);
          u_xlat6 = (u_xlat6 / u_xlat7);
          u_xlat0.xyz = ((float3(u_xlat6, u_xlat6, u_xlat6) * u_xlat1.xyz) + u_xlat0.xyz);
          u_xlat1 = (u_xlat0.yyyy * conv_mxt4x4_1(unity_MatrixVP));
          u_xlat1 = ((conv_mxt4x4_0(unity_MatrixVP) * u_xlat0.xxxx) + u_xlat1);
          u_xlat1 = ((conv_mxt4x4_2(unity_MatrixVP) * u_xlat0.zzzz) + u_xlat1);
          u_xlat0.xyz = ((-u_xlat0.xyz) + _WorldPos.xyz);
          u_xlat0.x = length(u_xlat0.xyz);
          u_xlat0.x = ((u_xlat0.x * _ShadowInvLen) + (-_ShadowFadeParams.x));
          u_xlat0.x = clamp(u_xlat0.x, 0, 1);
          u_xlat0.x = ((-u_xlat0.x) + 1);
          u_xlat0.x = log2(u_xlat0.x);
          u_xlat0.x = (u_xlat0.x * _ShadowFadeParams.y);
          u_xlat0.x = exp2(u_xlat0.x);
          out_v.vertex = (u_xlat1 + conv_mxt4x4_3(unity_MatrixVP));
          u_xlat2 = (_ShadowFadeParams.z * _Alpha);
          out_v.texcoord.w = (u_xlat2 * u_xlat0.x);
          out_v.texcoord.xyz = float3(0, 0, 0);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          out_f.color = in_f.texcoord;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
