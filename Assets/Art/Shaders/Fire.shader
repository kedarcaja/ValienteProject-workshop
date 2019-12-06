
Shader "Medieval Kingdom/Fire"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (0.1617647,0.1549069,0.1486808,0)
		_Emmisive_color("Emmisive_color", Color) = (1,0.3529412,0,0)
		_Emmisive_Frequency("Emmisive_Frequency", Range( 0 , 3)) = 0.5366361
		_Emmisivemultiply("Emmisive multiply", Range( 0 , 40)) = 19.7
		_Base_Texture("Base_Texture", 2D) = "white" {}
		_Cracksmapcolor("Cracks map color", Color) = (1,0.3517241,0,0)
		_Cracksmapintensity("Cracks map intensity", Range( 0 , 15)) = 4.235294
		_Overallermmisiveintensity("Overall ermmisive intensity", Range( 0 , 15)) = 5
		_Vertex_offset_speed("Vertex_offset_speed", Range( 0 , 1)) = 0.5
		_Vertex_offset_intensity("Vertex_offset_intensity", Range( 0 , 1)) = 0.15
		_Smallnoisecolor("Small noise color", Color) = (1,0.3517241,0,0)
		_Smallnoiseshift("Small noise shift", Range( 0 , 15)) = 1
		_Cracks_map("Cracks_map", 2D) = "white" {}
		_Small_noise_map("Small_noise_map", 2D) = "white" {}
		_Fire_glow_map("Fire_glow_map", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Base_Texture;
		uniform float4 _Base_Texture_ST;
		uniform float4 _BaseColor;
		uniform float4 _Cracksmapcolor;
		uniform sampler2D _Cracks_map;
		uniform float4 _Cracks_map_ST;
		uniform float _Cracksmapintensity;
		uniform float4 _Smallnoisecolor;
		uniform sampler2D _Small_noise_map;
		uniform float _Smallnoiseshift;
		uniform sampler2D _Fire_glow_map;
		uniform float _Vertex_offset_speed;
		uniform float _Vertex_offset_intensity;
		uniform float4 _Emmisive_color;
		uniform float _Emmisivemultiply;
		uniform float _Emmisive_Frequency;
		uniform float _Overallermmisiveintensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord486 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float2 panner488 = ( uv_TexCoord486 + ( _Time.x * _Vertex_offset_speed ) * float2( 0.5,0.5 ));
			float4 _vertex_offset492 = ( tex2Dlod( _Base_Texture, float4( panner488, 0, 0.0) ) * _Vertex_offset_intensity );
			v.vertex.xyz += _vertex_offset492.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Base_Texture = i.uv_texcoord * _Base_Texture_ST.xy + _Base_Texture_ST.zw;
			float4 blendOpSrc95 = tex2D( _Base_Texture, uv_Base_Texture );
			float4 blendOpDest95 = _BaseColor;
			float4 temp_output_95_0 = ( saturate( ( blendOpSrc95 * blendOpDest95 ) ));
			float2 uv_Cracks_map = i.uv_texcoord * _Cracks_map_ST.xy + _Cracks_map_ST.zw;
			float4 lerpResult356 = lerp( temp_output_95_0 , _Cracksmapcolor , ( tex2D( _Cracks_map, uv_Cracks_map ) * ( float4(1,1,1,0) * _Cracksmapintensity ) ));
			float4 blendOpSrc357 = temp_output_95_0;
			float4 blendOpDest357 = lerpResult356;
			float4 temp_output_357_0 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc357 ) * ( 1.0 - blendOpDest357 ) ) ));
			float2 uv_TexCoord476 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner479 = ( uv_TexCoord476 + ( _Time.x * 0.01 ) * float2( 0.5,0.5 ));
			float2 _time2480 = panner479;
			float4 lerpResult365 = lerp( temp_output_357_0 , _Smallnoisecolor , ( tex2D( _Small_noise_map, _time2480 ) * ( float4(1,1,1,0) * _Smallnoiseshift ) ).r);
			float4 blendOpSrc366 = temp_output_357_0;
			float4 blendOpDest366 = lerpResult365;
			float4 temp_output_366_0 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc366 ) * ( 1.0 - blendOpDest366 ) ) ));
			float2 uv_TexCoord313 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner315 = ( uv_TexCoord313 + ( _Time.x * 0.02 ) * float2( 0.5,0.5 ));
			float2 _time436 = panner315;
			float4 tex2DNode319 = tex2D( _Fire_glow_map, _time436 );
			float4 lerpResult241 = lerp( temp_output_366_0 , float4(1,0.3517241,0,0) , tex2DNode319.r);
			float4 blendOpSrc243 = temp_output_366_0;
			float4 blendOpDest243 = lerpResult241;
			float4 _fire_color442 = ( saturate( (( blendOpDest243 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest243 - 0.5 ) ) * ( 1.0 - blendOpSrc243 ) ) : ( 2.0 * blendOpDest243 * blendOpSrc243 ) ) ));
			float2 uv_TexCoord486 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner488 = ( uv_TexCoord486 + ( _Time.x * _Vertex_offset_speed ) * float2( 0.5,0.5 ));
			float4 _vertex_offset492 = ( tex2D( _Base_Texture, panner488 ) * _Vertex_offset_intensity );
			float4 blendOpSrc500 = _fire_color442;
			float4 blendOpDest500 = _vertex_offset492;
			o.Albedo = ( saturate(  (( blendOpSrc500 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc500 - 0.5 ) ) * ( 1.0 - blendOpDest500 ) ) : ( 2.0 * blendOpSrc500 * blendOpDest500 ) ) )).rgb;
			float _frequency433 = (sin( ( _Time.y * _Emmisive_Frequency ) )*0.5 + 0.5);
			float4 blendOpSrc395 = lerpResult356;
			float4 blendOpDest395 = ( ( ( _Emmisive_color * _Emmisivemultiply ) * _frequency433 ) * ( tex2DNode319 * ( float4(1,1,1,0) * 10.0 ) ) );
			float4 blendOpSrc396 = lerpResult365;
			float4 blendOpDest396 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc395 ) * ( 1.0 - blendOpDest395 ) ) ));
			float4 _emmisive445 = ( ( saturate( ( 1.0 - ( 1.0 - blendOpSrc396 ) * ( 1.0 - blendOpDest396 ) ) )) * _Overallermmisiveintensity );
			o.Emission = _emmisive445.rgb;
			o.Smoothness = 0.0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
