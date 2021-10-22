// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "g"
{
	Properties
	{
		_WaveSpeed("WaveSpeed", Float) = 0.15
		_WaveTile("WaveTile", Float) = 3.5
		_WaveHeight("WaveHeight", Float) = 1
		_Smoothness("Smoothness", Float) = 0.9
		_TopColor("TopColor", Color) = (0,0,0,0)
		_WaterColor("WaterColor", Color) = (0,0,0,0)
		_EdgeDistance("Edge Distance", Float) = 0
		_EdgePower("Edge Power", Range( 0 , 1)) = 0
		_Edge("Edge", 2D) = "white" {}
		_EdgeFoamTile("EdgeFoamTile", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _WaveHeight;
		uniform float _WaveSpeed;
		uniform float _WaveTile;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		uniform sampler2D _CameraDepthTexture;
		uniform float _EdgeDistance;
		uniform sampler2D _Edge;
		uniform float _EdgeFoamTile;
		uniform float _EdgePower;
		uniform float _Smoothness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (8.0).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_7_0 = ( _Time.y * _WaveSpeed );
			float2 _WaveDirection = float2(-1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult11 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile12 = appendResult11;
			float4 WaveTileUV22 = ( ( WorldSpaceTile12 * float4( float2( 0.15,0.02 ), 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner3 = ( temp_output_7_0 * _WaveDirection + WaveTileUV22.xy);
			float simplePerlin2D1 = snoise( panner3 );
			float2 panner25 = ( temp_output_7_0 * _WaveDirection + ( WaveTileUV22 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D27 = snoise( panner25 );
			float temp_output_29_0 = ( simplePerlin2D1 + simplePerlin2D27 );
			float3 WaveHeight35 = ( ( float3(0,0.5,0) * _WaveHeight ) * temp_output_29_0 );
			v.vertex.xyz += WaveHeight35;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_7_0 = ( _Time.y * _WaveSpeed );
			float2 _WaveDirection = float2(-1,0);
			float3 ase_worldPos = i.worldPos;
			float4 appendResult11 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile12 = appendResult11;
			float4 WaveTileUV22 = ( ( WorldSpaceTile12 * float4( float2( 0.15,0.02 ), 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner3 = ( temp_output_7_0 * _WaveDirection + WaveTileUV22.xy);
			float simplePerlin2D1 = snoise( panner3 );
			float2 panner25 = ( temp_output_7_0 * _WaveDirection + ( WaveTileUV22 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D27 = snoise( panner25 );
			float temp_output_29_0 = ( simplePerlin2D1 + simplePerlin2D27 );
			float WavePattern32 = temp_output_29_0;
			float clampResult45 = clamp( WavePattern32 , 0.0 , 1.0 );
			float4 lerpResult43 = lerp( _WaterColor , _TopColor , clampResult45);
			float4 Albedo46 = lerpResult43;
			o.Albedo = Albedo46.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth49 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth49 = abs( ( screenDepth49 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float4 clampResult56 = clamp( ( ( ( 1.0 - distanceDepth49 ) + tex2D( _Edge, ( ( WorldSpaceTile12 / 10.0 ) * _EdgeFoamTile ).xy ) ) * _EdgePower ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Edge54 = clampResult56;
			o.Emission = Edge54.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
363;73;1057;590;-1163.688;-413.827;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;13;-2785.637,173.4203;Float;False;800.299;328.5001;Comment;3;9;11;12;WorldSpaceUVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-2735.637,223.4203;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;11;-2467.837,237.7204;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;23;-2484.607,-483.0601;Float;False;1107.078;544.4164;Comment;6;14;16;18;15;17;22;WaveTileUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-2214.338,242.9205;Float;True;WorldSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;16;-2418.412,-245.6436;Float;True;Constant;_WaveStretch;WaveStretch;2;0;Create;True;0;0;False;0;0.15,0.02;0.15,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;14;-2434.606,-433.06;Float;True;12;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2161.307,-377.1581;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2095.277,-151.8187;Float;False;Property;_WaveTile;WaveTile;1;0;Create;True;0;0;False;0;3.5;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1875.6,-346.3638;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1927.571,143.4816;Float;False;1502.378;733.4373;Comment;13;6;30;8;31;24;5;7;3;25;27;1;29;32;WavePattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1603.528,-347.1937;Float;False;WaveTileUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1877.571,542.3243;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1866.571,622.3242;Float;False;Property;_WaveSpeed;WaveSpeed;0;0;Create;True;0;0;False;0;0.15;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1867.434,720.5685;Float;False;22;WaveTileUV;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1661.571,540.3243;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1609.033,655.9693;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;5;-1754.57,416.3243;Float;False;Constant;_WaveDirection;WaveDirection;0;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1676.469,195.4816;Float;False;22;WaveTileUV;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;66;-2125.247,1319.373;Float;False;1054.644;473.0483;Comment;7;61;60;63;64;62;58;59;EdgeFoam;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;25;-1414.339,601.919;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;3;-1472.515,200.2464;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-2063.443,1454.819;Float;True;12;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2026.43,1629.881;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1701.858,975.6471;Float;False;1585.587;274.5519;Comment;8;50;54;56;52;53;51;49;65;EdgeDetection;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-1158.339,617.919;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-1208.406,204.2472;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-1852.004,1555.925;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1651.858,1046.884;Float;False;Property;_EdgeDistance;Edge Distance;7;0;Create;True;0;0;False;0;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1849.391,1676.421;Float;False;Property;_EdgeFoamTile;EdgeFoamTile;10;0;Create;True;0;0;False;0;1;1.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;49;-1454.132,1025.647;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1620.547,1591.159;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;59;-1694.303,1369.373;Float;True;Property;_Edge;Edge;9;0;Create;True;0;0;False;0;None;3df3a814e461a5e4bb03cad9dd2306e5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-924.1592,398.6627;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-649.1929,393.165;Float;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-1199.053,1027.389;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;31.07929,-491.8025;Float;False;1203.632;653.3344;Comment;6;44;41;42;45;43;46;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1079.558,-255.678;Float;False;857.6332;369.0734;Comment;5;20;33;21;34;35;WaveHeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;58;-1390.603,1483.445;Float;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1008.117,-43.60497;Float;False;Property;_WaveHeight;WaveHeight;2;0;Create;True;0;0;False;0;1;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;20;-1029.558,-205.6782;Float;False;Constant;_WaveUp;WaveUp;3;0;Create;True;0;0;False;0;0,0.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;53;-850.5032,1152.914;Float;False;Property;_EdgePower;Edge Power;8;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-977.6678,1095.147;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;81.07929,-96.58087;Float;True;32;WavePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-576.5863,1028.473;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;41;288.0674,-260.2911;Float;False;Property;_TopColor;TopColor;5;0;Create;True;0;0;False;0;0,0,0,0;0,0.7765691,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-791.6351,-106.1742;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;42;290.4714,-441.8025;Float;False;Property;_WaterColor;WaterColor;6;0;Create;True;0;0;False;0;0,0,0,0;0.1158772,0.5322447,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;45;282.8145,-92.46816;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-605.1165,-21.60494;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;56;-450.3772,1028.901;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;43;701.7103,-286.8704;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-317.3374,1026.657;Float;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-445.9244,-19.94894;Float;False;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;1010.711,-290.6152;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;1697.984,605.8006;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0.9;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-331.9651,145.5557;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;189f65ff6395946439248047ee61cebb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;47;1649.821,510.3708;Float;False;46;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;1716.138,847.4366;Float;False;Constant;_Tesselation;Tesselation;3;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;1531.971,800.4969;Float;False;35;WaveHeight;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;1494.071,557.2948;Float;False;54;Edge;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1920.875,515.3941;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;g;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;9;1
WireConnection;11;1;9;3
WireConnection;12;0;11;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;22;0;17;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;31;0;30;0
WireConnection;25;0;31;0
WireConnection;25;2;5;0
WireConnection;25;1;7;0
WireConnection;3;0;24;0
WireConnection;3;2;5;0
WireConnection;3;1;7;0
WireConnection;27;0;25;0
WireConnection;1;0;3;0
WireConnection;63;0;60;0
WireConnection;63;1;64;0
WireConnection;49;0;50;0
WireConnection;61;0;63;0
WireConnection;61;1;62;0
WireConnection;29;0;1;0
WireConnection;29;1;27;0
WireConnection;32;0;29;0
WireConnection;51;0;49;0
WireConnection;58;0;59;0
WireConnection;58;1;61;0
WireConnection;65;0;51;0
WireConnection;65;1;58;0
WireConnection;52;0;65;0
WireConnection;52;1;53;0
WireConnection;21;0;20;0
WireConnection;21;1;33;0
WireConnection;45;0;44;0
WireConnection;34;0;21;0
WireConnection;34;1;29;0
WireConnection;56;0;52;0
WireConnection;43;0;42;0
WireConnection;43;1;41;0
WireConnection;43;2;45;0
WireConnection;54;0;56;0
WireConnection;35;0;34;0
WireConnection;46;0;43;0
WireConnection;0;0;47;0
WireConnection;0;2;55;0
WireConnection;0;4;39;0
WireConnection;0;11;36;0
WireConnection;0;14;19;0
ASEEND*/
//CHKSM=67332D5BF47A767EDB0BBF215AC5C26AB2D47531