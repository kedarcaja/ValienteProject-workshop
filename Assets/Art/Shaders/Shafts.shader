
Shader "Medieval Kingdom/Shafts"
{
	Properties
	{
		_Shaftcolor("Shaft color", Color) = (1,0.8068966,0,0)
		_Opacity_shift("Opacity_shift", Range( 0.01 , 1)) = 0.66
		_Frequency("Frequency", Range( 0 , 3)) = 0
		_Frequency_scale("Frequency_scale", Range( 0 , 0.5)) = 0.25
		[Toggle(_MASKOFFON_ON)] _Maskoffon("Mask off/on", Float) = 0
		_Emmisionlevel("Emmision level", Range( 0.01 , 50)) = 0.01
		_Texture2blend("Texture 2 blend", Range( 0 , 1)) = 0.5
		_Texture3blend("Texture 3 blend", Range( 0 , 1)) = 0.5
		_Noise_level("Noise_level", Range( 0 , 1)) = 0.5
		_Texture1tiling("Texture1 tiling", Vector) = (1,1,0,0)
		_Texture2tiling("Texture2 tiling", Vector) = (1,1,0,0)
		_Texture3tiling("Texture3 tiling", Vector) = (1,1,0,0)
		_Noise_tilling("Noise_tilling", Vector) = (3,3,0,0)
		_Texture1speed("Texture1 speed", Vector) = (0.08,0,0,0)
		_Texture2speed("Texture2 speed", Vector) = (0.1,0,0,0)
		_Texture3speed("Texture3 speed", Vector) = (-0.1,0,0,0)
		_Noise_speed("Noise_speed", Vector) = (-0.02,0.01,0,0)
		_Texture1("Texture1", 2D) = "white" {}
		_Texture2("Texture2", 2D) = "white" {}
		_Texture3("Texture3", 2D) = "white" {}
		_Texture4("Texture4", 2D) = "white" {}
		_Ray_mask("Ray_mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#pragma shader_feature _MASKOFFON_ON
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture1;
		uniform float2 _Texture1speed;
		uniform float2 _Texture1tiling;
		uniform sampler2D _Texture2;
		uniform float2 _Texture2speed;
		uniform float2 _Texture2tiling;
		uniform float _Texture2blend;
		uniform sampler2D _Texture3;
		uniform float2 _Texture3speed;
		uniform float2 _Texture3tiling;
		uniform float _Texture3blend;
		uniform sampler2D _Ray_mask;
		uniform float4 _Ray_mask_ST;
		uniform sampler2D _Texture4;
		uniform float2 _Noise_speed;
		uniform float2 _Noise_tilling;
		uniform float _Noise_level;
		uniform float4 _Shaftcolor;
		uniform float _Emmisionlevel;
		uniform float _Frequency;
		uniform float _Frequency_scale;
		uniform float _Opacity_shift;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord32 = i.uv_texcoord * _Texture1tiling;
			float2 panner35 = ( _Time.y * _Texture1speed + uv_TexCoord32);
			float2 uv_TexCoord41 = i.uv_texcoord * _Texture2tiling;
			float2 panner42 = ( _Time.y * _Texture2speed + uv_TexCoord41);
			float4 lerpResult93 = lerp( tex2D( _Texture1, panner35 ) , tex2D( _Texture2, panner42 ) , _Texture2blend);
			float2 uv_TexCoord46 = i.uv_texcoord * _Texture3tiling;
			float2 panner48 = ( _Time.y * _Texture3speed + uv_TexCoord46);
			float4 lerpResult94 = lerp( lerpResult93 , tex2D( _Texture3, panner48 ) , _Texture3blend);
			float2 uv_Ray_mask = i.uv_texcoord * _Ray_mask_ST.xy + _Ray_mask_ST.zw;
			float4 blendOpSrc127 = lerpResult94;
			float4 blendOpDest127 = tex2D( _Ray_mask, uv_Ray_mask );
			#ifdef _MASKOFFON_ON
				float4 staticSwitch132 = ( saturate( (( blendOpSrc127 > 0.5 )? ( blendOpDest127 + 2.0 * blendOpSrc127 - 1.0 ) : ( blendOpDest127 + 2.0 * ( blendOpSrc127 - 0.5 ) ) ) ));
			#else
				float4 staticSwitch132 = lerpResult94;
			#endif
			float2 uv_TexCoord112 = i.uv_texcoord * _Noise_tilling;
			float2 panner114 = ( _Time.y * _Noise_speed + uv_TexCoord112);
			float4 lerpResult121 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture4, panner114 ) , lerpResult94.r);
			float4 lerpResult120 = lerp( staticSwitch132 , lerpResult121 , _Noise_level);
			float4 blendOpSrc133 = staticSwitch132;
			float4 blendOpDest133 = lerpResult120;
			float4 _textures75 = ( saturate( 2.0f*blendOpDest133*blendOpSrc133 + blendOpDest133*blendOpDest133*(1.0f - 2.0f*blendOpSrc133) ));
			float4 blendOpSrc33 = _textures75;
			float4 blendOpDest33 = _Shaftcolor;
			float4 _shaft77 = ( saturate( ( blendOpSrc33 * blendOpDest33 ) ));
			o.Albedo = _shaft77.rgb;
			float4 _emmision79 = ( _shaft77 * _Emmisionlevel );
			o.Emission = _emmision79.rgb;
			float _frequency71 = (sin( ( _Time.y * _Frequency ) )*_Frequency_scale + _Frequency_scale);
			float4 lerpResult72 = lerp( _textures75 , float4( 0,0,0,0 ) , _frequency71);
			float4 _opacity84 = ( lerpResult72 * _Opacity_shift );
			o.Alpha = _opacity84.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
