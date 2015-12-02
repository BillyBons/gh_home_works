using UnityEngine;
using System.Collections;

public class FireImpulse : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

  //   void OnTriggerEnter2D(Collider2D coll)
  //  {
  //      if (coll.transform.tag == "Rock")
  //      {
  //          coll.transform.GetComponent<Rock>().DestroyRock();
  //          Destroy(gameObject);
  //      }
  //  }

    void OnBecameInvisible()
    {
        Destroy(gameObject);
    }
}
