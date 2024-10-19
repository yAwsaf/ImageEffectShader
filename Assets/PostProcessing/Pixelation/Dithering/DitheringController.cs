using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DitheringController : MonoBehaviour
{
    public Shader postShader;

    [Range(0.0f, 1.0f)]
    public float spread = 0.5f;

    [Range(2, 16)]
    public int redColorCount = 2;
    [Range(2, 16)]
    public int greenColorCount = 2;
    [Range(2, 16)]
    public int blueColorCount = 2;

    [Range(1, 3)]
    public int bayerLevel = 1;

    private Material mat;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null)
        {
            mat = new Material(postShader);
        }
        mat.SetFloat("_Spread", spread);
        mat.SetInt("_RedColorCount", redColorCount);
        mat.SetInt("_GreenColorCount", greenColorCount);
        mat.SetInt("_BlueColorCount", blueColorCount);
        mat.SetInt("_BayerLevel", bayerLevel);
        Graphics.Blit(src, dest, mat);
    }
}
