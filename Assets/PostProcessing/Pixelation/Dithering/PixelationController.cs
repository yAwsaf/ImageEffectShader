using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PixelationController : MonoBehaviour
{
    public Shader postShader;
    private Material mat;
    [Range(0,10)]
    public int downSamples;
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null)
        {
            mat = new Material(postShader);
        }

        int width = src.width;
        int height = src.height;

        RenderTexture Srctemp = RenderTexture.GetTemporary(width, height, 0, src.format);
        Srctemp = src;
        for (int i = 0;i< downSamples; i++)
        {
            width /= 2;
            height /= 2;

            if (height < 2) // we don't need to check width as we know reslution in height more less that width 
                break;

            RenderTexture desttemp = RenderTexture.GetTemporary(width, height, 0, src.format);
            Graphics.Blit(Srctemp, desttemp, mat);
            Srctemp = desttemp;
            RenderTexture.ReleaseTemporary(desttemp);
        }
        Graphics.Blit(Srctemp, dest,mat);
        RenderTexture.ReleaseTemporary(Srctemp);
    }
}
