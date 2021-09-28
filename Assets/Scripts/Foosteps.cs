using UnityEngine;

public class Foosteps : MonoBehaviour {
    [SerializeField] private GameObject frontRightFoot, frontLeftFoot, backRightFoot, backLeftFoot;
    [SerializeField] private GameObject footstepPrefab;
    [SerializeField] private Etienne.Cue cue;

    [ContextMenu("Front Right")]
    public void PrintFootstepFrontRight() {
        PrintFootstep(frontRightFoot);
    }
    public void PrintFootstepFrontLeft() {
        PrintFootstep(frontLeftFoot);
    }
    public void PrintFootstepBackRight() {
        PrintFootstep(backRightFoot);
    }
    public void PrintFootstepBackLeft() {
        PrintFootstep(backLeftFoot);
    }

    private void PrintFootstep(GameObject foot) {
        Ray ray = new Ray(foot.transform.position, Vector3.down);
        if(Physics.Raycast(ray, out RaycastHit hit, 10f)) {
            Vector3 pos = hit.point;
            pos.y += .01f;
            GameObject footstep = GameObject.Instantiate(footstepPrefab, pos, footstepPrefab.transform.rotation);
            footstep.transform.forward = hit.normal;
            GameObject.Destroy(footstep, 15f);
            Etienne.AudioManager.Play(cue, pos);
        }
    }
}
