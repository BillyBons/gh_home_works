using UnityEngine;
using System.Collections;

public class MovingStarship : MonoBehaviour {
    public float speed = 0.04F;
    public Transform SpawnPoint;
    private float x;
    private float y;
    // Use this for initialization
    void Start () {
        Invoke("Fire", 0.5f);
    }
	
	// Update is called once per frame
	void Update () {
        if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            // Get movement of the finger since last frame
            Vector2 touchDeltaPosition = Input.GetTouch(0).deltaPosition;
            // Move object across XY plane
            x = touchDeltaPosition.x * speed;
            y = -touchDeltaPosition.y * speed;
            transform.Translate(x, 0, y);
        }
    }

    void Fire()
    {
        
        GameObject fireShoot;
        //GameObject starShip = GameObject.Find("Default");
        float t = 0.5f;
        fireShoot = (GameObject)Instantiate(Resources.Load("Prefabs/FireImpulse"));
        fireShoot.transform.parent = SpawnPoint;
        fireShoot.transform.localPosition = Vector3.zero;
        fireShoot.transform.rotation = Quaternion.Euler(Vector3.zero);
        fireShoot.transform.localPosition = new Vector3(0.03f, 0, -1);
        Rigidbody2D rb = fireShoot.GetComponent<Rigidbody2D>();
        Vector2 fireVector2 = fireShoot.transform.up;
        rb.AddRelativeForce(fireVector2*100,ForceMode2D.Force);
        
        Invoke("Fire", t);
        //Destroy(fireShoot, 2);
    }

}
