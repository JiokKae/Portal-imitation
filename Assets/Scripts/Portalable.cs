using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using g3;

public class Portalable : MonoBehaviour
{
	public MeshCollider meshCollider;

	//public Mesh cube;

	private void Start()
	{

	}

	public void StartPortalOpen(Vector3 hitPoint, Vector3 hitNormal, Portal portal, bool negative = false)
	{
		Vector3 hitLocalpoint = transform.worldToLocalMatrix.MultiplyPoint(hitPoint);
		Debug.Log("hit localPoint: " + hitLocalpoint);
		if (hitNormal.x == 0 && transform.localScale.x < 1.5f
			|| hitNormal.y == 0 && transform.localScale.y < 3.0f
			|| hitNormal.z == 0 && transform.localScale.z < 1.5f)
		{
			Debug.Log("Open Portal failed: scale lack");
			return;
		}

		//StartCoroutine(PortalOpen(hitLocalpoint, hitNormal));
		PortalOpen(hitLocalpoint, hitNormal, portal, negative);
	}

	void MeshBooleanPortalOpen(Vector3 hitLocalpoint)
	{
		Vector3[] vertices = new Vector3[8]
			{
			new Vector3(-0.5f, -0.5f, -0.5f),
			new Vector3(-0.5f, -0.5f,  0.5f),
			new Vector3(-0.5f,  0.5f, -0.5f),
			new Vector3(-0.5f,  0.5f,  0.5f),
			new Vector3( 0.5f, -0.5f, -0.5f),
			new Vector3( 0.5f, -0.5f,  0.5f),
			new Vector3( 0.5f,  0.5f, -0.5f),
			new Vector3( 0.5f,  0.5f,  0.5f),
			};

		int[] triangles = new int[(12) * 3]  {
				// front
				0,   2,  6,
				0,  6, 4,

				// down
				0,  5,  1,
				0,  4,  5,

				// back
				1,  5,  7,
				1,  7,  3,

				// up
				2,  7,  6,
				2,  3,  7,

				// left
				0,  1,  3,
				0,  3,  2,

				// right
				4,  7,  5,
				4,  6,  7,
		};

		int[] Rtriangles = new int[(12) * 3]  {
				// front
				0,   2,  6,
				0,  6, 4,

				// down
				0,  1,  5,
				0,  5,  4,

				// back
				1,  7,  5,
				1,  3,  7,

				// up
				2,  6,  7,
				2,  7,  3,

				// left
				0,  3,  1,
				0,  2,  3,

				// right
				4,  5,  7,
				4,  7,  6,
		};

		Mesh meshUnity = new Mesh { vertices = vertices, triangles = triangles };

		Vector3[] portalVertices = vertices;

		Matrix4x4 scaleMat = Matrix4x4.Scale(new Vector3(0.3f, 0.6f, 0.3f));
		for (int i = 0; i < portalVertices.Length; i++)
		{
			portalVertices[i] = scaleMat.MultiplyPoint(portalVertices[i]);
		}

		Matrix4x4 transMat = Matrix4x4.Translate(hitLocalpoint + new Vector3(0.0f, 0.0f, 0.0f));
		for (int i = 0; i < portalVertices.Length; i++)
		{
			portalVertices[i] = transMat.MultiplyPoint(portalVertices[i]);
			portalVertices[i].x = Mathf.Clamp(portalVertices[i].x, -0.5f, 0.5f);
			portalVertices[i].y = Mathf.Clamp(portalVertices[i].y, -0.5f, 0.5f);
			portalVertices[i].z = Mathf.Clamp(portalVertices[i].z, -0.5f, 0.5f);
		}

		Mesh meshToolUnity = new Mesh { vertices = portalVertices, triangles = Rtriangles };

		DMesh3 dmesh = g3UnityUtils.UnityMeshToDMesh(meshUnity);
		DMesh3 dmesh2 = g3UnityUtils.UnityMeshToDMesh(meshToolUnity);

		new MeshMeshCut { Target = dmesh, CutMesh = dmesh2 }.Compute();
		new MeshMeshCut { Target = dmesh, CutMesh = dmesh2 }.Compute();

		MeshBoolean boolean = new MeshBoolean();
		boolean.Target = dmesh;
		boolean.Tool = dmesh2;
		boolean.Compute();
		DMesh3 result = boolean.Result;



		Mesh resultUnityMesh = g3UnityUtils.DMeshToUnityMesh(dmesh);

		meshCollider.sharedMesh = resultUnityMesh;

		GetComponent<MeshFilter>().mesh = resultUnityMesh;
	}

	
	void PortalOpen(Vector3 hitLocalpoint, Vector3 hitNormal, Portal portal, bool negative = false)
	//IEnumerator PortalOpen(Vector3 hitLocalpoint, Vector3 hitNormal)
	{
		Vector3[] vertices = new Vector3[16]
		{
			new Vector3(-0.5f, -0.5f, -0.5f),
			new Vector3(-0.5f, -0.5f,  0.5f),
			new Vector3(-0.5f,  0.5f, -0.5f),
			new Vector3(-0.5f,  0.5f,  0.5f),
			new Vector3( 0.5f, -0.5f, -0.5f),
			new Vector3( 0.5f, -0.5f,  0.5f),
			new Vector3( 0.5f,  0.5f, -0.5f),
			new Vector3( 0.5f,  0.5f,  0.5f),

			new Vector3(-0.25f, -0.25f, -0.25f),
			new Vector3(-0.25f, -0.25f,  0.25f),
			new Vector3(-0.25f,  0.25f, -0.25f),
			new Vector3(-0.25f,  0.25f,  0.25f),
			new Vector3( 0.25f, -0.25f, -0.25f),
			new Vector3( 0.25f, -0.25f,  0.25f),
			new Vector3( 0.25f,  0.25f, -0.25f),
			new Vector3( 0.25f,  0.25f,  0.25f),
		};

		Vector3 portalScale;
        if (hitNormal.x != 0)
        {
            Debug.Log("x");
            portalScale = new Vector3(3 / transform.localScale.z, 6 / transform.localScale.y, 1.0f);
        }
        else if (hitNormal.z != 0)
        {
            Debug.Log("z");
            portalScale = new Vector3(3 / transform.localScale.x, 6 / transform.localScale.y, 1.0f);
        }
        else
        {
            Debug.Log("y");
            portalScale = new Vector3(3 / transform.localScale.x, 6 / transform.localScale.z, 1.0f);
        }

		Matrix4x4 scaleMatrix = Matrix4x4.Scale(portalScale);
        for (int i = 8; i < vertices.Length; i++)
        {
            vertices[i] = scaleMatrix.MultiplyPoint(vertices[i]);
        }

		/*
        ActiveMesh(vertices);
        yield return new WaitForSeconds(1.0f);
		*/

		hitLocalpoint = Matrix4x4.Rotate(Quaternion.FromToRotation(hitNormal, Vector3.back)).MultiplyPoint(hitLocalpoint);
		hitLocalpoint.x = Mathf.Clamp(hitLocalpoint.x, -0.5f + 0.25f * portalScale.x, 0.5f - 0.25f * portalScale.x);
		hitLocalpoint.y = Mathf.Clamp(hitLocalpoint.y, -0.5f + 0.25f * portalScale.y, 0.5f - 0.25f * portalScale.y);
		hitLocalpoint.z += 0.25f;

        Matrix4x4 translateMatrix = Matrix4x4.Translate(hitLocalpoint);
		for (int i = 8; i < vertices.Length; i++)
		{
			vertices[i] = translateMatrix.MultiplyPoint(vertices[i]);
		}

		/*
        ActiveMesh(vertices);
        yield return new WaitForSeconds(1.0f);
		*/

        Matrix4x4 rotateMat = Matrix4x4.Rotate(Quaternion.FromToRotation(Vector3.back, hitNormal));
		for (int i = 0; i < vertices.Length; i++)
		{
			vertices[i] = rotateMat.MultiplyPoint(vertices[i]);
		}

		hitLocalpoint.z -= 0.25f;
		hitLocalpoint = rotateMat.MultiplyPoint(hitLocalpoint);
		Vector3 newHitPoint = transform.localToWorldMatrix.MultiplyPoint(hitLocalpoint);

		portal.transform.position = newHitPoint + hitNormal * 0.001f;


        if(negative)
    		portal.transform.forward = hitNormal;
        else
            portal.transform.forward = -hitNormal;

        ActiveMesh(vertices);
    }

    void ActiveMesh(Vector3[] vertices)
    {
		Mesh mesh = new Mesh
		{
			vertices = vertices,
			triangles = new int[(10 + 10 + 8) * 3]	{
				// front
				0,   2, 10,
				0,  10,  8,

				0,  8,  4,
				8,  12, 4,

				12, 14, 6,
				12, 6,  4,

				2,  14, 10,
				2,  6,  14,

				// down
				0,  5,  1,
				0,  4,  5,

				// back
				1,  5,  7,
				1,  7,  3,

				// up
				2,  7,  6,
				2,  3,  7,

				// left
				0,  1,  3,
				0,  3,  2,

				// right
				4,  7,  5,
				4,  6,  7,


				// small

				// down
				0+8,  1+8,  5+8,
				0+8,  5+8,  4+8,

				// back	 
				1+8,  7+8,  5+8,
				1+8,  3+8,  7+8,

				// up	 
				2+8,  6+8,  7+8,
				2+8,  7+8,  3+8,

				// left	
				0+8,  3+8,  1+8,
				0+8,  2+8,  3+8,

				// right
				4+8,  5+8,  7+8,
				4+8,  7+8,  6+8,
			}
		};
		mesh.Optimize();
        mesh.RecalculateNormals();
        meshCollider.sharedMesh = mesh;

        //GetComponent<MeshFilter>().mesh = mesh;
    }
}
