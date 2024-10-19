using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ColorPaletteController : MonoBehaviour
{
    public Shader postShader;
    public Texture colorPalette;
    private Material mat;
    public bool inverse;
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if(mat == null)
        {
            mat = new Material(postShader);
        }
        mat.SetTexture("_ColorPalette", colorPalette);
        mat.SetInt("_Inverse", inverse ? 1 : 0);
        Graphics.Blit(src, dest,mat);
    }
}
