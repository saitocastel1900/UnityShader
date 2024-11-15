using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class Wipe : ScriptableRendererFeature
{
    [System.Serializable]
    public class WipeSetting
    {
        // レンダリングの実行タイミング
        public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingTransparents;
    }

    /// <summary>
    /// Grayscale実行Pass
    /// </summary>
    class WipePass : ScriptableRenderPass
    {
        private readonly string profilerTag = "Wipe Pass";

        public Material wipeMaterial; // グレースケール計算用マテリアル

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            var cameraColorTarget = renderingData.cameraData.renderer.cameraColorTarget;

            // コマンドバッファ
            var cmd = CommandBufferPool.Get(profilerTag);

            // マテリアル実行
            cmd.Blit(cameraColorTarget, cameraColorTarget, wipeMaterial);

            context.ExecuteCommandBuffer(cmd);
        }
    }

    [SerializeField] private WipeSetting settings = new WipeSetting();
    private WipePass scriptablePass;
    
    public override void Create()
    {
        var shader = Shader.Find("Unlit/WipeUnlitShader");
        if (shader)
        {
            scriptablePass = new WipePass();
            scriptablePass.wipeMaterial = new Material(shader);
            scriptablePass.renderPassEvent = settings.renderPassEvent;
        }
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (scriptablePass != null && scriptablePass.wipeMaterial != null)
        {
            renderer.EnqueuePass(scriptablePass);
        }
    }
}
