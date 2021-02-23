using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Portalable : MonoBehaviour
{
	public MeshCollider meshCollider;

	private void Start()
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

			new Vector3(-0.25f, -0.25f, -0.5f),
			new Vector3(-0.25f, -0.25f,  0.0f),
			new Vector3(-0.25f,  0.25f, -0.5f),
			new Vector3(-0.25f,  0.25f,  0.0f),
			new Vector3( 0.25f, -0.25f, -0.5f),
			new Vector3( 0.25f, -0.25f,  0.0f),
			new Vector3( 0.25f,  0.25f, -0.5f),
			new Vector3( 0.25f,  0.25f,  0.0f),
		};

        ActiveMesh(vertices);
    }

    public void StartPortalOpen(Vector3 hitPoint, Vector3 hitNormal)
    {
        StartCoroutine(PortalOpen(hitPoint, hitNormal));
    }

	IEnumerator PortalOpen(Vector3 hitPoint, Vector3 hitNormal)
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

        
        Matrix4x4 scaleMatrix = Matrix4x4.Scale(new Vector3(1 / transform.localScale.x, 1 / transform.localScale.y, 1.0f));
        for (int i = 8; i < vertices.Length; i++)
        {
            vertices[i] = scaleMatrix.MultiplyPoint(vertices[i]);
        }

        ActiveMesh(vertices);

        yield return new WaitForSeconds(3.0f);

        Vector3 hitPointInLocal = transform.worldToLocalMatrix.MultiplyPoint(hitPoint);
        hitPointInLocal.z = -0.25f;
        Matrix4x4 translateMatrix = Matrix4x4.Translate(hitPointInLocal);
		for (int i = 8; i < vertices.Length; i++)
		{
			vertices[i] = translateMatrix.MultiplyPoint(vertices[i]);
		}

        ActiveMesh(vertices);

        yield return new WaitForSeconds(3.0f);

        Matrix4x4 rotateMat = Matrix4x4.Rotate(Quaternion.FromToRotation(Vector3.back, hitNormal));
		for (int i = 0; i < vertices.Length; i++)
		{
			vertices[i] = rotateMat.MultiplyPoint(vertices[i]);
		}
        ActiveMesh(vertices);

    }

    void ActiveMesh(Vector3[] vertices)
    {
        Mesh mesh = new Mesh();

        mesh.vertices = vertices;

        mesh.triangles = new int[(10 + 10 + 8) * 3]
        {
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
        };
        mesh.Optimize();
        mesh.RecalculateNormals();
        meshCollider.sharedMesh = mesh;

        GetComponent<MeshFilter>().mesh = mesh;
    }
}
