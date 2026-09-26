# Power BI Task Guide - Set C (7 Marks)

**File:** `powerbi/dashboard.pbix`  
**Platform:** Power BI Desktop (Windows only)  
**Total Marks:** 7 (B1: 2 marks, B2: 3 marks, B3: 2 marks)

---

## 📋 Overview

Build a Power BI dashboard with:
1. **Power Query:** Clean data and establish relationships
2. **Data Model:** One-to-many relationship (courses → assessments)
3. **DAX Measures:** 3 explicit measures (Assessment Count, Avg Score, Pass Rate)
4. **Report Page:** KPIs, charts, batch slicer, filtered views

---

## Task B1: Power Query & Data Model (2 Marks)

### Step 1: Load Data Sources in Power Query

1. **Open Power BI Desktop**
2. **Home → Get Data → Text/CSV**
3. **Load both CSVs:**
   - First: `data/raw/assessments.csv`
   - Second: `data/raw/courses.csv`

4. **Power Query Editor for assessments query:**
   - Right-click on "assessments" query → Edit
   - **Set column types:**
     - assessment_id: Whole Number
     - month: Text
     - course_id: Text
     - batch: Text
     - score: Decimal Number
     - attendance_pct: Decimal Number

5. **Remove duplicate row in assessments:**
   - Select column "assessment_id"
   - Home → Remove Duplicates
   - Verify result: **12 rows** remain (from original 13)

6. **Close & Apply** both queries

**Checkpoint:** Assessments table has 12 rows, courses has 4 rows ✓

---

### Step 2: Create Data Model Relationship

1. **Model view** (left sidebar)
2. **Drag relationship:**
   - From: `courses[course_id]` (primary key)
   - To: `assessments[course_id]` (foreign key)
   - Cardinality: **One-to-Many** (1:*)

3. **Configure relationship:**
   - Cross filter direction: **Single** (courses filters assessments, not vice versa)
   - Active relationship: **Yes**

4. **Verify:**
   - 1 relationship line should appear between tables
   - Relationship should have "1" on courses side, "*" on assessments side

**Checkpoint:** One-to-many relationship established ✓

---

## Task B2: DAX Measures (3 Marks)

### Step 1: Create Measures Table

1. **Home → Enter Data (or Modeling → New Table)**
2. **Create a dummy Measures table** (or use "Measures" table):
   ```
   Name
   Assessment Count
   Avg Score
   Pass Rate
   ```
   > This is just a container; actual calculations go in DAX measures below

3. **Name this table "Measures"**

---

### Step 2: Create Measure 1: Assessment Count

1. **Select Measures table → New Measure**
2. **DAX formula:**
   ```dax
   Assessment Count = COUNTROWS(assessments)
   ```
3. **Format:**
   - Format: Number
   - No decimal places (0)

**Expected result:** 12

---

### Step 3: Create Measure 2: Avg Score

1. **New Measure**
2. **DAX formula:**
   ```dax
   Avg Score = AVERAGE(assessments[score])
   ```
3. **Format:**
   - Format: Decimal Number
   - 2 decimal places

**Expected result:** 64.17 (average of all 12 scores)

---

### Step 4: Create Measure 3: Pass Rate

1. **New Measure**
2. **DAX formula:**
   ```dax
   Pass Rate = DIVIDE(
       COUNTROWS(FILTER(assessments, assessments[score] >= 50)),
       COUNTROWS(assessments),
       0
   )
   ```
   - Numerator: Count of assessments with score ≥ 50
   - Denominator: Total count of assessments
   - 0: Return 0 if divide by zero

3. **Format:**
   - Format: Percentage
   - 2 decimal places
   - Note: This measure returns decimal (0.6667), formatting as % displays as 66.67%

**Expected result:** 0.6667 (displays as 66.67% on visual)

---

## Task B3: Report Page & Dashboard (2 Marks)

### Step 1: Design Report Layout

1. **Report view** (left sidebar)
2. **Select blank canvas area**
3. **Set report page size:**
   - File → Page Info → Set to 16:9 or 4:3

---

### Step 2: Add KPI Cards (3 cards)

**Card 1: Assessment Count**
1. **Insert → Card visual**
2. **Drag to left side** (top area)
3. **Add field:** Measures[Assessment Count]
4. **Format:**
   - Title: "Assessment Count"
   - Display units: No
   - **Expected value:** 12

**Card 2: Avg Score**
1. **Insert → Card visual**
2. **Position:** Center (top area)
3. **Add field:** Measures[Avg Score]
4. **Format:**
   - Title: "Avg Score"
   - **Expected value:** 64.17

**Card 3: Pass Rate**
1. **Insert → Card visual**
2. **Position:** Right side (top area)
3. **Add field:** Measures[Pass Rate]
4. **Format:**
   - Title: "Pass Rate"
   - **Expected value:** 66.67%

---

### Step 3: Add Bar Chart (Avg Score by Department)

1. **Insert → Bar Chart**
2. **Position:** Below KPI cards (left-center)
3. **Configure:**
   - Axis: courses[department]
   - Value: Measures[Avg Score]
   - Sort by: Measures[Avg Score] (descending)

4. **Format:**
   - Title: "Average Score by Department"
   - Legend: Show (right side)
   - Data labels: Show values

**Expected result:**
| Department | Avg Score |
|------------|-----------|
| Business | 68.33 |
| Technology | 59.83 |

---

### Step 4: Add Monthly Trend Chart

1. **Insert → Line Chart** (or Column Chart)
2. **Position:** Below KPI cards (right side)
3. **Configure:**
   - Axis: assessments[month]
   - Value: Measures[Avg Score]
   - **Critical:** Ensure month order is Jan → Feb → Mar

4. **Format:**
   - Title: "Monthly Average Score Trend"
   - Legend: Show

5. **Fix month order:**
   - Click on month field
   - Sort axis → Sort by column → Create custom sort order if needed
   - Preferred order: Jan (1) → Feb (2) → Mar (3)

**Expected trend:** Upward trend from Jan (55.00) → Feb (62.75) → Mar (66.75)

---

### Step 5: Add Batch Slicer

1. **Insert → Slicer visual**
2. **Position:** Top-right corner (above charts)
3. **Field:** assessments[batch]
4. **Options:**
   - Display as: Dropdown or List (dropdown saves space)
   - Multi-select: Enabled (Ctrl+Click for multiple values)

5. **Test slicer:**
   - Click "Morning" → All KPIs and charts should filter to morning batch only
   - Click "Clear" or toggle multi-select → Return to all batches (unfiltered)

**Expected behavior:**
- **No filter applied:** All 12 assessments, Pass Rate = 66.67%
- **Morning only:** 3 assessments (1, 3, 10), Pass Rate = 66.67%
- **Evening only:** 3 assessments (2, 5, 8), Pass Rate = 66.67%
- **Weekend only:** 3 assessments (4, 6, 9, 12), Pass Rate = 66.67%

---

### Step 6: Test Slicer with Live Values

1. **Initial state (no filter):**
   - Assessment Count: 12
   - Avg Score: 64.17
   - Pass Rate: 66.67%

2. **Filter: Morning batch**
   - Assessment Count: 3
   - Avg Score: 65.25
   - Pass Rate: 66.67%
   - Note card values before clearing

3. **Clear filter (return to unfiltered):**
   - Verify all values return to original

**Checkpoint:** Slicer working correctly ✓

---

### Step 7: Take Final Screenshot

1. **Unfilter all** (ensure dashboard shows all data, no filters applied)
2. **Export → Export to Image** (or Print Screen → Paste in Paint)
3. **Save as:** `outputs/powerbi_dashboard.png`
4. **File should show:**
   - 3 KPI cards (12, 64.17, 66.67%)
   - Department bar chart
   - Monthly trend chart (Jan → Feb → Mar)
   - Batch slicer (unfiltered state)

---

## Task: CSV Path Refresh Instructions

**For README.md:**

> **How to Refresh Data Sources After Cloning:**
> 
> 1. Open `powerbi/dashboard.pbix` in Power BI Desktop
> 2. Home tab → Transform Data (or Ctrl+Shift+M)
> 3. In Power Query Editor:
>    - Right-click on "assessments" query → Edit
>    - Select the file path and update to: `data/raw/assessments.csv`
>    - Right-click on "courses" query → Edit
>    - Update path to: `data/raw/courses.csv`
> 4. Home → Close & Apply (Ctrl+Shift+L)
> 5. Power BI will refresh data and rebuild the dashboard
> 6. Verify: Assessments table shows 12 rows, KPI cards display values
> 7. Save file (Ctrl+S)

---

## Expected Dashboard State

| Element | Type | Value / Description |
|---------|------|---------------------|
| Assessment Count | Card | 12 |
| Avg Score | Card | 64.17 |
| Pass Rate | Card | 66.67% |
| Dept Bar Chart | Chart | Business: 68.33, Technology: 59.83 |
| Monthly Trend | Chart | Jan: 55.00, Feb: 62.75, Mar: 66.75 |
| Batch Slicer | Dropdown | Morning, Evening, Weekend |

---

## Marks Breakdown

**B1 — Power Query & Data Model (2 marks)**
- Data types set correctly: 1 mark
- Duplicate row removed (12 rows remain): 1 mark

**B2 — DAX Measures (3 marks)**
- Assessment Count measure: 1 mark
- Avg Score measure: 1 mark
- Pass Rate measure (DIVIDE with filter): 1 mark

**B3 — Report Page & Screenshot (2 marks)**
- 3 KPI cards + 2 charts + batch slicer + readable layout: 1 mark
- Batch slicer demonstrated + findings documented in README: 1 mark

**Total: 7 marks**

---

## Submission Checklist

- [ ] File saved as `powerbi/dashboard.pbix`
- [ ] Assessments query: 12 rows (duplicate removed)
- [ ] Courses query: 4 rows
- [ ] Data types set (integers, decimals, text)
- [ ] One-to-many relationship: courses → assessments
- [ ] Relationship filtering: Single direction
- [ ] 3 DAX measures created (Assessment Count, Avg Score, Pass Rate)
- [ ] Report page contains:
  - [ ] 3 KPI cards (top area, showing 12 / 64.17 / 66.67%)
  - [ ] Bar chart (Avg Score by Department)
  - [ ] Monthly trend chart (Jan → Feb → Mar order)
  - [ ] Batch slicer (dropdown or list)
  - [ ] Clean, readable layout
- [ ] Batch slicer tested and working (filters all visuals)
- [ ] Screenshot saved: `outputs/powerbi_dashboard.png`
- [ ] CSV path refresh instructions in README.md
- [ ] File opens without errors
- [ ] Measures respond correctly to filters

---

**Ready to submit!** ✓
