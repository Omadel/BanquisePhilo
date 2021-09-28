using DG.Tweening;
using UnityEngine;

public class DoTween2DAnimation : MonoBehaviour {
    [SerializeField] private bool animRotation = false, animHeight = false, animScale=false;
    [SerializeField] private float animationHeight, scaleFactor=2f, animationDuration;

    Vector3? basePosition, baseRotation, baseScale;

    private void OnEnable() {
        ResetTransform();
        if(animRotation) {
        transform.DOLocalRotate(new Vector3(0, 0, 360), animationDuration, RotateMode.FastBeyond360)
            .SetLoops(-1, LoopType.Incremental).SetEase(Ease.Linear);
        }
        if(animHeight) {
        transform.DOLocalMoveY(animationHeight, animationDuration )
            .SetLoops(-1, LoopType.Yoyo).SetEase(Ease.OutQuad);
        }
        if(animScale) {
            transform.DOScale(scaleFactor*transform.localScale.x, animationDuration)
                .SetLoops(-1, LoopType.Yoyo).SetEase(Ease.OutQuad);
        }
    }

    private void OnDisable() {
        ResetTransform();
    }

    private void ResetTransform() {
        basePosition ??= transform.localPosition;
        baseRotation ??= transform.localEulerAngles;
        baseScale ??= transform.localScale;
        transform.DOKill();
        transform.localPosition = basePosition.Value;
        transform.localEulerAngles = baseRotation.Value;
        transform.localScale = baseScale.Value;
    }

    private void OnDestroy() {
        ResetTransform();
    }
}
