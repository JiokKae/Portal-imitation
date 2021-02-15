using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Portal : MonoBehaviour
{
    public Portal linkedPortal;
    public MeshRenderer screen;
    Camera playerCam;
    Camera portalCam;
    RenderTexture viewTexture;
    public List<GameObject> camToPortals;

	private void Awake()
	{
        playerCam = Camera.main;
        portalCam = GetComponentInChildren<Camera>();
        portalCam.enabled = false;
        camToPortals = new List<GameObject>();
    }

    void CreateViewTexture()
	{
        if(viewTexture == null || viewTexture.width != Screen.width || viewTexture.height != Screen.height)
		{
            if(viewTexture != null)
			{
                viewTexture.Release();
			}
            viewTexture = new RenderTexture(Screen.width, Screen.height, 0);

            portalCam.targetTexture = viewTexture;

            linkedPortal.screen.material.SetTexture("_MainTex", viewTexture);
		}
	}

    static bool VisibleFromCamera(Renderer renderer, Camera camera)
	{
        Plane[] frustumPlanes = GeometryUtility.CalculateFrustumPlanes(camera);
        return GeometryUtility.TestPlanesAABB(frustumPlanes, renderer.bounds);
	}

    public void Render()
	{
        if(!VisibleFromCamera(linkedPortal.screen, playerCam))
		{
            var testTexture = new Texture2D(1, 1);
			testTexture.SetPixel(0, 0, Color.red);
            testTexture.Apply();
            linkedPortal.screen.material.SetTexture("_MainTex", testTexture);
            return;
		}

        linkedPortal.screen.material.SetTexture("_MainTex", viewTexture);
        screen.enabled = false;
        CreateViewTexture();

        var m = transform.localToWorldMatrix * linkedPortal.transform.worldToLocalMatrix * playerCam.transform.localToWorldMatrix;
        portalCam.transform.SetPositionAndRotation(m.GetColumn(3), m.rotation);

        Debug.DrawRay(portalCam.transform.position, portalCam.transform.forward * 1000.0f, Color.red);
        RaycastHit[] hits;
        hits = Physics.RaycastAll(portalCam.transform.position, portalCam.transform.forward, 1000.0f);
        
		foreach(var go in camToPortals)
		{
            go.layer = 0;
        }
        camToPortals.Clear();

        for (int i = 0; i < hits.Length; i++)
		{
            if (hits[i].collider.CompareTag("Portal"))
			{
                break;
			}
            else
			{
                hits[i].collider.gameObject.layer = 7;
                camToPortals.Add(hits[i].collider.gameObject);
			}
        }
        
        portalCam.Render();

        screen.enabled = true;
	}
}
