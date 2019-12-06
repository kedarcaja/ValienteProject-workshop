
Shader "Medieval Kingdom/Stones"
{
	Properties
	{
		_Base_color("Base_color", Color) = (0.3919766,0.4150519,0.4264706,0)
		_Material_Smoothness_shift("Material_Smoothness_shift", Range( 0 , 2)) = 1
		_Base_Normal_Intensity("Base_Normal_Intensity", Range( 0 , 2)) = 1
		_Edge_color("Edge_color", Color) = (1,1,1,0)
		_Edge_wear("Edge_wear", Range( 0 , 1)) = 0.9960846
		_Detail_1_level("Detail_1_level", Range( 0 , 2)) = 1
		_Detail_color("Detail_color", Color) = (1,1,1,0)
		_Top_mask_level("Top_mask_level", Range( 0 , 1)) = 1
		_Top_Color("Top_Color", Color) = (0.6654717,0.6985294,0.07704367,0)
		_Top_mask_tiling("Top_mask_tiling", Range( 0 , 8)) = 4
		_Top_mask_smoothness_shift("Top_mask_smoothness_shift", Range( 0 , 1)) = 1
		_Top_mask_normal_intensity("Top_mask_normal_intensity", Range( 0 , 2)) = 0.25
		_AO_shift("AO_shift", Range( 0 , 2)) = 1
		_Albedo_smoothness_map_input("Albedo_smoothness_map_input", 2D) = "white" {}
		_Normal_map_input("Normal_map_input", 2D) = "bump" {}
		_Ambient_Occlusion_map_input("Ambient_Occlusion_map_input", 2D) = "white" {}
		_Top_mask_texture("Top_mask_texture", 2D) = "white" {}
		_Top_mask_normal("Top_mask_normal", 2D) = "bump" {}
		_Edge_mask_map_input("Edge_mask_map_input", 2D) = "white" {}
		_Detail_mask_1_map_input("Detail_mask_1_map_input", 2D) = "white" {}
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

		uniform fixed _Base_Normal_Intensity;
		uniform sampler2D _Normal_map_input;
		uniform float4 _Normal_map_input_ST;
		uniform fixed _Top_mask_normal_intensity;
		uniform sampler2D _Top_mask_normal;
		uniform float _Top_mask_tiling;
		uniform fixed _Top_mask_level;
		uniform sampler2D _Top_mask_texture;
		uniform sampler2D _Albedo_smoothness_map_input;
		uniform float4 _Albedo_smoothness_map_input_ST;
		uniform float4 _Base_color;
		uniform float4 _Detail_color;
		uniform sampler2D _Detail_mask_1_map_input;
		uniform float4 _Detail_mask_1_map_input_ST;
		uniform float _Detail_1_level;
		uniform sampler2D _Ambient_Occlusion_map_input;
		uniform float4 _Ambient_Occlusion_map_input_ST;
		uniform float _AO_shift;
		uniform float4 _Edge_color;
		uniform sampler2D _Edge_mask_map_input;
		uniform float4 _Edge_mask_map_input_ST;
		uniform float _Edge_wear;
		uniform float4 _Top_Color;
		uniform float _Material_Smoothness_shift;
		uniform float _Top_mask_smoothness_shift;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal_map_input = i.uv_texcoord * _Normal_map_input_ST.xy + _Normal_map_input_ST.zw;
			float3 tex2DNode8 = UnpackScaleNormal( tex2D( _Normal_map_input, uv_Normal_map_input ) ,_Base_Normal_Intensity );
			float2 temp_cast_0 = (_Top_mask_tiling).xx;
			float2 uv_TexCoord186 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 _tiling256 = uv_TexCoord186;
			float3 _normal265 = tex2DNode8;
			float3 newWorldNormal224 = WorldNormalVector( i , _normal265 );
			float4 temp_cast_1 = (saturate( ( pow( ( saturate( newWorldNormal224.y ) + 0.12 ) , (1.0 + (0.7 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * _Top_mask_level ) )).xxxx;
			float4 tex2DNode161 = tex2D( _Top_mask_texture, _tiling256 );
			float4 blendOpSrc235 = temp_cast_1;
			float4 blendOpDest235 = tex2DNode161;
			float4 _top_mask276 = ( saturate( (( blendOpSrc235 > 0.5 ) ? max( blendOpDest235, 2.0 * ( blendOpSrc235 - 0.5 ) ) : min( blendOpDest235, 2.0 * blendOpSrc235 ) ) ));
			float3 lerpResult173 = lerp( tex2DNode8 , UnpackScaleNormal( tex2D( _Top_mask_normal, _tiling256 ) ,_Top_mask_normal_intensity ) , _top_mask276.r);
			float3 _normal_blend263 = lerpResult173;
			o.Normal = _normal_blend263;
			float2 uv_Albedo_smoothness_map_input = i.uv_texcoord * _Albedo_smoothness_map_input_ST.xy + _Albedo_smoothness_map_input_ST.zw;
			float4 tex2DNode11 = tex2D( _Albedo_smoothness_map_input, uv_Albedo_smoothness_map_input );
			float4 blendOpSrc12 = tex2DNode11;
			float4 blendOpDest12 = _Base_color;
			float4 temp_output_12_0 = ( saturate( (( blendOpDest12 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest12 - 0.5 ) ) * ( 1.0 - blendOpSrc12 ) ) : ( 2.0 * blendOpDest12 * blendOpSrc12 ) ) ));
			float2 uv_Detail_mask_1_map_input = i.uv_texcoord * _Detail_mask_1_map_input_ST.xy + _Detail_mask_1_map_input_ST.zw;
			float4 lerpResult221 = lerp( temp_output_12_0 , _Detail_color , ( tex2D( _Detail_mask_1_map_input, uv_Detail_mask_1_map_input ) * _Detail_1_level ).r);
			float4 blendOpSrc222 = temp_output_12_0;
			float4 blendOpDest222 = lerpResult221;
			float4 temp_output_222_0 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc222 ) * ( 1.0 - blendOpDest222 ) ) ));
			float4 lerpResult241 = lerp( temp_output_222_0 , float4(1,1,1,0) , ( (_normal265.r + _normal265.g + _normal265.b) / 3 * 1.0 ));
			float4 blendOpSrc242 = temp_output_222_0;
			float4 blendOpDest242 = lerpResult241;
			float4 temp_output_242_0 = ( saturate( (( blendOpDest242 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest242 - 0.5 ) ) * ( 1.0 - blendOpSrc242 ) ) : ( 2.0 * blendOpDest242 * blendOpSrc242 ) ) ));
			float2 uv_Ambient_Occlusion_map_input = i.uv_texcoord * _Ambient_Occlusion_map_input_ST.xy + _Ambient_Occlusion_map_input_ST.zw;
			float4 _AO262 = tex2D( _Ambient_Occlusion_map_input, uv_Ambient_Occlusion_map_input );
			float4 blendOpSrc80 = float4(1,1,1,1);
			float4 blendOpDest80 = _AO262;
			float4 lerpResult78 = lerp( temp_output_242_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc80 - blendOpDest80 ) )) * _AO_shift ).r);
			float4 blendOpSrc79 = temp_output_242_0;
			float4 blendOpDest79 = lerpResult78;
			float4 temp_output_79_0 = ( saturate( min( blendOpSrc79 , blendOpDest79 ) ));
			float2 uv_Edge_mask_map_input = i.uv_texcoord * _Edge_mask_map_input_ST.xy + _Edge_mask_map_input_ST.zw;
			float4 lerpResult70 = lerp( temp_output_79_0 , _Edge_color , ( tex2D( _Edge_mask_map_input, uv_Edge_mask_map_input ) * _Edge_wear ).r);
			float4 blendOpSrc71 = temp_output_79_0;
			float4 blendOpDest71 = lerpResult70;
			float4 _base_stone_color270 = ( saturate( (( blendOpSrc71 > 0.5 ) ? max( blendOpDest71, 2.0 * ( blendOpSrc71 - 0.5 ) ) : min( blendOpDest71, 2.0 * blendOpSrc71 ) ) ));
			float4 lerpResult112 = lerp( _Top_Color , float4( 0,0,0,0 ) , tex2DNode161.r);
			float4 _top_color274 = lerpResult112;
			float4 lerpResult113 = lerp( _base_stone_color270 , _top_color274 , _top_mask276.r);
			float4 blendOpSrc114 = _base_stone_color270;
			float4 blendOpDest114 = lerpResult113;
			float4 _albedo_top_blend282 = ( saturate( ( 0.5 - 2.0 * ( blendOpSrc114 - 0.5 ) * ( blendOpDest114 - 0.5 ) ) ));
			o.Albedo = _albedo_top_blend282.rgb;
			float lerpResult172 = lerp( ( tex2DNode11.a * _Material_Smoothness_shift ) , ( tex2DNode161.a * _Top_mask_smoothness_shift ) , _top_mask276.r);
			float _smoothness284 = lerpResult172;
			o.Smoothness = _smoothness284;
			o.Occlusion = _AO262.r;
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
