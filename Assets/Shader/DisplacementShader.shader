Shader "Unlit/DisplacementShader"
{ 
    Properties{
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _NoiseTex("Noise Texture", 2D) = "black" {}

    }
    SubShader
    {

       
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _NoiseTex;
            uniform float4 _NoiseTex_ST;

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex:POSITION;
                float4 normal:NORMAL;
                float4 texcoord: TEXCOORD0;

            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                float displacement = tex2Dlod(_NoiseTex, v.texcoord*_NoiseTex_ST);
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex+(v.vertex * displacement*0.1f));
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
            return tex2D(_MainTex, i.texcoord) * _Color;
            }
            ENDCG
        }
    }
}
