using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class ColorCorrectionController : MonoBehaviour
{
    public Shader postShader;

    [Range(0.0f, 5.0f)]
    public float contrast;

    [Range(-1.0f, 1.0f)]
    public float brightness;

    [Range(0.0f, 5.0f)]
    public float saturation;

    [Range(0.0f, 1.0f)]
    public float maxWhite;

    [Range(0.0f, 5.0f)]
    public float gamma;
    private Material mat;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null)
        {
            mat = new Material(postShader);
        }

        mat.SetFloat("_Contrast", contrast);
        mat.SetFloat("_Brightness", brightness);
        mat.SetFloat("_Saturation", saturation);
        mat.SetFloat("_MaxWhite", maxWhite);
        mat.SetFloat("_Gamma", gamma);
        Graphics.Blit(src, dest, mat);
    }
}
