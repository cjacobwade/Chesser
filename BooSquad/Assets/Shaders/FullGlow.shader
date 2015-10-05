Shader "Custom/FullGlow" 
{
	Properties 
	{
		_Color ( "Color", Color ) = ( 1, 1, 1, 1 )
		
		_Glossiness ( "Smoothness", Range( 0, 1 ) ) = 0.5
		_Metallic ( "Metallic", Range( 0, 1 ) ) = 0.0
	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		
		fixed4 _Color;
		fixed4 _GlowColor;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;

			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
