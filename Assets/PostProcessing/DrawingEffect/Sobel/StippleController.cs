using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class StippleController : MonoBehaviour
{
    public Shader postShader;
    public Texture StippleTexute;
    [Range(0.0f, 1.0f)]
    public float threathHold;
    [Range(0.0f, 1.0f)]
    public float value;
    [Range(1.0f, 10.0f)]
    public float grayFactor;
    private Material mat;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat == null)
        {
            mat = new Material(postShader);
        }
        mat.SetFloat("_ThreathHold", threathHold);
        mat.SetFloat("_Value", value);
        mat.SetFloat("_GrayFactor", grayFactor);
        mat.SetTexture("_StippleTexture", StippleTexute);
        Graphics.Blit(source, destination, mat);
    }
}
