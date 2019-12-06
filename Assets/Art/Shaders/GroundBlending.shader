
Shader "Medieval Kingdom/GroundBlending"
{
	Properties
	{
		_ColorshiftBlackChannel("Color shift(Black Channel)", Color) = (1,1,1,0)
		_ColorshiftRedChannel("Color shift(Red Channel)", Color) = (1,1,1,0)
		_ColorshiftGreenChannel0("Color shift(Green Channel) 0", Color) = (1,1,1,0)
		_ColorshiftAlphaChannel("Color shift (Alpha Channel)", Color) = (1,1,1,0)
		_SmoothnessshiftBlackchannel("Smoothness shift (Black channel)", Range( 0 , 4)) = 1
		_SmoothnessshiftRedChannel("Smoothness shift (Red Channel)", Range( 0 , 4)) = 1
		_SmoothnessshiftGreenChannel("Smoothness shift (Green Channel)", Range( 0 , 4)) = 1
		_SmoothnessshiftAlphaChannel("Smoothness shift (Alpha Channel)", Range( 0 , 4)) = 1
		_Wetness_color("Wetness_color", Color) = (1,1,1,0)
		_TilingBlack("Tiling Black", Range( 1 , 100)) = 10
		_TilingRed("Tiling Red", Range( 1 , 100)) = 10
		_TilingGreen("Tiling Green", Range( 1 , 100)) = 10
		_TilingAlpha("Tiling Alpha", Range( 1 , 100)) = 10
		_ParallaxStrength("Parallax Strength", Range( 0 , 0.2)) = 0
		_BlendingstrengthRed("Blending strength (Red)", Range( 0 , 10)) = 5
		_BlendingStrengthGreen("Blending Strength (Green)", Range( 0 , 10)) = 5
		_BlendingStrengthAlpha("Blending Strength (Alpha)", Range( 0 , 10)) = 5
		_NormalmapstrengthBlack("Normal map strength (Black)", Range( 0 , 10)) = 1
		_NormalmapstrengthRed("Normal map strength (Red)", Range( 0 , 10)) = 1
		_NormalmapstrengthGreen("Normal map strength (Green)", Range( 0 , 10)) = 1
		_NormalmapstrengthAlpha("Normal map strength (Alpha)", Range( 0 , 10)) = 1
		_DiffuseBlackChannel("Diffuse (Black Channel)", 2D) = "white" {}
		_NormalBlackChannel("Normal (Black Channel)", 2D) = "bump" {}
		_HeightBlackChannel("Height (Black Channel)", 2D) = "white" {}
		_DiffuseRedChannel("Diffuse (Red Channel)", 2D) = "white" {}
		_NormalRedChannel("Normal (Red Channel)", 2D) = "bump" {}
		_HeightRedChannel("Height (Red Channel)", 2D) = "white" {}
		_DiffuseGreenChannel("Diffuse (Green Channel)", 2D) = "white" {}
		_NormalGreenChannel("Normal (Green Channel)", 2D) = "bump" {}
		_HeightGreenchannel("Height (Green channel)", 2D) = "white" {}
		_DiffuseAlphaChannel("Diffuse (Alpha Channel)", 2D) = "white" {}
		_NormalAlphaChannel("Normal (Alpha Channel)", 2D) = "bump" {}
		_HeightAlphachannel("Height (Alpha channel)", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.5
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalmapstrengthBlack;
		uniform sampler2D _NormalBlackChannel;
		uniform float _TilingBlack;
		uniform sampler2D _HeightBlackChannel;
		uniform float _ParallaxStrength;
		uniform float _NormalmapstrengthRed;
		uniform sampler2D _NormalRedChannel;
		uniform float _TilingRed;
		uniform sampler2D _HeightRedChannel;
		uniform float _BlendingstrengthRed;
		uniform float _NormalmapstrengthGreen;
		uniform sampler2D _NormalGreenChannel;
		uniform float _TilingGreen;
		uniform sampler2D _HeightGreenchannel;
		uniform float _BlendingStrengthGreen;
		uniform float _NormalmapstrengthAlpha;
		uniform sampler2D _NormalAlphaChannel;
		uniform float _TilingAlpha;
		uniform sampler2D _HeightAlphachannel;
		uniform float _BlendingStrengthAlpha;
		uniform sampler2D _DiffuseBlackChannel;
		uniform float4 _ColorshiftBlackChannel;
		uniform sampler2D _DiffuseRedChannel;
		uniform float4 _ColorshiftRedChannel;
		uniform sampler2D _DiffuseGreenChannel;
		uniform float4 _ColorshiftGreenChannel0;
		uniform sampler2D _DiffuseAlphaChannel;
		uniform float4 _ColorshiftAlphaChannel;
		uniform float4 _Wetness_color;
		uniform float _SmoothnessshiftBlackchannel;
		uniform float _SmoothnessshiftRedChannel;
		uniform float _SmoothnessshiftGreenChannel;
		uniform float _SmoothnessshiftAlphaChannel;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_TilingBlack).xx;
			float2 uv_TexCoord215 = i.uv_texcoord * temp_cast_0;
			float2 _tiling_black274 = uv_TexCoord215;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 Offset223 = ( ( tex2D( _HeightBlackChannel, _tiling_black274 ).r - 1 ) * ase_worldViewDir.xy * _ParallaxStrength ) + _tiling_black274;
			float2 _parallax_Black294 = Offset223;
			float2 temp_cast_2 = (_TilingRed).xx;
			float2 uv_TexCoord325 = i.uv_texcoord * temp_cast_2;
			float2 _tiling_red324 = uv_TexCoord325;
			float4 tex2DNode216 = tex2D( _HeightRedChannel, _tiling_red324 );
			float2 Offset321 = ( ( tex2DNode216.r - 1 ) * ase_worldViewDir.xy * _ParallaxStrength ) + _tiling_red324;
			float2 _parallax_Red319 = Offset321;
			float _vertex_color_red281 = i.vertexColor.r;
			float HeightMask228 = saturate(pow(((tex2DNode216.r*_vertex_color_red281)*4)+(_vertex_color_red281*2),_BlendingstrengthRed));
			float3 lerpResult233 = lerp( UnpackScaleNormal( tex2D( _NormalBlackChannel, _parallax_Black294 ) ,_NormalmapstrengthBlack ) , UnpackScaleNormal( tex2D( _NormalRedChannel, _parallax_Red319 ) ,_NormalmapstrengthRed ) , HeightMask228);
			float2 temp_cast_5 = (_TilingGreen).xx;
			float2 uv_TexCoord328 = i.uv_texcoord * temp_cast_5;
			float2 _tiling_green327 = uv_TexCoord328;
			float4 tex2DNode242 = tex2D( _HeightGreenchannel, _tiling_green327 );
			float2 Offset322 = ( ( tex2DNode242.r - 1 ) * ase_worldViewDir.xy * _ParallaxStrength ) + _tiling_green327;
			float2 _parallax_Green320 = Offset322;
			float _vertex_color_green282 = i.vertexColor.g;
			float HeightMask241 = saturate(pow(((tex2DNode242.r*_vertex_color_green282)*4)+(_vertex_color_green282*2),_BlendingStrengthGreen));
			float3 lerpResult247 = lerp( lerpResult233 , UnpackScaleNormal( tex2D( _NormalGreenChannel, _parallax_Green320 ) ,_NormalmapstrengthGreen ) , HeightMask241);
			float2 temp_cast_8 = (_TilingAlpha).xx;
			float2 uv_TexCoord334 = i.uv_texcoord * temp_cast_8;
			float2 _tiling_alpha335 = uv_TexCoord334;
			float4 tex2DNode337 = tex2D( _HeightAlphachannel, _tiling_alpha335 );
			float2 Offset336 = ( ( tex2DNode337.r - 1 ) * ase_worldViewDir.xy * _ParallaxStrength ) + _tiling_alpha335;
			float2 _parallax_alpha340 = Offset336;
			float _vertex_color_alpha332 = i.vertexColor.a;
			float HeightMask342 = saturate(pow(((tex2DNode337.r*_vertex_color_alpha332)*4)+(_vertex_color_alpha332*2),_BlendingStrengthAlpha));
			float3 lerpResult353 = lerp( lerpResult247 , UnpackScaleNormal( tex2D( _NormalAlphaChannel, _parallax_alpha340 ) ,_NormalmapstrengthAlpha ) , HeightMask342);
			float3 _normal308 = lerpResult353;
			o.Normal = _normal308;
			float4 tex2DNode211 = tex2D( _DiffuseBlackChannel, _parallax_Black294 );
			float4 tex2DNode210 = tex2D( _DiffuseRedChannel, _parallax_Red319 );
			float4 lerpResult212 = lerp( ( tex2DNode211 * _ColorshiftBlackChannel ) , ( tex2DNode210 * _ColorshiftRedChannel ) , HeightMask228);
			float4 tex2DNode243 = tex2D( _DiffuseGreenChannel, _parallax_Green320 );
			float4 lerpResult240 = lerp( lerpResult212 , ( tex2DNode243 * _ColorshiftGreenChannel0 ) , HeightMask241);
			float4 tex2DNode349 = tex2D( _DiffuseAlphaChannel, _parallax_alpha340 );
			float4 lerpResult345 = lerp( lerpResult240 , ( tex2DNode349 * _ColorshiftAlphaChannel ) , HeightMask342);
			float4 lerpResult273 = lerp( lerpResult345 , ( lerpResult345 * _Wetness_color ) , _vertex_color_green282);
			float4 _albedo306 = lerpResult273;
			o.Albedo = _albedo306.rgb;
			float lerpResult237 = lerp( ( tex2DNode211.a * _SmoothnessshiftBlackchannel ) , ( tex2DNode210.a * _SmoothnessshiftRedChannel ) , HeightMask228);
			float lerpResult249 = lerp( lerpResult237 , ( tex2DNode243.a * _SmoothnessshiftGreenChannel ) , HeightMask241);
			float lerpResult354 = lerp( lerpResult249 , ( tex2DNode349.a * _SmoothnessshiftAlphaChannel ) , HeightMask342);
			float _vertex_color_blue283 = i.vertexColor.b;
			float lerpResult263 = lerp( lerpResult354 , ( lerpResult354 * 4.0 ) , _vertex_color_blue283);
			float _smoothness312 = lerpResult263;
			o.Smoothness = _smoothness312;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}