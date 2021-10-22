// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Overizer/Water"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_Distortion("Distortion", 2D) = "white" {}
		_Caustics("Caustics", Color) = (1,1,1,0)
		_Water("Water", Color) = (0.1225525,0.7130196,0.9622642,0)
		_Distortion_Amount("Distortion_Amount", Range( 0 , 1)) = 0
		_ScrollSpeed("Scroll Speed", Range( 0 , 1)) = 0
		_Float6("Float 6", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_Glossiness("Glossiness", Range( 0 , 1)) = 0
		_Float8("Float 8", Range( 0 , 1)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_Float5("Float 5", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
		};

		uniform float4 _Water;
		uniform float4 _Caustics;
		uniform sampler2D _Mask;
		uniform sampler2D _Distortion;
		uniform float4 _Distortion_ST;
		uniform float _Distortion_Amount;
		uniform float _ScrollSpeed;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Float6;
		uniform sampler2D _Texture0;
		uniform float _Float5;
		uniform float _Float8;
		uniform float _Glossiness;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Distortion = i.uv_texcoord * _Distortion_ST.xy + _Distortion_ST.zw;
			float2 panner17 = ( ( _Time.y * _ScrollSpeed ) * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord18 = i.uv_texcoord + panner17;
			float4 lerpResult7 = lerp( _Water , _Caustics , tex2D( _Mask, ( ( (UnpackNormal( tex2D( _Distortion, uv_Distortion ) )).xy * _Distortion_Amount ) + uv_TexCoord18 ) ).r);
			float4 temp_cast_0 = (1.3).xxxx;
			o.Albedo = pow( lerpResult7 , temp_cast_0 ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth52 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth52 = abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Float6 ) );
			float3 ase_worldPos = i.worldPos;
			float4 appendResult23 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpace25 = appendResult23;
			float4 clampResult69 = clamp( ( ( ( 1.0 - distanceDepth52 ) + tex2D( _Texture0, ( ( WorldSpace25 / 10.0 ) * _Float5 ).xy ) ) * _Float8 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 EdgeDet73 = clampResult69;
			o.Emission = EdgeDet73.rgb;
			o.Smoothness = _Glossiness;
			o.Alpha = _Opacity;
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				float4 screenPos : TEXCOORD3;
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
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
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
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
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
/*ASEBEGIN
Version=16100
363;73;1057;590;2399.804;116.8412;1.405694;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-3792.101,-1334.204;Float;False;800.299;328.5001;Comment;3;25;23;22;WorldSpaceUVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;22;-3742.101,-1284.204;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;23;-3474.301,-1269.904;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;36;-3131.711,-188.2512;Float;False;1054.644;473.0483;Comment;7;76;56;51;50;47;45;43;EdgeFoam;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-3220.802,-1264.704;Float;True;WorldSpace;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3032.894,122.2567;Float;False;Constant;_Float4;Float 4;9;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-2708.322,-531.9773;Float;False;1585.587;274.5519;Comment;8;73;69;63;61;58;57;52;48;EdgeDetection;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-3059.762,-61.31407;Float;False;25;WorldSpace;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-2074.933,313.6413;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1920.527,16.78553;Float;True;Property;_Distortion;Distortion;3;0;Create;True;0;0;False;0;ffd5291057498484385a8ebabbcbc5ce;3df3a814e461a5e4bb03cad9dd2306e5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2855.855,168.7968;Float;False;Property;_Float5;Float 5;18;0;Create;True;0;0;False;0;1;1.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2187.851,415.5961;Float;False;Property;_ScrollSpeed;Scroll Speed;10;0;Create;True;0;0;False;0;0;0.054;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;45;-2858.468,48.30082;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2658.322,-460.7402;Float;False;Property;_Float6;Float 6;13;0;Create;True;0;0;False;0;0;0.035;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2627.011,83.53482;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1857.63,373.3326;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1654.784,79.54575;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;50;-2700.767,-138.2511;Float;True;Property;_Texture0;Texture 0;17;0;Create;True;0;0;False;0;None;61ab6e499323e1f4c9731bb3aa5d2e0a;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DepthFade;52;-2460.596,-481.9774;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;-1307.303,108.7437;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1344.422,214.1479;Float;False;Property;_Distortion_Amount;Distortion_Amount;8;0;Create;True;0;0;False;0;0;0.205;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-1595.345,345.0381;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;56;-2430.466,-31.60133;Float;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;57;-2205.517,-480.2353;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1856.967,-354.7102;Float;False;Property;_Float8;Float 8;16;0;Create;True;0;0;False;0;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1984.132,-412.4772;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1254.942,324.8268;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-1026.07,243.4088;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1583.051,-479.1513;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-850.564,262.5501;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-944.532,8.043277;Float;True;Property;_Mask;Mask;0;0;Create;True;0;0;False;0;52003a27714da5f4e8f9da8de9afaca4;52003a27714da5f4e8f9da8de9afaca4;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;5;-677.0558,-410.913;Float;False;Property;_Water;Water;7;0;Create;True;0;0;False;0;0.1225525,0.7130196,0.9622642,0;0.03275188,0.3018867,0.2364275,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-685.2087,-235.8612;Float;False;Property;_Caustics;Caustics;5;0;Create;True;0;0;False;0;1,1,1,0;0,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-614.5407,7.045197;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;52003a27714da5f4e8f9da8de9afaca4;52003a27714da5f4e8f9da8de9afaca4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;69;-1456.841,-478.7233;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-192.8497,76.10509;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-3491.071,-1990.685;Float;False;1107.078;544.4164;Comment;6;31;30;29;28;27;26;WaveTileUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;7;-280.4677,-150.1629;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1323.802,-480.9673;Float;False;EdgeDet;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;53;-975.3851,-1999.427;Float;False;1203.632;653.3344;Comment;6;72;70;67;66;64;62;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-2086.022,-1763.302;Float;False;857.6332;369.0734;Comment;5;71;68;65;60;59;WaveHeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-2934.035,-1364.143;Float;False;1502.378;733.4373;Comment;13;75;55;49;46;44;42;41;39;38;37;35;34;33;WavePattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2014.581,-1551.229;Float;False;Property;_Float7;Float 7;4;0;Create;True;0;0;False;0;1;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;210.9996,-18.76766;Float;False;73;EdgeDet;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2873.035,-885.3002;Float;False;Property;_Float3;Float 3;1;0;Create;True;0;0;False;0;0.15;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1798.099,-1613.799;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;64;-718.3971,-1767.916;Float;False;Property;_Color0;Color 0;9;0;Create;True;0;0;False;0;0,0,0,0;0,0.7765691,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-3167.771,-1884.783;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2882.064,-1853.988;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;60;-2036.022,-1713.303;Float;False;Constant;_Vector2;Vector 2;3;0;Create;True;0;0;False;0;0,0.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;35;-2884.035,-965.2999;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;7.553795,207.2623;Float;False;Property;_Opacity;Opacity;14;0;Create;True;0;0;False;0;0;0.98;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2615.497,-851.655;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;-2164.803,-889.7053;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-304.7542,-1794.495;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;74;-1338.429,-1362.069;Float;True;Property;_TextureSample5;Texture Sample 5;6;0;Create;True;0;0;False;0;None;189f65ff6395946439248047ee61cebb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;27;-3424.876,-1753.268;Float;True;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;0.15,0.02;0.15,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;20;17.44117,121.42;Float;False;Property;_Glossiness;Glossiness;15;0;Create;True;0;0;False;0;0;0.018;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1452.389,-1527.573;Float;False;WaveHeigh;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;4.246405,-1798.24;Float;False;Alb;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-1655.657,-1114.459;Float;False;Pattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-2609.992,-1854.818;Float;False;TileUv;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PowerNode;8;-9.386486,-112.2767;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;39;-2744.429,-1114.547;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;62;-925.3853,-1604.205;Float;True;55;Pattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-3441.07,-1940.685;Float;True;25;WorldSpace;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-2882.078,-809.5486;Float;True;31;TileUv;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3101.741,-1659.443;Float;False;Property;_Float2;Float 2;2;0;Create;True;0;0;False;0;3.5;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2803.895,-1315.599;Float;True;31;TileUv;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1611.581,-1529.229;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;66;-715.9931,-1949.427;Float;False;Property;_Color1;Color 1;12;0;Create;True;0;0;False;0;0,0,0,0;0.1158772,0.5322447,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;44;-2214.87,-1303.377;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;42;-2478.979,-1307.378;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1930.623,-1108.962;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;41;-2420.803,-905.7053;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-2668.035,-967.2999;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;67;-670.5639,-1597.223;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;397.4398,-77.66062;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Overizer/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;11;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;22;1
WireConnection;23;1;22;3
WireConnection;25;0;23;0
WireConnection;45;0;76;0
WireConnection;45;1;43;0
WireConnection;51;0;45;0
WireConnection;51;1;47;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;10;0;9;0
WireConnection;52;0;48;0
WireConnection;11;0;10;0
WireConnection;17;1;16;0
WireConnection;56;0;50;0
WireConnection;56;1;51;0
WireConnection;57;0;52;0
WireConnection;58;0;57;0
WireConnection;58;1;56;0
WireConnection;18;1;17;0
WireConnection;1;0;11;0
WireConnection;1;1;12;0
WireConnection;63;0;58;0
WireConnection;63;1;61;0
WireConnection;13;0;1;0
WireConnection;13;1;18;0
WireConnection;4;0;2;0
WireConnection;4;1;13;0
WireConnection;69;0;63;0
WireConnection;7;0;5;0
WireConnection;7;1;3;0
WireConnection;7;2;4;1
WireConnection;73;0;69;0
WireConnection;65;0;60;0
WireConnection;65;1;59;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;38;0;33;0
WireConnection;46;0;41;0
WireConnection;70;0;66;0
WireConnection;70;1;64;0
WireConnection;70;2;67;0
WireConnection;71;0;68;0
WireConnection;72;0;70;0
WireConnection;55;0;49;0
WireConnection;31;0;30;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;68;0;65;0
WireConnection;68;1;49;0
WireConnection;44;0;42;0
WireConnection;42;0;75;0
WireConnection;42;2;39;0
WireConnection;42;1;37;0
WireConnection;49;0;44;0
WireConnection;49;1;46;0
WireConnection;41;0;38;0
WireConnection;41;2;39;0
WireConnection;41;1;37;0
WireConnection;37;0;35;0
WireConnection;37;1;34;0
WireConnection;67;0;62;0
WireConnection;0;0;8;0
WireConnection;0;2;77;0
WireConnection;0;4;20;0
WireConnection;0;9;19;0
ASEEND*/
//CHKSM=DB7575B629E3672C7273835E9845D86718485530