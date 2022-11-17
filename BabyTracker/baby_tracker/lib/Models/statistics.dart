final String statTable = 'stats';

class StatFields {
    static final String childId = 'childId';
    static final String avgWeekSleep = 'avgWeekSleep'; // amount slept in a day
    static final String avgSleepStart = 'avgSleepStart'; // typical time sleep starts
    static final String avgAmountSleep = 'avgAmountSleep'; // average time each sleep is for
    static final String avgAmountEaten = 'avgAmountEaten';
    static final String poopCountByWeek = 'poopCount';
    static final String peeCountByWeek = 'peeCount';
    static final String totDiaperChange = 'totDiaperChange';
    static final String calculatedDate = 'calculatedDate'; // this is the date this info was recalculated
}

class Stats {
    final int childId;
    final double avgWeekSleep;
    final DateTime avgSleepStart;
    final double avgAmountSleep;
    final double avgAmountEaten;
    final int poopCountByWeek;
    final int peeCountByWeek;
    final int totDiaperChange;
    final DateTime calculatedDate;
 
    const Stats({
        required this.childId,
        required this.avgWeekSleep,
        required this.avgSleepStart,
        required this.avgAmountSleep,
        required this.avgAmountEaten,
        required this.poopCountByWeek,
        required this.peeCountByWeek,
        required this.totDiaperChange,
        required this.calculatedDate
    });
}
