using UnityEngine;
using TMPro;

public class PressButtonDisplay : MonoBehaviour
{
    public static PressButtonDisplay instance;

    [SerializeField] private CanvasGroup pressButton;

    private void Awake()
    {
        instance = this;
    }

    private void Start()
    {
        pressButton.alpha = 0;
        pressButton.transform.localPosition = new Vector2(0f,-600f);
    }

    public void Enable(string newPressButtonText)
    {
        pressButton.GetComponent<TMP_Text>().text = $"Press E to {newPressButtonText} !";
        pressButton.LeanAlpha(1f, 0.5f);
        pressButton.transform.LeanMoveLocalY(-500f, 0.2f);
    }

    public void Disable()
    {
        pressButton.LeanAlpha(0f, 0.5f);
        pressButton.transform.LeanMoveLocalY(-600f, 0.2f);
    }
}
