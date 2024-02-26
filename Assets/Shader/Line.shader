Shader "Unlit/Line"
{ 
    Properties{
        _Color("Color",Color) = (1,1,1,1)
        _ColorSecond("Secondary Color",Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _SecondaryTexture("Secondary texture", 2D) = "white"{}
        _LinesAmount("Line amount", int) = 0

    }
    SubShader
    {
        Tags { 
            "Queue" = "Transparent"
            "RenderType"="Transparent" 
            "IgnoreProjector"="True"
        }
       
        Pass
        {
           
            
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform half4 _ColorSecond;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _SecondaryTexture;
            uniform float4 _SecondaryTexture_ST;
            uniform int _LinesAmount;

            #include "UnityCG.cginc"
             float draswLine(float2 uv, float start, float end)
             {
                 if(uv.x > start && uv.x<end)
                 {
                     return 1;
                 }
                 return 0;
             }
                        
            struct VertexInput
            {
                float4 vertex:POSITION;
                float4 texcoord: TEXCOORD0;

            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
                half4 color;
                float percent = (1.0/_LinesAmount)*100.0;
                if((i.texcoord.x*100)% (2*percent)<percent)
                {
                    color = tex2D(_MainTex, i.texcoord)*_Color;
                }
                    
                else
                {
                    color = tex2D(_SecondaryTexture, i.texcoord)*_ColorSecond;
                }
                //color.a = draswLine(i.texcoord,x-1,x);
                
                
                return color;
            }
            ENDCG
        }
    }
}
