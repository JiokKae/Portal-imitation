// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/PortalShader"
{
	Properties
	{
		[HDR]_PortalColor("PortalColor", Color) = (1.498039,0.9098039,0.2745098,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_Open("Open", Range( 0 , 1)) = 0.9367462
		_rad("rad", Range( 0 , 2)) = 0.69
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
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _PortalColor;
		uniform sampler2D _MainTex;
		uniform float _Open;
		uniform float _rad;
		uniform float _Cutoff = 0.5;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult61 = (float2(_Time.y , 0.0));
			float2 uv_TexCoord35 = i.uv_texcoord * float2( 2,2 ) + appendResult61;
			float simplePerlin2D31 = snoise( uv_TexCoord35*2.0 );
			simplePerlin2D31 = simplePerlin2D31*0.5 + 0.5;
			float temp_output_66_0 = ( simplePerlin2D31 / 2.0 );
			float2 appendResult60 = (float2(( _Time.y * -1.0 ) , 0.0));
			float2 uv_TexCoord46 = i.uv_texcoord * float2( 2,2 ) + appendResult60;
			float simplePerlin2D45 = snoise( uv_TexCoord46*2.0 );
			simplePerlin2D45 = simplePerlin2D45*0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos8 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeScreenPos9 = ComputeScreenPos( unityObjectToClipPos8 );
			float4 break29 = computeScreenPos9;
			float2 appendResult27 = (float2(break29.x , break29.y));
			float4 lerpResult39 = lerp( ( ( _PortalColor * temp_output_66_0 ) * ( _PortalColor * simplePerlin2D45 ) ) , tex2D( _MainTex, ( appendResult27 / break29.w ) ) , _Open);
			o.Emission = lerpResult39.rgb;
			o.Alpha = 1;
			float4 color111 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color117 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 ifLocalVar112 = 0;
			if( length( ase_vertex3Pos ) <= _rad )
				ifLocalVar112 = color117;
			else
				ifLocalVar112 = color111;
			clip( ifLocalVar112.r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
29;141;1504;1004;-805.879;-611.1081;1.3;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;7;-738.663,1066.937;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;50;-830.6601,358.6922;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-566.2026,481.8094;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-494.9067,242.1917;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;8;-531.9641,1066.337;Inherit;True;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;60;-360.4576,479.3562;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-285.8926,191.6473;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;9;-308.4313,1067.661;Inherit;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-160.8525,453.1375;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;29;-110.8972,1066.644;Inherit;True;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NoiseGeneratorNode;31;-6.681262,131.8552;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-1840.95,1438.751;Inherit;False;Property;_PortalColor;PortalColor;0;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.9098039,0.2745098,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;126;-930.1707,-42.34566;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;66;269.0457,132.6205;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;116.248,1026.482;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;125;-1039.12,-71.60386;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;151.9165,447.7859;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;284.879,1051.6;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;271.6902,856.2153;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;509.1419,41.64176;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;524.9262,361.0992;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;115;337.1596,1835.168;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;605.4327,1984.379;Inherit;False;Property;_rad;rad;4;0;Create;True;0;0;0;False;0;False;0.69;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;116;593.2415,1876.111;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;1090.644,863.097;Inherit;False;Property;_Open;Open;3;0;Create;True;0;0;0;False;0;False;0.9367462;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;597.4284,861.4081;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;117;631.3595,2094.561;Inherit;False;Constant;_Color1;Color 1;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;860.0124,164.9287;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;111;664.8984,2302.189;Inherit;False;Constant;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;112;1077.553,2045.662;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.01;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;130;1681.023,1061.105;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.48;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;128;722.615,2636.839;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;122;542.8298,265.7386;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;127;1452.054,2066.919;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;139;892.2407,1476.909;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;39;1112.867,652.7178;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;131;1056.94,1059.73;Inherit;False;Constant;_Color2;Color 2;5;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;132;1001.026,1275.602;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;141;1200.283,1612.917;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;142;954.079,1688.807;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;120;566.1823,584.9521;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;137;1319.125,1318.297;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;119;2046.795,1200.069;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/PortalShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;50;2
WireConnection;61;0;50;2
WireConnection;8;0;7;0
WireConnection;60;0;51;0
WireConnection;35;1;61;0
WireConnection;9;0;8;0
WireConnection;46;1;60;0
WireConnection;29;0;9;0
WireConnection;31;0;35;0
WireConnection;126;0;38;0
WireConnection;66;0;31;0
WireConnection;27;0;29;0
WireConnection;27;1;29;1
WireConnection;125;0;38;0
WireConnection;45;0;46;0
WireConnection;25;0;27;0
WireConnection;25;1;29;3
WireConnection;63;0;125;0
WireConnection;63;1;66;0
WireConnection;57;0;126;0
WireConnection;57;1;45;0
WireConnection;116;0;115;0
WireConnection;1;0;5;0
WireConnection;1;1;25;0
WireConnection;41;0;63;0
WireConnection;41;1;57;0
WireConnection;112;0;116;0
WireConnection;112;1;95;0
WireConnection;112;2;111;0
WireConnection;112;3;117;0
WireConnection;112;4;117;0
WireConnection;130;0;137;0
WireConnection;130;2;131;0
WireConnection;130;3;39;0
WireConnection;130;4;39;0
WireConnection;128;0;38;0
WireConnection;122;0;66;0
WireConnection;127;2;112;0
WireConnection;127;3;112;0
WireConnection;127;4;128;0
WireConnection;39;0;41;0
WireConnection;39;1;1;0
WireConnection;39;2;40;0
WireConnection;141;0;139;0
WireConnection;141;1;142;0
WireConnection;120;0;45;0
WireConnection;137;0;132;0
WireConnection;137;1;141;0
WireConnection;119;2;39;0
WireConnection;119;10;112;0
ASEEND*/
//CHKSM=3995DAEC084294B9006A19281071DA8FACE4925D