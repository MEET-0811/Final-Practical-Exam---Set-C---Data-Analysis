# Excel Task Guide - Set C 

**File:** `excel/analysis.xlsx` 

---

## 📋 Overview

Create a workbook with **four sheets**: Raw, Lookup, Clean, and Summary.

| Sheet | Purpose | Rows | Key Actions |
|-------|---------|------|-------------|
| **Raw** | Original data before deduplication | 13 | Paste assessments.csv unchanged |
| **Lookup** | Course reference data | 4 | Paste courses.csv |
| **Clean** | Deduplicated + enriched data | 12 | Remove duplicate, add XLOOKUP, add pass_flag |
| **Summary** | Aggregations + visualizations | — | PivotTable, formulas, chart |

---

## Task E1: Data Import & Cleaning 

### Step 1: Create "Raw" Sheet

1. **Rename Sheet1 to "Raw"**
2. **Paste assessments.csv data** (13 rows including headers):
   - A1: assessment_id | B1: month | C1: course_id | D1: batch | E1: score | F1: attendance_pct
   - Row 2–13: Data rows (including the duplicate row 12–13)

3. **Document row count:**
   - In cell H1, add label: "Row Count (Before Dedup)"
   - In cell H2, add formula: `=COUNTA(A2:A13)` → should display **13**

**Screenshot checkpoint:** Raw sheet with 13 rows ✓

---

### Step 2: Create "Lookup" Sheet

1. **Insert new sheet, rename to "Lookup"**
2. **Paste courses.csv data** (4 rows including headers):
   - A1: course_id | B1: course | C1: department
   - Rows 2–5: Data for C1, C2, C3, C4

**Screenshot checkpoint:** Lookup sheet with 4 rows ✓

---

### Step 3: Create "Clean" Sheet

1. **Insert new sheet, rename to "Clean"**
2. **Copy assessment data from Raw sheet** (13 rows, all columns A–F)
3. **Delete the exact duplicate row:**
   - Row 13 (assessment_id 12, Mar, C4, Weekend, 42, 65) is identical to row 12
   - Delete row 13
   - Now you have **12 rows** (headers + 11 data rows)

   > **Note:** Rows are now 1–12 (header + 11 unique assessments)

4. **Document deduplication:**
   - In cell H1: "Before Dedup"
   - In cell H2: `=13` (or reference Raw!H2)
   - In cell I1: "After Dedup"
   - In cell I2: `=COUNTA(A2:A12)` → displays **12**

5. **Set data types:**
   - Column A (assessment_id): Integer
   - Columns E–F (score, attendance_pct): Number (2 decimal places)
   - Column B (month): Text

**Screenshot checkpoint:** Clean sheet with 12 rows, before/after counts visible ✓

---

### Step 4: Add Department Column (XLOOKUP)

1. **In cell G1, add header:** "department"
2. **In cell G2, enter XLOOKUP formula:**
   ```excel
   =XLOOKUP(C2, Lookup!$A$2:$A$5, Lookup!$C$2:$C$5, "")
   ```
   - **C2:** course_id to look up
   - **Lookup!$A$2:$A$5:** course_id column in Lookup sheet
   - **Lookup!$C$2:$C$5:** department column in Lookup sheet
   - **"":** Return empty string if not found

3. **Copy formula down** to G12 (all 12 rows)

4. **Verify:** All rows should show either "Business" or "Technology"

   > **Alternative if XLOOKUP not available:** Use INDEX/MATCH:
   > ```excel
   > =IFERROR(INDEX(Lookup!$C$2:$C$5, MATCH(C2, Lookup!$A$2:$A$5, 0)), "")
   > ```

**Result:** Department column populated for all 12 rows ✓

---

## Task E2: Derived Field & Batch Summary 

### Step 1: Add pass_flag Column

1. **In cell H1, add header:** "pass_flag"
2. **In cell H2, enter IF formula:**
   ```excel
   =IF(E2>=50, 1, 0)
   ```
   - **E2:** score value
   - Returns 1 if score ≥ 50, else 0

3. **Copy formula down** to H12 (all 12 rows)

4. **Verify results:**
   - Rows with score ≥ 50 should show 1
   - Rows with score < 50 should show 0

**Expected results by row:**
| Row | Score | pass_flag |
|-----|-------|-----------|
| 2   | 72    | 1         |
| 3   | 45    | 0         |
| 4   | 65    | 1         |
| 5   | 38    | 0         |
| 6   | 80    | 1         |
| 7   | 55    | 1         |
| 8   | 48    | 0         |
| 9   | 68    | 1         |
| 10  | 90    | 1         |
| 11  | 60    | 1         |
| 12  | 75    | 1         |
| 13  | 42    | 0         |

**Checkpoint:** pass_flag column populated for all 12 rows ✓

---

### Step 2: Create Batch Summary (Summary Sheet)

1. **Go to Summary sheet** (create if not exists)
2. **Create a labeled table for passing assessments by batch:**

| Batch | Passing Count |
|-------|---------------|
| Morning | [FORMULA] |
| Evening | [FORMULA] |
| Weekend | [FORMULA] |

3. **Use COUNTIFS formula for each batch:**
   - **Morning (C3):** `=COUNTIFS(Clean!D$2:D$12, "Morning", Clean!H$2:H$12, 1)`
   - **Evening (C4):** `=COUNTIFS(Clean!D$2:D$12, "Evening", Clean!H$2:H$12, 1)`
   - **Weekend (C5):** `=COUNTIFS(Clean!D$2:D$12, "Weekend", Clean!H$2:H$12, 1)`

4. **Verify results:**

| Batch | Passing Count |
|-------|---------------|
| Morning | 2 |
| Evening | 2 |
| Weekend | 2 |

**Checkpoint:** Batch summary table with COUNTIFS formulas ✓

---

## Task E3: PivotTable & Chart (2 Marks)

### Step 1: Create PivotTable (Average Score by Department & Month)

1. **In Summary sheet, select a cell below the batch summary** (e.g., A7)
2. **Insert → PivotTable:**
   - Data range: `Clean!A1:H12`
   - Location: Summary sheet
3. **Configure PivotTable:**
   - **Rows:** department (Business, Technology)
   - **Columns:** month (Jan, Feb, Mar — ensure ordered correctly)
   - **Values:** AVERAGE of score
   - **Remove grand totals** if desired for cleaner look

4. **Result table (expected):**

| Department | Jan | Feb | Mar |
|------------|-----|-----|-----|
| Business | 60.67 | 60.00 | 70.00 |
| Technology | 47.33 | 63.50 | 63.50 |

5. **Ensure month order is Jan → Feb → Mar:**
   - If months appear in wrong order, manually adjust by dragging column headers in the PivotTable

**Checkpoint:** PivotTable created with correct aggregation ✓

---

### Step 2: Create Column Chart

1. **Select the PivotTable** (entire data range)
2. **Insert → Column Chart (Clustered)**
3. **Format the chart:**
   - **Title:** "Average Score by Department & Month (Set C)"
   - **X-axis label:** "Month"
   - **Y-axis label:** "Average Score"
   - **Legend:** Show (department labels)
   - **Data labels:** Optional but recommended

4. **Size and position:**
   - Place chart below PivotTable on the same sheet
   - Size: ~12 cm wide × 8 cm tall (or proportional to sheet)

5. **Verify:**
   - Blue bar (Business) typically higher than orange/red bar (Technology)
   - Trend should show upward trend from Jan → Mar

**Screenshot checkpoint:** Chart displays correctly with title, labels, legend ✓

---

## ⚠️ Critical Reminders (E1–E3)

- ✓ **Keep all formulas editable** — Examiner will inspect formulas
- ✓ **No screenshots in place of live data** — Submit .xlsx with working formulas
- ✓ **Maintain data types** — assessment_id = integer, score/attendance_pct = number
- ✓ **Month order in PivotTable:** Must be Jan → Feb → Mar (not alphabetical)
- ✓ **All 12 rows used** — No hidden rows or filtering
- ✓ **XLOOKUP available** — If using older Excel, use INDEX/MATCH alternative

---

## Formula Reference

### Lookup Formula (XLOOKUP)
```excel
=XLOOKUP(lookup_value, lookup_array, return_array, [if_not_found])
```

### Lookup Formula (INDEX/MATCH Alternative)
```excel
=IFERROR(INDEX(return_range, MATCH(lookup_value, lookup_range, 0)), "")
```

### Pass Flag Formula (IF)
```excel
=IF(condition, value_if_true, value_if_false)
=IF(E2>=50, 1, 0)
```

### Batch Summary Formula (COUNTIFS)
```excel
=COUNTIFS(range1, criteria1, range2, criteria2)
=COUNTIFS(Clean!D$2:D$12, "Morning", Clean!H$2:H$12, 1)
```

---

## Expected Output

**File:** `excel/analysis.xlsx`

**Sheet Structure:**
```
Raw       → 13 rows (unchanged, before dedup)
Lookup    → 4 rows (course metadata)
Clean     → 12 rows + columns (A–H): assessment_id, month, course_id, batch, score, attendance_pct, department, pass_flag
Summary   → Batch summary table + PivotTable + Column chart
```
---

## Submission Checklist

- [ ] File saved as `excel/analysis.xlsx`
- [ ] Raw sheet: 13 rows (original data unchanged)
- [ ] Lookup sheet: 4 rows (course data)
- [ ] Clean sheet: 12 rows (deduplicated) with before/after counts
- [ ] Clean sheet: department column with XLOOKUP formulas
- [ ] Clean sheet: pass_flag column with IF formulas
- [ ] Summary sheet: Batch summary table with COUNTIFS formulas
- [ ] Summary sheet: PivotTable (avg score by department & month, ordered Jan–Feb–Mar)
- [ ] Summary sheet: Column chart with title, axis labels, legend
- [ ] All formulas visible and editable (no screenshots)
- [ ] File opens without errors
- [ ] Compatible with Microsoft Excel 2019+ or Microsoft 365

---

**Ready to submit!** ✓
