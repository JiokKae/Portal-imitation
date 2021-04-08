using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneManager : MonoBehaviour
{
    public Door exitDoor;
    public ApertureButton button;

    // Start is called before the first frame update
    void Start()
    {
        button.onFunction = exitDoor.Open;
        button.offFunction = exitDoor.Close;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
