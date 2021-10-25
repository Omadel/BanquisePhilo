using System;
using UnityEngine;

public class DayTransitionManager : MonoBehaviour
{
    public static DayTransitionManager instance;
    public Transform[] SpawnPos => spawnPos;

    [SerializeField] public string[] dayTexts = new string[0];
    [SerializeField] private GameObject bear, lear, objective, banquise;
    [SerializeField] private GameObject[] banquises = new GameObject[0];
    [SerializeField] private Transform[] learPos = new Transform[0];
    [SerializeField] private Transform[] objectivePos = new Transform[0];
    [SerializeField] private Transform[] spawnPos = new Transform[0];

    public int dayIndex = -1;

    public static event Action<string, string> InitDaytTransitionEvent;

    private void Awake()
    {
        instance = this;
    }

    private void Start()
    {
        InitDayTransition();
    }

    public void InitDayTransition()
    {
        if(dayIndex >= dayTexts.Length) { return; }

        string tempPreviousDayText;
        string tempCurrDayText;

        if (dayIndex == 0)
        {
            tempPreviousDayText = "";
            tempCurrDayText = dayTexts[0];
        }
        else if (dayIndex == dayTexts.Length)
        {
            tempPreviousDayText = dayTexts[dayTexts.Length];
            tempCurrDayText = "";
        }
        else
        {
            tempPreviousDayText = dayTexts[dayIndex - 1];
            tempCurrDayText = dayTexts[dayIndex];
        }

        InitDaytTransitionEvent?.Invoke(tempPreviousDayText, tempCurrDayText);

        dayIndex++;
    }

    public void SpawnDay()
    {
        if (banquise != null)
        {
            Destroy(banquise);
        }

        if(dayIndex != 4)
        {
            banquise = Instantiate(banquises[dayIndex], new Vector3(-50, 0, 0), Quaternion.identity);
            lear.transform.position = learPos[dayIndex].position;
            objective.transform.position = objectivePos[dayIndex].position;
            bear.transform.position = spawnPos[dayIndex].position;
        }
        else
        {
            Invoke("exe", 3.2f);
        }

        GameObject[] footSteps = GameObject.FindGameObjectsWithTag("Footstep");
        foreach (GameObject item in footSteps)
        {
            Destroy(item);
        }
    }

    private void exe()
    {
        GameController.instance.WinGame();
    }
}
