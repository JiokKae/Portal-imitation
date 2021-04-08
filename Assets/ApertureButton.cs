using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public delegate void DelegateFunc();

public class ApertureButton : MonoBehaviour
{
    public BoxCollider boxCollider;

    public GameObject BottonTop;

	public float destHeight = 0.2315f;

	public Texture2D blueTex;
	public Texture2D orangeTex;


    public DelegateFunc onFunction;
    public DelegateFunc offFunction;
	// sound
	AudioSource buttonAudioPlayer;
	public AudioClip buttonDownClip;
	public AudioClip buttonUpClip;

	Material[] materials;
	List<GameObject> objectsOnButton = new List<GameObject>();
	
	private void Start()
	{
		buttonAudioPlayer = GetComponent<AudioSource>();
		materials = GetMaterials(gameObject);
	}

	private void Update()
	{
		BottonTop.transform.position = Vector3.Lerp(BottonTop.transform.position, transform.position + new Vector3(0, destHeight, 0), Time.deltaTime * 2f);
	}

	private void OnTriggerEnter(Collider other)
	{
		objectsOnButton.Add(other.gameObject);
		if (objectsOnButton.Count == 1)
		{
			destHeight = 0.0f;
			for (int i = 0; i < materials.Length; i++)
			{
				materials[i].SetTexture("_MainTex", orangeTex);
			}
			buttonAudioPlayer.PlayOneShot(buttonDownClip);
            onFunction();
		}
	}

	private void OnTriggerExit(Collider other)
	{
		objectsOnButton.Remove(other.gameObject);
		if(objectsOnButton.Count == 0)
		{
			destHeight = 0.2315f;
			for (int i = 0; i < materials.Length; i++)
			{
				materials[i].SetTexture("_MainTex", blueTex);
			}
			buttonAudioPlayer.PlayOneShot(buttonUpClip);
            offFunction();
		}
	}

	Material[] GetMaterials(GameObject g)
	{
		var renderers = g.GetComponentsInChildren<Renderer>();
		var matList = new List<Material>();
		foreach (var renderer in renderers)
		{
			foreach (var mat in renderer.materials)
			{
				matList.Add(mat);
			}
		}
		return matList.ToArray();
	}
}
