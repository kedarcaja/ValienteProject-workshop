
Shader "Medieval Kingdom/Parallax"
{
	Properties
	{
		_Global_Tiling("Global_Tiling", Float) = 2
		_Base_Color("Base_Color", Color) = (0.3455882,0.3238225,0.2769788,0)
		_Detail_mask_color("Detail_mask_color", Color) = (0.9264706,0,0,0)
		_Detail_mask_level("Detail_mask_level", Range( 0 , 1)) = 1
		_Detail_mask_2_color("Detail_mask_2_color", Color) = (0.3466771,0.4411765,0.01297579,0)
		_Detail_mask_2_level("Detail_mask_2_level", Range( 0 , 1)) = 0
		_SmoothnessScale("Smoothness Scale", Range( 0 , 2)) = 1
		_NormalScale("Normal Scale", Range( 0 , 2)) = 1
		_Ambient_Occulsion_level("Ambient_Occulsion_level", Range( 0 , 2)) = 1
		_Parallax("Parallax", Range( 0 , 0.02)) = 0
		_Albedo_smoothness_map_input("Albedo_smoothness_map_input", 2D) = "white" {}
		_HeightMap("HeightMap", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		_Detail_mask("Detail_mask", 2D) = "white" {}
		_Detail_mask_2("Detail_mask_2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			fixed2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform fixed _NormalScale;
		uniform sampler2D _Normal;
		uniform fixed _Global_Tiling;
		uniform sampler2D _HeightMap;
		uniform float4 _HeightMap_ST;
		uniform fixed _Parallax;
		uniform fixed4 _Base_Color;
		uniform sampler2D _Albedo_smoothness_map_input;
		uniform sampler2D _Detail_mask;
		uniform fixed _Detail_mask_level;
		uniform fixed4 _Detail_mask_color;
		uniform fixed4 _Detail_mask_2_color;
		uniform sampler2D _Detail_mask_2;
		uniform fixed _Detail_mask_2_level;
		uniform sampler2D _Occlusion;
		uniform fixed _Ambient_Occulsion_level;
		uniform fixed _SmoothnessScale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			fixed2 temp_cast_0 = (_Global_Tiling).xx;
			float2 uv_TexCoord117 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			float2 Offset4 = ( ( tex2D( _HeightMap, uv_HeightMap ).r - 1 ) * i.viewDir.xy * _Parallax ) + uv_TexCoord117;
			float2 Offset49 = ( ( tex2D( _HeightMap, Offset4 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset4;
			float2 Offset52 = ( ( tex2D( _HeightMap, Offset49 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset49;
			float2 Offset54 = ( ( tex2D( _HeightMap, Offset52 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset52;
			float2 _parallax_offset13 = Offset54;
			float3 _normal162 = UnpackScaleNormal( tex2D( _Normal, _parallax_offset13 ) ,_NormalScale );
			o.Normal = _normal162;
			fixed4 tex2DNode1 = tex2D( _Albedo_smoothness_map_input, _parallax_offset13 );
			fixed4 blendOpSrc122 = _Base_Color;
			fixed4 blendOpDest122 = tex2DNode1;
			float4 temp_output_135_0 = ( tex2D( _Detail_mask, _parallax_offset13 ) * _Detail_mask_level );
			fixed4 blendOpSrc138 = temp_output_135_0;
			fixed4 blendOpDest138 = _Detail_mask_color;
			float4 lerpResult141 = lerp( ( saturate( (( blendOpDest122 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest122 - 0.5 ) ) * ( 1.0 - blendOpSrc122 ) ) : ( 2.0 * blendOpDest122 * blendOpSrc122 ) ) )) , ( saturate( ( blendOpSrc138 * blendOpDest138 ) )) , temp_output_135_0.r);
			float4 lerpResult143 = lerp( lerpResult141 , _Detail_mask_2_color , ( tex2D( _Detail_mask_2, _parallax_offset13 ) * _Detail_mask_2_level ));
			fixed4 blendOpSrc144 = lerpResult141;
			fixed4 blendOpDest144 = lerpResult143;
			float4 temp_output_144_0 = ( saturate( (( blendOpSrc144 > 0.5 ) ? max( blendOpDest144, 2.0 * ( blendOpSrc144 - 0.5 ) ) : min( blendOpDest144, 2.0 * blendOpSrc144 ) ) ));
			float4 _AO154 = tex2D( _Occlusion, _parallax_offset13 );
			fixed4 blendOpSrc127 = fixed4(1,1,1,0);
			fixed4 blendOpDest127 = _AO154;
			float4 lerpResult130 = lerp( temp_output_144_0 , fixed4(0,0,0,0) , ( ( saturate( abs( blendOpSrc127 - blendOpDest127 ) )) * _Ambient_Occulsion_level ).r);
			fixed4 blendOpSrc131 = temp_output_144_0;
			fixed4 blendOpDest131 = lerpResult130;
			float4 _albedo_blending164 = ( saturate( min( blendOpSrc131 , blendOpDest131 ) ));
			o.Albedo = _albedo_blending164.rgb;
			float _smoothness169 = ( tex2DNode1.a * _SmoothnessScale );
			o.Smoothness = _smoothness169;
			o.Occlusion = _AO154.r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
