// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Medieval Kingdom/BaseShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Material_Tiling("Material_Tiling", Vector) = (1,1,0,0)
		_Base_color("Base_color", Color) = (0.427451,0.227451,0.1372549,0)
		_Detail_color("Detail_color", Color) = (0,0.9779412,0.7756083,0)
		_Detail_level("Detail_level", Range( 0 , 1)) = 0
		_Detail_2_color("Detail_2_color", Color) = (0,0.9779412,0.7756083,0)
		_Detail_2_level("Detail_2_level", Range( 0 , 1)) = 0
		_Normal_intensity("Normal_intensity", Range( 0 , 2)) = 1
		_Roughnessintensity("Roughness intensity", Range( 0 , 2)) = 1
		_Detail_roughness("Detail_roughness", Range( 0 , 1)) = 0
		_AO_intensity("AO_intensity", Range( 0 , 2)) = 0
		_Edge_wear("Edge_wear", Range( 0 , 1)) = 0
		_Mettallic_intensity("Mettallic_intensity", Range( 0 , 3)) = 0
		_Emmsivie_color("Emmsivie_color", Color) = (0.9779412,0.9210103,0.6831207,0)
		_Emmisive_intensity("Emmisive_intensity", Range( 0 , 100)) = 0
		_Alpha_cutout_level("Alpha_cutout_level", Range( 0 , 1)) = 1
		[Toggle(_METALOBJECTUSESMETTALICSMOOTHNESMAP_ON)] _Metalobjectusesmettalicsmoothnesmap("Metal object uses mettalic smoothnes map?", Float) = 0
		_Albedo_map("Albedo_map", 2D) = "white" {}
		_Roughness_map("Roughness_map", 2D) = "white" {}
		_Normal_map("Normal_map", 2D) = "bump" {}
		_Metallic_map("Metallic_map", 2D) = "white" {}
		_Ambient_Occlusion_map("Ambient_Occlusion_map", 2D) = "white" {}
		_Detail_mask_1_map("Detail_mask_1_map", 2D) = "white" {}
		_Detail_mask_2_map("Detail_mask_2_map", 2D) = "white" {}
		_Edge_mask_map("Edge_mask_map", 2D) = "white" {}
		_Emmisive_mask_map("Emmisive_mask_map", 2D) = "white" {}
		_Alpha_cutout_mask_map("Alpha_cutout_mask_map", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma shader_feature _METALOBJECTUSESMETTALICSMOOTHNESMAP_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Normal_intensity;
		uniform sampler2D _Normal_map;
		uniform float2 _Material_Tiling;
		uniform sampler2D _Albedo_map;
		uniform float4 _Base_color;
		uniform sampler2D _Detail_mask_1_map;
		uniform float4 _Detail_mask_1_map_ST;
		uniform float4 _Detail_color;
		uniform float _Detail_level;
		uniform sampler2D _Detail_mask_2_map;
		uniform float4 _Detail_mask_2_map_ST;
		uniform float _Detail_2_level;
		uniform float4 _Detail_2_color;
		uniform sampler2D _Edge_mask_map;
		uniform float4 _Edge_mask_map_ST;
		uniform float _Edge_wear;
		uniform sampler2D _Ambient_Occlusion_map;
		uniform float4 _Ambient_Occlusion_map_ST;
		uniform float _AO_intensity;
		uniform sampler2D _Emmisive_mask_map;
		uniform float4 _Emmisive_mask_map_ST;
		uniform float4 _Emmsivie_color;
		uniform float _Emmisive_intensity;
		uniform sampler2D _Metallic_map;
		uniform float _Mettallic_intensity;
		uniform sampler2D _Roughness_map;
		uniform float _Roughnessintensity;
		uniform float _Detail_roughness;
		uniform sampler2D _Alpha_cutout_mask_map;
		uniform float4 _Alpha_cutout_mask_map_ST;
		uniform float _Alpha_cutout_level;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord73 = i.uv_texcoord * _Material_Tiling;
			float2 _tiling100 = uv_TexCoord73;
			float3 _normalmap124 = UnpackScaleNormal( tex2D( _Normal_map, _tiling100 ), _Normal_intensity );
			o.Normal = _normalmap124;
			float4 blendOpSrc12 = tex2D( _Albedo_map, _tiling100 );
			float4 blendOpDest12 = _Base_color;
			float2 uv_Detail_mask_1_map = i.uv_texcoord * _Detail_mask_1_map_ST.xy + _Detail_mask_1_map_ST.zw;
			float4 tex2DNode5 = tex2D( _Detail_mask_1_map, uv_Detail_mask_1_map );
			float4 blendOpSrc35 = tex2DNode5;
			float4 blendOpDest35 = _Detail_color;
			float4 temp_output_36_0 = ( tex2DNode5 * _Detail_level );
			float4 lerpResult46 = lerp( ( saturate( (( blendOpDest12 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest12 ) * ( 1.0 - blendOpSrc12 ) ) : ( 2.0 * blendOpDest12 * blendOpSrc12 ) ) )) , ( saturate( ( blendOpSrc35 + blendOpDest35 - 1.0 ) )) , temp_output_36_0);
			float2 uv_Detail_mask_2_map = i.uv_texcoord * _Detail_mask_2_map_ST.xy + _Detail_mask_2_map_ST.zw;
			float4 temp_output_97_0 = ( tex2D( _Detail_mask_2_map, uv_Detail_mask_2_map ) * _Detail_2_level );
			float4 blendOpSrc98 = temp_output_97_0;
			float4 blendOpDest98 = _Detail_2_color;
			float4 lerpResult99 = lerp( lerpResult46 , ( saturate( ( blendOpSrc98 + blendOpDest98 - 1.0 ) )) , temp_output_97_0);
			float2 uv_Edge_mask_map = i.uv_texcoord * _Edge_mask_map_ST.xy + _Edge_mask_map_ST.zw;
			float4 lerpResult70 = lerp( lerpResult99 , float4(1,1,1,0) , ( tex2D( _Edge_mask_map, uv_Edge_mask_map ) * _Edge_wear ));
			float4 blendOpSrc71 = lerpResult99;
			float4 blendOpDest71 = lerpResult70;
			float4 temp_output_71_0 = ( saturate( (( blendOpSrc71 > 0.5 ) ? max( blendOpDest71, 2.0 * ( blendOpSrc71 - 0.5 ) ) : min( blendOpDest71, 2.0 * blendOpSrc71 ) ) ));
			float2 uv_Ambient_Occlusion_map = i.uv_texcoord * _Ambient_Occlusion_map_ST.xy + _Ambient_Occlusion_map_ST.zw;
			float4 _AO118 = tex2D( _Ambient_Occlusion_map, uv_Ambient_Occlusion_map );
			float4 blendOpSrc80 = float4(1,1,1,0);
			float4 blendOpDest80 = _AO118;
			float4 lerpResult78 = lerp( temp_output_71_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc80 - blendOpDest80 ) )) * _AO_intensity ));
			float4 blendOpSrc79 = temp_output_71_0;
			float4 blendOpDest79 = lerpResult78;
			float4 _albedo122 = ( saturate( min( blendOpSrc79 , blendOpDest79 ) ));
			o.Albedo = _albedo122.rgb;
			float2 uv_Emmisive_mask_map = i.uv_texcoord * _Emmisive_mask_map_ST.xy + _Emmisive_mask_map_ST.zw;
			float4 _emmisive116 = ( ( tex2D( _Emmisive_mask_map, uv_Emmisive_mask_map ) * _Emmsivie_color ) * _Emmisive_intensity );
			o.Emission = _emmisive116.rgb;
			float4 _metallic126 = ( tex2D( _Metallic_map, _tiling100 ) * _Mettallic_intensity );
			o.Metallic = _metallic126.r;
			float4 temp_cast_3 = (( 0.0 * _Roughnessintensity )).xxxx;
			#ifdef _METALOBJECTUSESMETTALICSMOOTHNESMAP_ON
				float4 staticSwitch132 = temp_cast_3;
			#else
				float4 staticSwitch132 = ( tex2D( _Roughness_map, _tiling100 ) * _Roughnessintensity );
			#endif
			float4 blendOpSrc43 = ( 1.0 - staticSwitch132 );
			float4 blendOpDest43 = ( temp_output_36_0 * ( 1.0 - _Detail_roughness ) );
			float4 _smoothness127 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc43 ) * ( 1.0 - blendOpDest43 ) ) ));
			o.Smoothness = _smoothness127.r;
			o.Occlusion = _AO118.r;
			o.Alpha = 1;
			float2 uv_Alpha_cutout_mask_map = i.uv_texcoord * _Alpha_cutout_mask_map_ST.xy + _Alpha_cutout_mask_map_ST.zw;
			float4 _alpha114 = ( tex2D( _Alpha_cutout_mask_map, uv_Alpha_cutout_mask_map ) * _Alpha_cutout_level );
			clip( _alpha114.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17400
0;0;1920;1019;10597.04;1958.719;3.030158;True;True
Node;AmplifyShaderEditor.CommentaryNode;104;-9648,-720;Inherit;False;856.3848;215.2771;Tiling;3;72;73;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;72;-9600,-672;Float;False;Property;_Material_Tiling;Material_Tiling;1;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;121;-9637.987,-1409.493;Inherit;False;4041.403;649.948;Albedo;6;112;111;106;105;107;122;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-9328,-672;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;107;-9618.27,-1337.651;Inherit;False;712.6123;438.0623;Albedo_roughness_map_input;5;4;12;11;101;135;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-9024,-640;Float;False;_tiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;106;-8186.706,-1358;Inherit;False;683.9615;522.174;Detail_mask_2_map_input;6;99;98;97;96;94;95;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-9598.069,-1109.968;Inherit;False;100;_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;105;-8874.155,-1359.493;Inherit;False;660.3844;558.4139;Detail_mask_1_map_input;6;46;35;36;34;37;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-8831.457,-918.043;Float;False;Property;_Detail_level;Detail_level;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-9590.993,-1288.864;Float;False;Property;_Base_color;Base_color;2;0;Create;True;0;0;False;0;0.427451,0.227451,0.1372549,0;0.7075471,0.7075471,0.7075471,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;-8170.706,-926;Float;False;Property;_Detail_2_level;Detail_2_level;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-9346.158,-466.3856;Inherit;False;546.7891;281.7903;Ambient_Occlusion_map_input;2;118;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;5;-8849.625,-1126.299;Inherit;True;Property;_Detail_mask_1_map;Detail_mask_1_map;22;0;Create;True;0;0;False;0;-1;7a947e26d6355c94898b3bf52c6e07da;dae48a80a57ad1e4cbb372780483909b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;94;-8170.706,-1118;Inherit;True;Property;_Detail_mask_2_map;Detail_mask_2_map;23;0;Create;True;0;0;False;0;-1;7a947e26d6355c94898b3bf52c6e07da;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;135;-9221.635,-1289.135;Inherit;True;Property;_Albedo_map;Albedo_map;17;0;Create;True;0;0;False;0;-1;None;3995ba3b2b4d8c24db7faa3fefc5fc9f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-8844.43,-1302.329;Float;False;Property;_Detail_color;Detail_color;3;0;Create;True;0;0;False;0;0,0.9779412,0.7756083,0;0.3018867,0.3018867,0.3018867,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;12;-9118.028,-1029.656;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-7866.706,-942;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;96;-8164.706,-1307;Float;False;Property;_Detail_2_color;Detail_2_color;5;0;Create;True;0;0;False;0;0,0.9779412,0.7756083,0;0,0.9779412,0.7756083,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-9317.159,-414.6369;Inherit;True;Property;_Ambient_Occlusion_map;Ambient_Occlusion_map;21;0;Create;True;0;0;False;0;-1;None;bdfe841407a6798448897166e7b63b1a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;111;-7482.667,-1353.676;Inherit;False;712.2814;519.3632;Edge_mask_map_input;6;71;70;69;68;83;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;35;-8530.744,-1105.125;Inherit;False;LinearBurn;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-8542.967,-934.894;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;110;-8756,-722;Inherit;False;1322.75;524.5823;Metallic_Smoothness_map input;15;127;43;132;22;20;9;103;84;126;85;44;45;133;143;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;83;-7466.29,-1131.286;Inherit;True;Property;_Edge_mask_map;Edge_mask_map;24;0;Create;True;0;0;False;0;-1;None;1b78f1985716c4c4bb777389ffb64a8d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;112;-6749,-1342;Inherit;False;933.3077;489.781;Albedo and AO blend;8;79;78;77;76;74;80;119;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;46;-8369.368,-960.2592;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-7467.667,-928.1621;Float;False;Property;_Edge_wear;Edge_wear;11;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;98;-7850.706,-1134;Inherit;False;LinearBurn;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-8998.878,-417.1205;Float;False;_AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;81;-6701,-1262;Float;False;Constant;_Color0;Color 0;17;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-7151.376,-945.4511;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;68;-7461.142,-1306.676;Float;False;Constant;_Color3;Color 3;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;99;-7658.706,-974;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-6701,-1086;Inherit;False;118;_AO;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-8404,-338;Float;False;Property;_Roughnessintensity;Roughness intensity;8;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-9459.432,-985.8267;Inherit;True;Property;_Roughness_map;Roughness_map;18;0;Create;True;0;0;False;0;-1;None;1093da696b591074aa417e80ed53bd50;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-8748,-484;Float;False;Property;_Detail_roughness;Detail_roughness;9;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-8030.801,-436.6;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;130;-7424.159,-711.7689;Inherit;False;754.9919;518.6198;Emmisive_mask_map_input;6;88;89;116;90;86;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-8033.3,-550.9031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;80;-6493,-1246;Inherit;False;Difference;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-6685,-1006;Float;False;Property;_AO_intensity;AO_intensity;10;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-7153.663,-1140.538;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;86;-7397.535,-660.7678;Float;False;Property;_Emmsivie_color;Emmsivie_color;13;0;Create;True;0;0;False;0;0.9779412,0.9210103,0.6831207,0;0.9779412,0.9210103,0.6831207,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;-7404.159,-495.386;Inherit;True;Property;_Emmisive_mask_map;Emmisive_mask_map;25;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;108;-8768,-160;Inherit;False;998.8794;334;Normal_map_input;4;124;8;134;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-8729,-294;Inherit;False;100;_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;144;-8610.892,-603.8351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;71;-6983.857,-954.7018;Inherit;False;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;132;-7873.4,-566.7998;Float;False;Property;_Metalobjectusesmettalicsmoothnesmap;Metal object uses mettalic smoothnes map?;16;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;77;-6269,-1262;Float;False;Constant;_Color4;Color 4;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-6429,-1134;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;113;-7724.674,-153.3696;Inherit;False;730.368;344.2644;Alpha_cutout_mask_map_input;4;114;91;92;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-7403.807,-296.1508;Float;False;Property;_Emmisive_intensity;Emmisive_intensity;14;0;Create;True;0;0;False;0;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-8704,48;Float;False;Property;_Normal_intensity;Normal_intensity;7;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;143;-7599.158,-471.2581;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-8608,-80;Inherit;False;100;_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;78;-6221,-1054;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-8308,-658;Float;False;Property;_Mettallic_intensity;Mettallic_intensity;12;0;Create;True;0;0;False;0;0;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-8420,-546;Inherit;True;Property;_Metallic_map;Metallic_map;20;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-8434,-653;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-7652.717,90.9576;Float;False;Property;_Alpha_cutout_level;Alpha_cutout_level;15;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-7112.653,-630.3919;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;93;-7674.674,-103.3696;Inherit;True;Property;_Alpha_cutout_mask_map;Alpha_cutout_mask_map;26;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-7360.286,-97.98066;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;43;-7866,-402;Inherit;False;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;79;-6029,-1022;Inherit;False;Darken;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-8036,-658;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;8;-8400,-112;Inherit;True;Property;_Normal_map;Normal_map;19;0;Create;True;0;0;False;0;-1;None;563aab744aa34224289a5ce1c7e3e827;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-7039.796,-464.702;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-7984,32;Float;False;_normalmap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-5804.7,-1015.408;Float;False;_albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-7638.666,-378.8863;Float;False;_smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-6875.167,-455.3629;Float;False;_emmisive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-7215.665,-104.6926;Float;False;_alpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-7860,-658;Float;False;_metallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-6528,-512;Inherit;False;124;_normalmap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-6528,-576;Inherit;False;122;_albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-6527,-180;Inherit;False;114;_alpha;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-6528,-384;Inherit;False;126;_metallic;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-6528,-448;Inherit;False;116;_emmisive;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-6528,-256;Inherit;False;118;_AO;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-6537,-311;Inherit;False;127;_smoothness;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-6252.902,-575.3;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Medieval Kingdom/BaseShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;True;0;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;73;0;72;0
WireConnection;100;0;73;0
WireConnection;135;1;101;0
WireConnection;12;0;135;0
WireConnection;12;1;4;0
WireConnection;97;0;94;0
WireConnection;97;1;95;0
WireConnection;35;0;5;0
WireConnection;35;1;34;0
WireConnection;36;0;5;0
WireConnection;36;1;37;0
WireConnection;46;0;12;0
WireConnection;46;1;35;0
WireConnection;46;2;36;0
WireConnection;98;0;97;0
WireConnection;98;1;96;0
WireConnection;118;0;62;0
WireConnection;69;0;83;0
WireConnection;69;1;67;0
WireConnection;99;0;46;0
WireConnection;99;1;98;0
WireConnection;99;2;97;0
WireConnection;11;1;101;0
WireConnection;20;1;22;0
WireConnection;133;0;11;0
WireConnection;133;1;22;0
WireConnection;80;0;81;0
WireConnection;80;1;119;0
WireConnection;70;0;99;0
WireConnection;70;1;68;0
WireConnection;70;2;69;0
WireConnection;144;0;45;0
WireConnection;71;0;99;0
WireConnection;71;1;70;0
WireConnection;132;1;133;0
WireConnection;132;0;20;0
WireConnection;76;0;80;0
WireConnection;76;1;74;0
WireConnection;143;0;132;0
WireConnection;78;0;71;0
WireConnection;78;1;77;0
WireConnection;78;2;76;0
WireConnection;9;1;103;0
WireConnection;44;0;36;0
WireConnection;44;1;144;0
WireConnection;88;0;87;0
WireConnection;88;1;86;0
WireConnection;91;0;93;0
WireConnection;91;1;92;0
WireConnection;43;0;143;0
WireConnection;43;1;44;0
WireConnection;79;0;71;0
WireConnection;79;1;78;0
WireConnection;84;0;9;0
WireConnection;84;1;85;0
WireConnection;8;1;102;0
WireConnection;8;5;134;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;124;0;8;0
WireConnection;122;0;79;0
WireConnection;127;0;43;0
WireConnection;116;0;90;0
WireConnection;114;0;91;0
WireConnection;126;0;84;0
WireConnection;0;0;123;0
WireConnection;0;1;125;0
WireConnection;0;2;117;0
WireConnection;0;3;128;0
WireConnection;0;4;129;0
WireConnection;0;5;120;0
WireConnection;0;10;115;0
ASEEND*/
//CHKSM=36CD202712127E0E21F7A9ECA76BE188810A1765