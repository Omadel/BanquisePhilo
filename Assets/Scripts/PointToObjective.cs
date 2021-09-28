using UnityEngine;
using UnityEngine.UI;

public class PointToObjective : MonoBehaviour {
    [SerializeField] private TimeOfDayHandeler timeOfDayHandeler;
    [SerializeField] private Sprite insideSprite, outsideSprite;
    [SerializeField] private Side side;
    [SerializeField] private Vector2 stateOffset = new Vector2(192, 108);
    private Camera cam;
    private RectTransform canvas;
    private Image image;
    private DoTween2DAnimation[] animations;

    private enum Side { Inside, Up, Left, Down, Right }
    private Vector2[] offsets = new Vector2[] { new Vector2(0, 45), new Vector2(0, 0), new Vector2(0, 25), new Vector2(0, 0), new Vector2(0, 20), };
    private float[] angles = new float[] { 180, 0, 90, 180, -90 };

    private void Awake() {
        cam = Camera.main;
        canvas = GetComponentInParent<Canvas>().GetComponent<RectTransform>();
        image = GetComponentInChildren<Image>();
        animations = GetComponentsInChildren<DoTween2DAnimation>();
    }

    private void Update() {
        Vector3 pos = cam.WorldToScreenPoint(timeOfDayHandeler.Objective.transform.position);
        if(transform.position != pos) {
            if(IsClampToCanvas(out Vector3 localPos, pos)) {
                image.sprite = outsideSprite;
                animations[0].enabled = false;
                animations[1].enabled = true;
            } else {
                image.sprite = insideSprite;
                animations[1].enabled = false;
                animations[0].enabled = true;
            }
            transform.localPosition = localPos;
            image.transform.rotation = Quaternion.Euler(0, 0, angles[(int)side]);
        }
    }

    private bool IsClampToCanvas(out Vector3 localPos, Vector3 pos) {
        transform.position = pos;
        localPos = transform.localPosition;
        localPos.z = 0;
        side = Side.Inside;
        if(localPos.x > (canvas.rect.width - stateOffset.x) / 2) {
            localPos.x = (canvas.rect.width - stateOffset.x) / 2;
            side = Side.Right;
        } else if(localPos.x < -(canvas.rect.width - stateOffset.x) / 2) {
            localPos.x = -(canvas.rect.width - stateOffset.x) / 2;
            side = Side.Left;
        }
        if(localPos.y > (canvas.rect.height - stateOffset.x) / 2) {
            localPos.y = (canvas.rect.height - stateOffset.x) / 2;
            side = Side.Up;
        } else if(localPos.y < -(canvas.rect.height + stateOffset.x) / 2) {
            localPos.y = -(canvas.rect.height - stateOffset.x) / 2;
            side = Side.Down;
        }
        return side != Side.Inside;
    }
}
