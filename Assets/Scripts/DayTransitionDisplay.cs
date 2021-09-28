using UnityEngine;
using TMPro;

public class DayTransitionDisplay : MonoBehaviour
{
    [SerializeField] private CanvasGroup background;
    [SerializeField] private CanvasGroup currDayText;
    [SerializeField] private CanvasGroup previousDayText;
    [SerializeField] private CanvasGroup roleDay;

    private bool canInitDayTransition = true;

    private void Awake()
    {
        //background.alpha = 0;
        //currDayText.alpha = 0;
        //previousDayText.alpha = 0;
        //roleDay.alpha = 0;
        roleDay.transform.localPosition = new Vector3(0, -100);
    }
    private void Start()
    {
        DayTransitionManager.InitDaytTransitionEvent += InitDayTransition;
    }

    public void InitDayTransition(string newPreviousDayText, string newCurrDayText)
    {
        if (!canInitDayTransition) { return; }

        SetDayText(newPreviousDayText, newCurrDayText);

        background.LeanAlpha(1, 2f).setOnComplete(() => {
            if(DayTransitionManager.instance.dayIndex != 1)
            {
                TimeOfDayHandeler.Instance.Swap();
            }
            TimeOfDayHandeler.Instance.ReseTimeOfDay();
            });


        previousDayText.LeanAlpha(1, 1f).delay = 2f;
        roleDay.LeanAlpha(1, 3f).delay = 2f;

        previousDayText.transform.LeanMoveLocalX(-1500, 2f).setEaseInOutBack().delay = 3f;
        previousDayText.LeanAlpha(0, 2f).delay = 3f;
        roleDay.transform.LeanMoveLocalX(-3000,2f).setEaseInBack().setEaseInOutBack().delay = 3f;

        currDayText.transform.LeanMoveLocalX(0, 2f).setEaseInOutBack().delay = 3f;
        currDayText.LeanAlpha(1, 3f).delay = 3f;

        currDayText.LeanAlpha(0, 2f).delay = 5.5f;
        roleDay.LeanAlpha(0, 2f).delay = 5.5f;
        background.LeanAlpha(0, 2f).setOnComplete(ResetDayTransition).delay = 6.5f;
    }

    private void ResetDayTransition()
    {
        background.alpha = 0;
        currDayText.alpha = 0;
        previousDayText.alpha = 0;
        roleDay.alpha = 0;

        previousDayText.transform.localPosition = new Vector2(0, 0);
        currDayText.transform.localPosition = new Vector2(1500, 0);
        roleDay.transform.localPosition = new Vector3(0, -100);

        GameController.instance.ChangeGameState(GameController.GameSate.GoEat);
    }

    public void SetDayText(string newPreviousDayText, string newCurrentDayText)
    {
        previousDayText.GetComponent<TMP_Text>().text = newPreviousDayText;
        currDayText.GetComponent<TMP_Text>().text = newCurrentDayText;
    }
}
