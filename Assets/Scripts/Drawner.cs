using System.Collections;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Drawner : MonoBehaviour {
    [SerializeField] private float drawnTime;
    private CMF.SimpleWalkerController controller;
    private new Rigidbody rigidbody;
    private float olgGravity;

    private Vector3 startPosition => DayTransitionManager.instance.SpawnPos[DayTransitionManager.instance.dayIndex].position;

    private void Awake() {
        rigidbody = GetComponent<Rigidbody>();
        controller = GetComponent<CMF.SimpleWalkerController>();
    }

    private void OnTriggerEnter(Collider other) {
        if(!other.CompareTag("Water")) return;
        olgGravity = controller.gravity;
        controller.gravity = 1;
        controller.currentVerticalSpeed = -1;
        StartCoroutine(Drawn());
    }

    private void OnTriggerExit(Collider other) {
        if(!other.CompareTag("Water")) return;
        StopAllCoroutines();
        controller.gravity = olgGravity;
    }

    public IEnumerator Drawn() {
        yield return new WaitForSeconds(drawnTime);
        transform.position = startPosition;
    }

}
