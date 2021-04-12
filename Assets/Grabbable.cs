using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grabbable : MonoBehaviour
{
	private Rigidbody _rigidbody;

	private void Start()
	{
		_rigidbody = GetComponent<Rigidbody>();
	}

	public void Grab(Vector3 position)
	{
		_rigidbody.isKinematic = true;
		transform.position = Vector3.Lerp(transform.position, position, 5f * Time.deltaTime);
	}
}
