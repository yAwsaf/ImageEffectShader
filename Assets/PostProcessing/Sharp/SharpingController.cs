using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SharpingController : MonoBehaviour
{
    public Shader postShader;
    private Material mat;
    public int amount;
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null)
        {
            mat = new Material(postShader);
        }
        mat.SetInt("_Amount", amount);
        Graphics.Blit(src, dest, mat);
    }
}
