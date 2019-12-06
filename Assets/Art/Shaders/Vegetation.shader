
Shader "Medieval Kingdom/Vegetation"
{
	Properties
	{
		_Base_Color("Base_Color", Color) = (0.3529412,0.5450981,0.2235294,0)
		_Smoothness_Shift("Smoothness_Shift", Range( 0 , 2)) = 1
		_2nd_color("2nd_color", Color) = (1,1,1,0)
		_2nd_color_intensity("2nd_color_intensity", Range( 0 , 1.5)) = 1.5
		_AO_Intensity("AO_Intensity", Range( 0 , 2)) = 1
		_Wind_speed("Wind_speed", Range( 0 , 10)) = 1
		_Wind_power_multiply("Wind_power_multiply", Range( 0 , 0.2)) = 0.15
		_Cutoff( "Mask Clip Value", Float ) = 0
		_Albedo_map_input("Albedo_map_input", 2D) = "white" {}
		_2nd_color_mask_input("2nd_color_mask_input", 2D) = "white" {}
		_Ambient_Occlusion_map_input("Ambient_Occlusion_map_input", 2D) = "white" {}
		_Alpha_cutout_mask_map_input("Alpha_cutout_mask_map_input", 2D) = "white" {}
		_Wind_noise("Wind_noise", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Albedo_map_input;
		uniform float4 _Albedo_map_input_ST;
		uniform float4 _Base_Color;
		uniform float4 _2nd_color;
		uniform sampler2D _2nd_color_mask_input;
		uniform float4 _2nd_color_mask_input_ST;
		uniform float _2nd_color_intensity;
		uniform sampler2D _Ambient_Occlusion_map_input;
		uniform float4 _Ambient_Occlusion_map_input_ST;
		uniform float _AO_Intensity;
		uniform float _Smoothness_Shift;
		uniform sampler2D _Alpha_cutout_mask_map_input;
		uniform float4 _Alpha_cutout_mask_map_input_ST;
		uniform sampler2D _Wind_noise;
		uniform float _Wind_speed;
		uniform float _Wind_power_multiply;
		uniform float _Cutoff = 0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord313 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float2 panner315 = ( uv_TexCoord313 + ( _Time.x * _Wind_speed ) * float2( 0.5,0.5 ));
			float4 _wind343 = ( tex2Dlod( _Wind_noise, float4( panner315, 0, 0.0) ) * _Wind_power_multiply );
			v.vertex.xyz += _wind343.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo_map_input = i.uv_texcoord * _Albedo_map_input_ST.xy + _Albedo_map_input_ST.zw;
			float4 tex2DNode273 = tex2D( _Albedo_map_input, uv_Albedo_map_input );
			float4 blendOpSrc95 = tex2DNode273;
			float4 blendOpDest95 = _Base_Color;
			float4 temp_output_95_0 = ( saturate( ( blendOpSrc95 * blendOpDest95 ) ));
			float2 uv_2nd_color_mask_input = i.uv_texcoord * _2nd_color_mask_input_ST.xy + _2nd_color_mask_input_ST.zw;
			float4 lerpResult241 = lerp( temp_output_95_0 , _2nd_color , ( tex2D( _2nd_color_mask_input, uv_2nd_color_mask_input ) * ( float4(1,1,1,0) * _2nd_color_intensity ) ).r);
			float4 blendOpSrc243 = temp_output_95_0;
			float4 blendOpDest243 = lerpResult241;
			float4 temp_output_243_0 = ( saturate( (( blendOpDest243 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest243 - 0.5 ) ) * ( 1.0 - blendOpSrc243 ) ) : ( 2.0 * blendOpDest243 * blendOpSrc243 ) ) ));
			float2 uv_Ambient_Occlusion_map_input = i.uv_texcoord * _Ambient_Occlusion_map_input_ST.xy + _Ambient_Occlusion_map_input_ST.zw;
			float4 _AO336 = tex2D( _Ambient_Occlusion_map_input, uv_Ambient_Occlusion_map_input );
			float4 blendOpSrc327 = float4(1,1,1,0);
			float4 blendOpDest327 = _AO336;
			float4 lerpResult324 = lerp( temp_output_243_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc327 - blendOpDest327 ) )) * _AO_Intensity ).r);
			float4 blendOpSrc325 = temp_output_243_0;
			float4 blendOpDest325 = lerpResult324;
			float4 _albedo345 = ( saturate( min( blendOpSrc325 , blendOpDest325 ) ));
			o.Albedo = _albedo345.rgb;
			float4 _smoothness339 = ( tex2DNode273 * _Smoothness_Shift );
			o.Smoothness = _smoothness339.r;
			o.Occlusion = _AO336.r;
			o.Alpha = 1;
			float2 uv_Alpha_cutout_mask_map_input = i.uv_texcoord * _Alpha_cutout_mask_map_input_ST.xy + _Alpha_cutout_mask_map_input_ST.zw;
			float4 _alpha341 = tex2D( _Alpha_cutout_mask_map_input, uv_Alpha_cutout_mask_map_input );
			clip( _alpha341.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
