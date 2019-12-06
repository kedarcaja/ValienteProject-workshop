
Shader "Medieval Kingdom/Trees"
{
	Properties
	{
		_Base_Color("Base_Color", Color) = (0.282353,0.1411765,0.01960784,0)
		_Base_Smoothness("Base_Smoothness", Range( 0 , 2)) = 1
		_Base_normal_intensity("Base_normal_intensity", Range( 0 , 1)) = 1
		_Moss_Color("Moss_Color", Color) = (0.4138201,0.5607843,0,0)
		_Moss_mask_intensity("Moss_mask_intensity", Range( 0 , 5)) = 4.659523
		_Moss_tiling("Moss_tiling", Range( 0.5 , 10)) = 4
		_Moss_smoothness("Moss_smoothness", Range( 0 , 2)) = 0.3422558
		_Moss_normal_intensity("Moss_normal_intensity", Range( 0 , 2)) = 0
		_Edge_wear_level("Edge_wear_level", Range( 0 , 1)) = 0.5
		_Ambient_occlusion_shift("Ambient_occlusion_shift", Range( 0 , 2)) = 0.5
		_Albedo_smoothness_map_input("Albedo_smoothness_map_input", 2D) = "white" {}
		_Normal_map_input("Normal_map_input", 2D) = "bump" {}
		_World_space_normals_input("World_space_normals_input", 2D) = "white" {}
		_Ambient_Occlusion_map_input("Ambient_Occlusion_map_input", 2D) = "white" {}
		_Edge_mask_map_input("Edge_mask_map_input", 2D) = "white" {}
		_Moss_texture_grayscale("Moss_texture_grayscale", 2D) = "white" {}
		_Moss_Normal("Moss_Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform fixed _Base_normal_intensity;
		uniform sampler2D _Normal_map_input;
		uniform float4 _Normal_map_input_ST;
		uniform fixed _Moss_normal_intensity;
		uniform sampler2D _Moss_Normal;
		uniform float _Moss_tiling;
		uniform sampler2D _World_space_normals_input;
		uniform float4 _World_space_normals_input_ST;
		uniform float _Moss_mask_intensity;
		uniform float4 _Base_Color;
		uniform sampler2D _Albedo_smoothness_map_input;
		uniform float4 _Albedo_smoothness_map_input_ST;
		uniform float4 _Moss_Color;
		uniform sampler2D _Moss_texture_grayscale;
		uniform sampler2D _Edge_mask_map_input;
		uniform float4 _Edge_mask_map_input_ST;
		uniform float _Edge_wear_level;
		uniform sampler2D _Ambient_Occlusion_map_input;
		uniform float4 _Ambient_Occlusion_map_input_ST;
		uniform float _Ambient_occlusion_shift;
		uniform float _Base_Smoothness;
		uniform float _Moss_smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal_map_input = i.uv_texcoord * _Normal_map_input_ST.xy + _Normal_map_input_ST.zw;
			float2 temp_cast_0 = (_Moss_tiling).xx;
			float2 uv_TexCoord316 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 _moss_tiling329 = uv_TexCoord316;
			float2 uv_World_space_normals_input = i.uv_texcoord * _World_space_normals_input_ST.xy + _World_space_normals_input_ST.zw;
			float3 newWorldNormal307 = WorldNormalVector( i , tex2D( _World_space_normals_input, uv_World_space_normals_input ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float _side_mask_alpha338 = ( ( newWorldNormal307.x * saturate( ase_worldNormal.x ) ) * _Moss_mask_intensity );
			float3 lerpResult303 = lerp( UnpackScaleNormal( tex2D( _Normal_map_input, uv_Normal_map_input ) ,_Base_normal_intensity ) , UnpackScaleNormal( tex2D( _Moss_Normal, _moss_tiling329 ) ,_Moss_normal_intensity ) , _side_mask_alpha338);
			float3 _normals_blend335 = lerpResult303;
			o.Normal = _normals_blend335;
			float2 uv_Albedo_smoothness_map_input = i.uv_texcoord * _Albedo_smoothness_map_input_ST.xy + _Albedo_smoothness_map_input_ST.zw;
			float4 tex2DNode279 = tex2D( _Albedo_smoothness_map_input, uv_Albedo_smoothness_map_input );
			float4 blendOpSrc95 = _Base_Color;
			float4 blendOpDest95 = tex2DNode279;
			float4 _base_tree_color334 = ( saturate( (( blendOpDest95 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest95 - 0.5 ) ) * ( 1.0 - blendOpSrc95 ) ) : ( 2.0 * blendOpDest95 * blendOpSrc95 ) ) ));
			float4 tex2DNode311 = tex2D( _Moss_texture_grayscale, _moss_tiling329 );
			float4 lerpResult312 = lerp( _Moss_Color , _base_tree_color334 , tex2DNode311.r);
			float4 lerpResult314 = lerp( _base_tree_color334 , lerpResult312 , _side_mask_alpha338);
			float4 blendOpSrc291 = _base_tree_color334;
			float4 blendOpDest291 = lerpResult314;
			float4 temp_output_291_0 = ( saturate( 	max( blendOpSrc291, blendOpDest291 ) ));
			float2 uv_Edge_mask_map_input = i.uv_texcoord * _Edge_mask_map_input_ST.xy + _Edge_mask_map_input_ST.zw;
			float4 lerpResult275 = lerp( temp_output_291_0 , float4(1,1,1,0) , ( tex2D( _Edge_mask_map_input, uv_Edge_mask_map_input ) * _Edge_wear_level ).r);
			float4 blendOpSrc276 = temp_output_291_0;
			float4 blendOpDest276 = lerpResult275;
			float4 temp_output_276_0 = ( saturate( (( blendOpSrc276 > 0.5 ) ? max( blendOpDest276, 2.0 * ( blendOpSrc276 - 0.5 ) ) : min( blendOpDest276, 2.0 * blendOpSrc276 ) ) ));
			float2 uv_Ambient_Occlusion_map_input = i.uv_texcoord * _Ambient_Occlusion_map_input_ST.xy + _Ambient_Occlusion_map_input_ST.zw;
			float4 _AO317 = tex2D( _Ambient_Occlusion_map_input, uv_Ambient_Occlusion_map_input );
			float4 blendOpSrc285 = float4(1,1,1,0);
			float4 blendOpDest285 = _AO317;
			float4 lerpResult289 = lerp( temp_output_276_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc285 - blendOpDest285 ) )) * _Ambient_occlusion_shift ).r);
			float4 blendOpSrc290 = temp_output_276_0;
			float4 blendOpDest290 = lerpResult289;
			float4 _albedo345 = ( saturate( min( blendOpSrc290 , blendOpDest290 ) ));
			o.Albedo = _albedo345.rgb;
			float4 temp_cast_5 = (( tex2DNode279.a * _Base_Smoothness )).xxxx;
			float4 lerpResult302 = lerp( temp_cast_5 , ( tex2DNode311 * _Moss_smoothness ) , _side_mask_alpha338);
			float4 _smoothness347 = lerpResult302;
			o.Smoothness = _smoothness347.r;
			o.Occlusion = _AO317.r;
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
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
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
