# Quick Reference Card — Set C Exam

**Print this page for exam reference!**

---

## 📊 Key Metrics (Expected Results)

### Overall Statistics
| Metric | Value |
|--------|-------|
| Total Assessments (Clean) | 12 |
| Overall Pass Rate | 66.67% |
| Overall Avg Score | 64.17 |
| Passing Assessments | 8 |
| Failing Assessments | 4 |

---

### By Department
| Department | Avg Score | Pass Rate | Count |
|------------|-----------|-----------|-------|
| Business | 68.33 | 83.33% | 6 |
| Technology | 59.83 | 50.00% | 6 |

---

### By Course
| Course | Avg Score | Pass Rate | Status |
|--------|-----------|-----------|--------|
| Excel (C1) | 80.67 | 100.00% | ✓ Excellent |
| PowerBI (C2) | 53.33 | 66.67% | ⚠ Average |
| SQL (C3) | 62.67 | 66.67% | ⚠ Average |
| Python (C4) | 52.00 | **33.33%** | 🚨 **Needs Support** |

---

### By Batch
| Batch | Avg Score | Pass Rate | Count |
|-------|-----------|-----------|-------|
| Morning | 65.25 | 66.67% | 3 |
| Evening | 64.33 | 66.67% | 3 |
| Weekend | 67.33 | 66.67% | 3 |

---

### By Month
| Month | Avg Score | Trend |
|-------|-----------|-------|
| Jan | 55.00 | ↑ Low baseline |
| Feb | 62.75 | ↑ Improving |
| Mar | 66.75 | ↑ Best month |

---

## 🔑 Key Data Rules

| Rule | Value |
|------|-------|
| Raw assessments rows | 13 |
| Clean assessments rows | 12 |
| Courses rows | 4 |
| Duplicate assessment_id | 12 (appears twice, Jan–Mar, C4, Weekend, 42, 65) |
| Pass threshold | score >= 50 |
| Pass rate = | (passing count ÷ total count) × 100% |
| Month order | Jan → Feb → Mar (not alphabetical) |
| Lookup key | course_id (1:many to assessments) |

---

## 📁 File Locations & Status

| File | Rows | Status |
|------|------|--------|
| `data/raw/assessments.csv` | 13 | ✓ Ready |
| `data/raw/courses.csv` | 4 | ✓ Ready |
| `outputs/clean_data.csv` | 12 | ✓ Generated |
| `outputs/python_summary.csv` | 2 | ✓ Generated |
| `outputs/python_chart.png` | — | ✓ Generated |
| `python/analysis.py` | — | ✓ Ready |
| `sql/setup.sql` | — | ✓ Ready |
| `sql/queries.sql` | — | ✓ Ready |
| `excel/analysis.xlsx` | — | 📝 To create |
| `powerbi/dashboard.pbix` | — | 📝 To create |

---

## 📈 SQL Query Expected Outputs

### S2a: Avg Score by Department
```
department,avg_score
Technology,59.83
Business,68.33
```

### S2b: Underperforming Courses (< 60)
```
course_id,course,department,avg_score,assessment_count
C4,Python,Technology,52.00,3
C2,PowerBI,Business,53.33,3
```

### S2c: Top Two Batches
```
batch,avg_score,assessment_count
Weekend,67.33,3
Morning,65.25,3
```

---

## 💡 Excel Formulas Reference

### XLOOKUP (Department Lookup)
```excel
=XLOOKUP(C2, Lookup!$A$2:$A$5, Lookup!$C$2:$C$5, "")
```
or INDEX/MATCH:
```excel
=IFERROR(INDEX(Lookup!$C$2:$C$5, MATCH(C2, Lookup!$A$2:$A$5, 0)), "")
```

### IF (Pass Flag)
```excel
=IF(E2>=50, 1, 0)
```

### COUNTIFS (Batch Summary)
```excel
=COUNTIFS(Clean!D$2:D$12, "Morning", Clean!H$2:H$12, 1)
```

---

## 📊 Power BI DAX Measures

### Assessment Count
```dax
Assessment Count = COUNTROWS(assessments)
```
**Expected: 12**

### Average Score
```dax
Avg Score = AVERAGE(assessments[score])
```
**Expected: 64.17**

### Pass Rate
```dax
Pass Rate = DIVIDE(
    COUNTROWS(FILTER(assessments, assessments[score] >= 50)),
    COUNTROWS(assessments),
    0
)
```
**Expected: 0.6667 (displays as 66.67%)**

---

## 🐍 Python Key Lines

### Remove Duplicate
```python
assessments_clean = assessments.drop_duplicates(keep='first')
```

### Merge Tables
```python
merged = assessments_clean.merge(courses, on='course_id', how='left')
```

### Calculate Pass Flag
```python
merged['pass_flag'] = (merged['score'] >= 50).astype(int)
```

### Department Summary
```python
dept_summary = merged.groupby('department').agg(
    total_assessments=('assessment_id', 'count'),
    passing_count=('pass_flag', 'sum')
)
```

---

## 🔄 Cross-Tool Reconciliation

**Aggregate to Verify:** Overall Pass Rate = **66.67%**

| Tool | Method | Result |
|------|--------|--------|
| Python | `merged['pass_flag'].sum() / len(merged)` | 66.67% ✓ |
| SQL | `COUNT(score>=50) / COUNT(*)` | 66.67% ✓ |
| Excel | `COUNTIFS(pass_flag=1) / COUNTA(*)` | 66.67% ✓ |
| Power BI | `Pass Rate` DAX measure | 66.67% ✓ |

---

## ⏱ Time Checkpoints

| Time | Milestone | Action |
|------|-----------|--------|
| 0:00 | START | Data setup, verify raw files |
| 0:15 | ✓ Phase 1 | Excel analysis complete |
| 0:45 | ✓ Phase 2 | SQL setup + queries complete |
| 1:15 | ✓ Phase 3 | Python analysis complete + outputs |
| 1:50 | ✓ Phase 4 | Power BI report + screenshot |
| 2:05 | ✓ Phase 5 | Video recorded & uploaded |
| 2:30 | ✓ Phase 6 | GitHub repo submitted |
| 3:00 | FINISH | Final checks |

---

## ✅ Pre-Submission Checklist (5 min before deadline)

**Excel:**
- [ ] 4 sheets: Raw (13 rows), Lookup (4 rows), Clean (12 rows + formulas), Summary (PivotTable + chart)
- [ ] XLOOKUP or INDEX/MATCH working
- [ ] pass_flag IF formula on all 12 rows
- [ ] COUNTIFS batch summary results: Morning 2, Evening 2, Weekend 2
- [ ] PivotTable avg score by dept & month with Jan–Feb–Mar order
- [ ] Column chart with title and labels

**SQL:**
- [ ] setup.sql creates tables with correct foreign key
- [ ] setup.sql inserts 4 courses + 12 assessments (no duplicate)
- [ ] queries.sql runs without errors in sequence
- [ ] 3 output CSVs in `outputs/sql/`: s2a, s2b, s2c

**Python:**
- [ ] analysis.py runs from repo root: `python python/analysis.py`
- [ ] Merge assertion passes (12 rows, zero unmatched)
- [ ] 3 files exported: clean_data.csv, python_summary.csv, python_chart.png

**Power BI:**
- [ ] 12 rows in assessments query (duplicate removed)
- [ ] 4 rows in courses query
- [ ] 3 DAX measures (Assessment Count, Avg Score, Pass Rate)
- [ ] 3 KPI cards showing 12 / 64.17 / 66.67%
- [ ] Department bar chart + monthly trend chart
- [ ] Batch slicer working (filter + clear works)
- [ ] Report screenshot saved

**README.md:**
- [ ] Student ID and Set C in header
- [ ] Business question stated
- [ ] Data dictionary complete
- [ ] Cleaning steps documented (duplicate removal)
- [ ] Setup & run instructions for all 4 modules
- [ ] Two numeric findings (Python 33.33%, dept summary)
- [ ] One recommendation (tutoring for Python)
- [ ] Cross-tool reconciliation (66.67% ✓ all match)
- [ ] Video URL (tested in private browser)
- [ ] Video duration (5–10 min)
- [ ] Authorship declaration present

**GitHub:**
- [ ] Repository is PUBLIC
- [ ] All 4 editable files + outputs present
- [ ] .gitignore excludes __pycache__, *.db, venv
- [ ] requirements.txt lists pandas, matplotlib
- [ ] Meaningful commit messages
- [ ] Final commit hash recorded

**Video:**
- [ ] Face visible throughout (webcam + screen)
- [ ] Audio clear, screen readable
- [ ] 5–10 minutes duration
- [ ] URL accessible in incognito browser
- [ ] No sign-in required

---

## 🎯 Two Numeric Findings

**Finding 1:** Python course (C4) needs most academic support with 33.33% pass rate (1 out of 3 assessments passing).

**Finding 2:** Business department outperforms Technology (83.33% vs 50.00% pass rate), with consistent upward trend across all months (Jan: 55.00 → Mar: 66.75 avg score).

---

## 💬 One Recommendation

Implement targeted academic support for Python course: (1) identify struggling topics via Jan/Mar weak performance (scores 38, 42), (2) establish peer tutoring pairing low performers with Feb success case (score 68), (3) schedule module review sessions before month-end assessments, (4) monitor Technology department batch attendance (Weekend batch 62–65% attendance lower than average 87%).

---

## ⚠️ One Limitation

Dataset covers only 3 months (Jan–Mar) and 4 courses with small sample sizes (3 assessments per course). Recommend extending analysis to full academic year and including student demographic data to identify cohort-specific support needs and measure intervention effectiveness.

---

## 🔗 Video Outline (5–10 min)

1. **Intro (30s)** — Name, ID, Set C, business question
2. **Dataset (60s)** — Structure, duplicate, 12 unique records
3. **Excel (90s)** — XLOOKUP, IF, PivotTable
4. **SQL (60s)** — S2a query, JOIN logic, results
5. **Python (90s)** — Merge, pass_flag, chart
6. **Power BI (90s)** — DAX, slicer demo, KPI values
7. **Conclusion (60s)** — Findings, recommendation, limitation, repo structure

---

## 📞 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Python duplicate not removed | Use `drop_duplicates(keep='first')` |
| SQL foreign key error | Check course_id values match exactly (C1–C4) |
| Month not ordered correctly | Use categorical type or manual sort in PivotTable/chart |
| Power BI slicer not filtering | Ensure relationship is active and single-direction |
| Excel XLOOKUP not found | Use INDEX/MATCH alternative (older Excel versions) |
| Video link inaccessible | Test in incognito window; ensure YouTube "Unlisted" or Drive "Anyone with link" |
| GitHub repo not public | Settings → Visibility → Public, verify you can view repo while signed out |

---

**Good luck! 🎓**

*Save this page as reference during exam.*

---

*"Quality is our Motto" — Red & White Skill Education*
