# Changelog

All notable changes to this add-on will be documented in this file.
## 0.88.4
**BUMPED:** bumped to tududi v0.88.4


## 0.88.2
**BUMPED:** bumped to tududi v0.88.2

**TUDUDI CHANGELOG:**
    Fix sql issue by @chrisvel in
    Fix sql issue chrisvel/tududi#723
    Cleanup statuses by @chrisvel in
    Cleanup statuses chrisvel/tududi#724
    Fix task long titles by @chrisvel in
    Fix task long titles chrisvel/tududi#726
    Fix recur instance done by @chrisvel in
    Fix recur instance done chrisvel/tududi#727

## 0.88.0
**BUMPED:** bumped to tududi V0.88.0

**TUDUDI CHANGELOG:**
    Feat refactor task details by @chrisvel in #660
    Fix healthcheck command to use 127.0.0.1 instead of localhost by @JustAmply in #669
    Fix healthcheck command to use array syntax by @JustAmply in #673
    Feat add inbox flow by @chrisvel in #676
    Fix sequelize issue by @chrisvel in #678
    Fix bug 677 by @chrisvel in #679
    Fix locale issues by @chrisvel in #680
    Fix items to tasks by @chrisvel in #681
    Fix bug 661 by @chrisvel in #682
    Improve Productivity Assistant title pluralization and wording by @chrisvel in #683
    Fix bug 571 by @chrisvel in #684
    Reorder elements by @chrisvel in #687
    changed ignore condition for telegram processing by @r-sargento in #672
    Fix bug 675 by @chrisvel in #689
    Add universal filter to tag details page by @chrisvel in #690
    Fix readAt counter for notifications by @chrisvel in #691
    Feat telegram notifications by @chrisvel in #692
    Fix profile settings mobile layout by @chrisvel in #694
    Fix api keys issue by @chrisvel in #706

## 0.87
**BUMPED:** bumped to tududi V0.87
**ChANGES IN STRUCTURE**: from now on the main addon will folow the release version of the upstream github

**TUDUDI CHANGELOG**:

    Feat refactor tasks pt1 by @chrisvel in #536
    Fix subtasks copy by @chrisvel in #546
    Fix today recurring missing by @chrisvel in #548
    Fix static base path by @chrisvel in #549
    Fix todays page test by @chrisvel in #550
    Use commonJS version of nanoid by @chrisvel in #551
    Fix today task name change by @chrisvel in #552
    Fix markdown by @chrisvel in #553
    Add migration to fix subtasκ  ordering by @chrisvel in #554
    Fix debounce task creation by @chrisvel in #555
    Fix cyrillic search by @chrisvel in #556
    Fix smart view pagination by @chrisvel in #557
    Wrap long subtask text by @chrisvel in #558
    Fix completed in upcoming filter by @chrisvel in #559
    Prevent duplicate generation by @chrisvel in #560
    Remove dot from upcoming tasks by @chrisvel in #561
    Set priority to low when creating task from inbox by @chrisvel in #562
    Add blue to low priority tasks by @chrisvel in #563
    Fix recurrence green by @chrisvel in #564
    Revert state of option selections by @chrisvel in #565
    Fix consistency task list by @chrisvel in #566
    Fix notes refresh by @chrisvel in #572
    Fix logo background by @chrisvel in #575
    Exclude today's tasks from suggested by @chrisvel in #577
    Feat add recurring search by @chrisvel in #579
    Feat add profile photo by @chrisvel in #580
    Fix redesign recurring tasks by @chrisvel in #582
    Feat main content revamp by @chrisvel in #584
    Feat improve task details by @chrisvel in #585
    Fix tag hides task by @chrisvel in #586
    Tc refactor pt1 by @chrisvel in #589
    Scaffold smtp service by @chrisvel in #590
    Fix vulns by @chrisvel in #591
    Feat add defer until date by @chrisvel in #592
    Feat notifications by @chrisvel in #594
    Fix today pagination by @chrisvel in #596
    Decrease dockerfile size by @chrisvel in #597
    Show version in sidebar by @chrisvel in #598
    Move deps to devDeps by @chrisvel in #600
    Fix avatar missing by @chrisvel in #602
    Fix remove avatar by @chrisvel in #603
    Fix race condition by @chrisvel in #604
    Setup auto-save by @chrisvel in #605
    Refresh e2e tests by @chrisvel in #606
    Fix an issue with task not completing in TaskDetails view by @chrisvel in #620
    Fix asset paths by @chrisvel in #623
    Fix bug 619 by @chrisvel in #629
    Unhide menu on mobile by @chrisvel in #630
    Fix operator by @chrisvel in #631
    Fix sidebar active links highlight by @chrisvel in #632
    Remove obsolete dividers by @chrisvel in #633
    Fix bug 621 by @chrisvel in #634
    Keep visual consistency in priority colors by @chrisvel in #635
    Fix a tooltips issue by @chrisvel in #636
    Fix metrics button missing from mobile by @chrisvel in #637
    Fix bug 613 by @chrisvel in #638
    Add toaster when starting task by @chrisvel in #639
    Fix an issue with tasks appearing in today without a flag by @chrisvel in #640
    Fix flag issue by @chrisvel in #641
    Fix project recent completion style by @chrisvel in #642
    Fix bug 528 by @chrisvel in #643
    Feat add task by @chrisvel in #644
    Fix today summary by @chrisvel in #645
    Fix recurring structure by @chrisvel in #646
    Fix metrics styling by @chrisvel in #647
    Fix bug 578 by @chrisvel in #648
    Fix tasks not updating by @chrisvel in #649
    Fix bump issues by @chrisvel in #651


## 0.2.1
**BUMPED:** bumped tududi to v0.86.1

## 0.2.0
**BUMPED:** bumped tududi to v0.86

## 0.1.1
- **FIXED:** Resolved "exec /init: exec format error" by temporarily removing aarch64 support
- Multi-arch builds were causing architecture mismatches on AMD64 systems
- Only AMD64 builds are supported until multi-arch issue is resolved

## 0.1.0
- **RELEASED:** Minimal viable product release.

## 0.0.10

- **ADDED:** Translation logic to support localization 
- the EN lang file

## 0.0.9

- **ADDED:** added support for aarch64
- updated the readme
- updated package name

## 0.0.8

- **FIXED:** Re-enabled ingress with proper template literal path rewriting
- Added sed patterns to handle backtick template literals (`/api/` → `./api/`)
- Users can now use "Open Web UI" button - no manual configuration needed
- Works seamlessly with the Tududi integration for iframe embedding

## 0.0.7

- **FIXED:** Disabled Home Assistant ingress to resolve API request routing issues
- Tasks and inbox items now load correctly
- Access via direct port (3002) instead of ingress proxy path
- Added Sequelize migrations execution on startup

## 0.0.6

- Added database migration support
- Installed sequelize-cli globally in Docker image
- Migrations now run automatically on container startup
- Ensures all database schema updates from upstream Tududi are applied

## 0.0.5

- href tentative fix
- > confirmed, this did fix the login again, back to previous state where we encounter issues with the tasks retrieval and creation

## 0.0.4

- **FIXED:** Resolved startup error where addon couldn't write options.json
- Added `map` directive to config.yaml for persistent storage management
- Changed default database path from `/app/backend/db/production.sqlite3` to `/data/production.sqlite3`
- Changed default uploads path from `/app/backend/uploads` to `/data/uploads`
- Storage now persists across addon restarts and updates

## 0.0.3

- **IMPORTANT:** Changed default boot behavior from `auto` to `manual` to prevent HA crashes
- Add-on will no longer start automatically at boot by default
- Updated documentation to emphasize required configuration before first start
- This prevents crashes when add-on attempts to start without proper configuration

## 0.0.2

- pinned the v0.85.1 stable release of the tududi upstream package

## 0.0.1

- Initial release
