// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/PortalShader"
{
	Properties
	{
		[HDR]_PortalColor("PortalColor", Color) = (1.498039,0.9098039,0.2745098,0)
		_MainTexture("Main Texture", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_DistortTexture("Distort Texture", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_Open("Open", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 0.2
		_rad("rad", Range( 0 , 2)) = 0
		_te("te", Float) = 0.001
		_Exp("Exp", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform sampler2D _MainTex;
		uniform float4 _PortalColor;
		uniform sampler2D _MainTexture;
		uniform float _Speed;
		uniform sampler2D _DistortTexture;
		uniform float4 _DistortTexture_ST;
		uniform float _Open;
		uniform float _Exp;
		uniform float _te;
		uniform float _rad;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 normalizeResult205 = normalize( cross( ddx( ase_vertex3Pos ) , ddy( ase_vertex3Pos ) ) );
			float dotResult137 = dot( normalizeResult205 , ase_vertex3Pos );
			float4 unityObjectToClipPos8 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeScreenPos9 = ComputeScreenPos( unityObjectToClipPos8 );
			float4 break29 = computeScreenPos9;
			float2 appendResult27 = (float2(break29.x , break29.y));
			float4 tex2DNode1 = tex2D( _MainTex, ( appendResult27 / break29.w ) );
			float mulTime158 = _Time.y * _Speed;
			float2 panner159 = ( mulTime158 * float2( -1,0 ) + float2( 0,0 ));
			float2 uv_TexCoord162 = i.uv_texcoord + panner159;
			float2 uv_DistortTexture = i.uv_texcoord * _DistortTexture_ST.xy + _DistortTexture_ST.zw;
			float4 tex2DNode164 = tex2D( _DistortTexture, uv_DistortTexture );
			float mulTime157 = _Time.y * _Speed;
			float2 panner160 = ( mulTime157 * float2( 1,0 ) + float2( 0,0 ));
			float2 uv_TexCoord163 = i.uv_texcoord + panner160;
			float4 temp_output_171_0 = ( _PortalColor * ( tex2D( _MainTexture, ( float4( uv_TexCoord162, 0.0 , 0.0 ) + tex2DNode164 + float4( float2( 0,0.66 ), 0.0 , 0.0 ) ).rg ) * tex2D( _MainTexture, ( float4( uv_TexCoord163, 0.0 , 0.0 ) + tex2DNode164 ).rg ) ) * 2.0 );
			float4 lerpResult39 = lerp( temp_output_171_0 , tex2DNode1 , _Open);
			float4 ifLocalVar130 = 0;
			if( dotResult137 > 0.48 )
				ifLocalVar130 = tex2DNode1;
			else if( dotResult137 < 0.48 )
				ifLocalVar130 = ( lerpResult39 + ( temp_output_171_0 * ( pow( length( ase_vertex3Pos ) , _Exp ) * _te * _PortalColor ) ) );
			o.Emission = ifLocalVar130.rgb;
			o.Alpha = 1;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float dotResult215 = dot( ase_vertexNormal , float3(0,0,1) );
			float ifLocalVar112 = 0;
			if( length( ase_vertex3Pos ) <= _rad )
				ifLocalVar112 = 1.0;
			else
				ifLocalVar112 = 0.0;
			float ifLocalVar206 = 0;
			if( dotResult137 >= 0.0 )
				ifLocalVar206 = 1.0;
			else
				ifLocalVar206 =  ( abs( dotResult215 ) - 0.01 > 0.0 ? ifLocalVar112 : abs( dotResult215 ) - 0.01 <= 0.0 && abs( dotResult215 ) + 0.01 >= 0.0 ? 0.0 : 0.0 ) ;
			clip( ifLocalVar206 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
113;187;1504;986;-1400.256;-610.9211;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;156;-1405.407,145.4606;Float;False;Property;_Speed;Speed;6;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;7;-866.0862,1223.32;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;157;-932.6055,531.0389;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;158;-772.0681,-14.16823;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;8;-659.3873,1222.72;Inherit;True;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;159;-578.1881,-153.8612;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;160;-677.2003,471.8595;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;162;-335.0459,-168.3333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;178;-280.3718,114.4268;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;0;False;0;False;0,0.66;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-409.798,452.9553;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;9;-435.8543,1224.044;Inherit;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;164;-679.8821,135.7141;Inherit;True;Property;_DistortTexture;Distort Texture;3;0;Create;True;0;0;0;False;0;False;-1;e28dc97a9541e3642a48c0e3886688c5;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;166;-147.4802,343.5155;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;29;-238.3204,1223.027;Inherit;True;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-131.7498,-36.4106;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;190;1391.28,1198.753;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;167;15.18761,-24.99361;Inherit;True;Property;_MainTexture;Main Texture;1;0;Create;True;0;0;0;False;0;False;-1;cd460ee4ac5c1e746b7a734cc7cc64dd;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;168;19.70906,238.3567;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;167;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;27;-11.17515,1182.865;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;197;1454.418,1475.845;Inherit;False;Property;_Exp;Exp;10;0;Create;True;0;0;0;False;0;False;0;9.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;218;504.7685,1283.331;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;191;1426.066,1352.119;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;288.9758,945.9805;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PosVertexDataNode;115;1757.894,1533.863;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;683.0922,91.85408;Inherit;False;Property;_PortalColor;PortalColor;0;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.9098039,0.2745098,0;0.1633856,0.4071153,1.356811,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;179;684.9965,458.6428;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;341.3106,-8.049211;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;157.4559,1207.983;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalVertexDataNode;209;2262.839,1190.932;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DdyOpNode;202;688.6789,1345.151;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdxOpNode;200;688.6789,1278.151;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;196;1623.589,1191.871;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;56.49;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;1683.644,1437.587;Inherit;False;Property;_te;te;9;0;Create;True;0;0;0;False;0;False;0.001;44.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;212;2283.452,1334.399;Inherit;False;Constant;_Vector1;Vector 1;11;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;854.402,359.7976;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;1876.268,1208.686;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;645.1157,982.1492;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;1090.644,863.097;Inherit;False;Property;_Open;Open;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;215;2451.452,1252.399;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;1896.115,1739.882;Inherit;False;Constant;_Black;Black;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;1898.632,1808.055;Inherit;False;Constant;_White;White;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;1759.668,1672.674;Inherit;False;Property;_rad;rad;7;0;Create;True;0;0;0;False;0;False;0;0.71;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;116;1918.395,1534.919;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;203;822.6789,1299.151;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;39;1112.867,652.7178;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;219;2681.941,1249.132;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;2027.527,1203.818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;112;2201.533,1522.383;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;204;943.7017,1418.92;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;205;982.7014,1287.62;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;137;1169.715,1248.706;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;217;2907.067,1448.237;Inherit;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;188;2154.568,982.2456;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-1044.992,203.8889;Float;False;Property;_UVDistortIntensity;UV Distort Intensity;8;0;Create;True;0;0;0;False;0;False;0.08;0.08;0;0.08;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;206;3161.962,1650.858;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;130;2370.776,816.2592;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.48;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;119;3435.628,1246.65;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/PortalShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;157;0;156;0
WireConnection;158;0;156;0
WireConnection;8;0;7;0
WireConnection;159;1;158;0
WireConnection;160;1;157;0
WireConnection;162;1;159;0
WireConnection;163;1;160;0
WireConnection;9;0;8;0
WireConnection;166;0;163;0
WireConnection;166;1;164;0
WireConnection;29;0;9;0
WireConnection;165;0;162;0
WireConnection;165;1;164;0
WireConnection;165;2;178;0
WireConnection;167;1;165;0
WireConnection;168;1;166;0
WireConnection;27;0;29;0
WireConnection;27;1;29;1
WireConnection;191;0;190;0
WireConnection;170;0;167;0
WireConnection;170;1;168;0
WireConnection;25;0;27;0
WireConnection;25;1;29;3
WireConnection;202;0;218;0
WireConnection;200;0;218;0
WireConnection;196;0;191;0
WireConnection;196;1;197;0
WireConnection;171;0;38;0
WireConnection;171;1;170;0
WireConnection;171;2;179;0
WireConnection;193;0;196;0
WireConnection;193;1;194;0
WireConnection;193;2;38;0
WireConnection;1;0;5;0
WireConnection;1;1;25;0
WireConnection;215;0;209;0
WireConnection;215;1;212;0
WireConnection;116;0;115;0
WireConnection;203;0;200;0
WireConnection;203;1;202;0
WireConnection;39;0;171;0
WireConnection;39;1;1;0
WireConnection;39;2;40;0
WireConnection;219;0;215;0
WireConnection;220;0;171;0
WireConnection;220;1;193;0
WireConnection;112;0;116;0
WireConnection;112;1;95;0
WireConnection;112;2;207;0
WireConnection;112;3;208;0
WireConnection;112;4;208;0
WireConnection;205;0;203;0
WireConnection;137;0;205;0
WireConnection;137;1;204;0
WireConnection;217;0;219;0
WireConnection;217;2;112;0
WireConnection;217;3;207;0
WireConnection;188;0;39;0
WireConnection;188;1;220;0
WireConnection;206;0;137;0
WireConnection;206;2;208;0
WireConnection;206;3;208;0
WireConnection;206;4;217;0
WireConnection;130;0;137;0
WireConnection;130;2;1;0
WireConnection;130;4;188;0
WireConnection;119;2;130;0
WireConnection;119;10;206;0
ASEEND*/
//CHKSM=92D5F1387B402FC3DAF9043250716BB83BD75C08