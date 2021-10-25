// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Overizer/Burning"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_Distortion("Distortion", 2D) = "white" {}
		_Hot("Hot", Color) = (0,0,0,0)
		_Warm("Warm", Color) = (0,0,0,0)
		_Distortion_Amount("Distortion_Amount", Range( 0 , 1)) = 0
		_ScrollSpeed("Scroll Speed", Range( 0 , 1)) = 0
		_Burn("Burn", Range( 0 , 1.025)) = 0.1870628
		_HeatWaves("Heat Waves", Range( 0 , 1)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Warm;
		uniform float4 _Hot;
		uniform sampler2D _Mask;
		uniform sampler2D _Distortion;
		uniform float4 _Distortion_ST;
		uniform float _Distortion_Amount;
		uniform float _ScrollSpeed;
		uniform float _HeatWaves;
		uniform float _Burn;
		uniform float _DissolveAmount;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Distortion = i.uv_texcoord * _Distortion_ST.xy + _Distortion_ST.zw;
			float temp_output_15_0 = ( _Time.y * _ScrollSpeed );
			float2 panner12 = ( temp_output_15_0 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord10 = i.uv_texcoord + panner12;
			float4 lerpResult19 = lerp( _Warm , _Hot , tex2D( _Mask, ( ( (UnpackNormal( tex2D( _Distortion, uv_Distortion ) )).xy * _Distortion_Amount ) + uv_TexCoord10 ) ).r);
			float4 temp_cast_0 = (2.5).xxxx;
			float2 panner35 = ( temp_output_15_0 * float2( 0,-1 ) + i.uv_texcoord);
			float4 tex2DNode24 = tex2D( _Mask, ( ( (UnpackNormal( tex2D( _Distortion, panner35 ) )).xy * _HeatWaves ) + i.uv_texcoord ) );
			float temp_output_25_0 = step( tex2DNode24.r , _Burn );
			float temp_output_45_0 = step( tex2DNode24.r , ( 1.0 - ( _DissolveAmount / 1.025 ) ) );
			float temp_output_64_0 = ( temp_output_45_0 - step( tex2DNode24.r , ( 1.0 - _DissolveAmount ) ) );
			float4 temp_cast_1 = (temp_output_64_0).xxxx;
			float4 temp_cast_2 = (temp_output_64_0).xxxx;
			o.Emission = ( ( ( pow( lerpResult19 , temp_cast_0 ) * ( temp_output_25_0 + ( temp_output_25_0 - step( tex2DNode24.r , ( _Burn / 1.025 ) ) ) ) ) - temp_cast_1 ) - temp_cast_2 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
203;73;1437;650;4049.18;792.1225;3.005932;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;13;-3023.076,208.7166;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3100.664,284.0055;Float;False;Property;_ScrollSpeed;Scroll Speed;5;0;Create;True;0;0;False;0;0;0.102;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2827.96,212.0535;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3045.381,497.3108;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-2720.504,506.8789;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-2874.764,-113.3247;Float;True;Property;_Distortion;Distortion;1;0;Create;True;0;0;False;0;None;ffd5291057498484385a8ebabbcbc5ce;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;34;-2533.892,477.6125;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;37;-2237.549,542.6536;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2374.842,654.9532;Float;False;Property;_HeatWaves;Heat Waves;7;0;Create;True;0;0;False;0;0;0.21;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-2609.02,-50.56442;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2041.244,560.933;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-2230.495,739.198;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;12;-2556.059,201.4976;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;-2261.54,-21.36643;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2298.659,84.03784;Float;False;Property;_Distortion_Amount;Distortion_Amount;4;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1890.328,552.7028;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2215.655,181.2864;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1988.66,13.05659;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1907.123,-222.3089;Float;True;Property;_Mask;Mask;0;0;Create;True;0;0;False;0;None;28e1e3f024198964f948c67b787f673f;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1511.152,443.144;Float;False;Constant;_DivideAmount;Divide Amount;9;0;Create;True;0;0;False;0;1.025;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1538.252,364.0442;Float;False;Property;_Burn;Burn;6;0;Create;True;0;0;False;0;0.1870628;1.02;0;1.025;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1813.325,34.53207;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1551.752,616.044;Float;False;Property;_DissolveAmount;Dissolve Amount;8;0;Create;True;0;0;False;0;0;0.09;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-1232.951,369.2442;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1543.746,130.3122;Float;True;Global;TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;29;-1097.649,345.2244;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;25;-1114.452,132.744;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-1600.507,-428.3791;Float;False;Property;_Hot;Hot;2;0;Create;True;0;0;False;0;0,0,0,0;1,0.9162277,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-1238.653,540.0444;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1529.839,-185.4726;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1592.354,-603.4309;Float;False;Property;_Warm;Warm;3;0;Create;True;0;0;False;0;0,0,0,0;1,0.4917327,0.07058821,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;42;-1061.335,664.0483;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;48;-1054.535,580.1612;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1108.148,-116.4127;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-830.3448,129.1432;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-1195.766,-342.6808;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;46;-785.7836,638.4703;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-924.6843,-304.7946;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;45;-779.8813,424.3755;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-593.1281,47.47584;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-469.5807,459.1093;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-385.0111,-130.4952;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-95.29506,129.22;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;101.489,249.0602;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;236.5154,200.2272;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Overizer/Burning;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;35;0;36;0
WireConnection;35;1;15;0
WireConnection;34;0;5;0
WireConnection;34;1;35;0
WireConnection;37;0;34;0
WireConnection;6;0;5;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;12;1;15;0
WireConnection;7;0;6;0
WireConnection;41;0;38;0
WireConnection;41;1;40;0
WireConnection;10;1;12;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;11;0;8;0
WireConnection;11;1;10;0
WireConnection;30;0;26;0
WireConnection;30;1;31;0
WireConnection;24;0;3;0
WireConnection;24;1;41;0
WireConnection;29;0;24;1
WireConnection;29;1;30;0
WireConnection;25;0;24;1
WireConnection;25;1;26;0
WireConnection;51;0;50;0
WireConnection;51;1;31;0
WireConnection;4;0;3;0
WireConnection;4;1;11;0
WireConnection;42;0;50;0
WireConnection;48;0;51;0
WireConnection;32;0;25;0
WireConnection;32;1;29;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;19;2;4;1
WireConnection;46;0;24;1
WireConnection;46;1;42;0
WireConnection;21;0;19;0
WireConnection;21;1;23;0
WireConnection;45;0;24;1
WireConnection;45;1;48;0
WireConnection;70;0;25;0
WireConnection;70;1;32;0
WireConnection;64;0;45;0
WireConnection;64;1;46;0
WireConnection;27;0;21;0
WireConnection;27;1;70;0
WireConnection;49;0;27;0
WireConnection;49;1;64;0
WireConnection;55;0;49;0
WireConnection;55;1;64;0
WireConnection;0;2;55;0
ASEEND*/
//CHKSM=A088967E2FB567861648B6485D6E16631114C42D