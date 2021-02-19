using UnityEngine;

public class MainCamera : MonoBehaviour
{
    Portal[] portals;

    void Awake()
    {
        portals = FindObjectsOfType<Portal>();
    }

    void OnPreCull()
    {
        for (int i = 0; i < portals.Length; i++)
        {
            portals[i].PrePortalRender();
        }
        for (int i = 0; i < portals.Length; i++)
        {
            portals[i].Render();
        }
        for (int i = 0; i < portals.Length; i++)
        {
            portals[i].PostPortalRender();
        }
    }
    void Update()
	{
        Debug.DrawRay(transform.position, transform.forward * 1000.0f, Color.red);
	}
}