using DG.Tweening;
using UnityEngine;

public class DoTweenAnimation : MonoBehaviour {
    [SerializeField] private bool animRotation = false, animHeight = false, animScale=false;
    [SerializeField] private float animationHeight, scaleFactor=2f, animationDuration;
    
    private void OnEnable() {
        transform.DOKill();
        if(animRotation) {
        transform.DOLocalRotate(new Vector3(0, 360, 0), animationDuration, RotateMode.FastBeyond360)
            .SetLoops(-1, LoopType.Incremental).SetEase(Ease.Linear);
        }
        if(animHeight) {
        transform.DOLocalMoveY(transform.localPosition.y + animationHeight, animationDuration / 3)
            .SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
        }
        if(animScale) {
            transform.DOScale(scaleFactor*transform.localScale.x, animationDuration)
                .SetLoops(-1, LoopType.Yoyo).SetEase(Ease.OutQuad);
        }
    }

    private void OnDisable() {
        transform.DOKill();
    }

    private void OnDestroy() {
        transform.DOKill();
    }
}
