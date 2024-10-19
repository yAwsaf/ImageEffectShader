using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class HachingController : MonoBehaviour
{
    public Shader postShader;
    public Texture HachingTexute1;
    public Texture HachingTexute2;
    public Texture HachingTexute3;
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
        mat.SetTexture("_HachingTexute1", HachingTexute1);
        mat.SetTexture("_HachingTexute2", HachingTexute2);
        mat.SetTexture("_HachingTexute3", HachingTexute3);
        Graphics.Blit(source, destination, mat);
    }
}
