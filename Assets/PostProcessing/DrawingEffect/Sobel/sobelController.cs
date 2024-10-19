using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class sobelController : MonoBehaviour
{
    public Shader postShader;
    [Range(0.0f,1.0f)]
    public float threathHold;
    private Material mat;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat == null)
        {
            mat = new Material(postShader);
        }
        mat.SetFloat("_ThreathHold", threathHold);
        Graphics.Blit(source, destination, mat);
    }
}
