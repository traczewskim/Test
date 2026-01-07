# TODO

- ~~update README.md~~
- ~~flag "/release" and "/new-command" as experimental. Both needs to be tested before using.~~
- ~~test experimental commands and mark as stable~~

## Completed Testing (January 2026)

All experimental commands have been tested and verified:

- ✅ `/release` - Create GitHub releases with automatic version detection
- ✅ `/new-command` - Interactive wizard for creating new commands/skills
- ✅ `/create-release` - Create release PR from release branch
- ✅ `/merge-release` - Merge approved release PR with safety checks

### Testing Results

#### /create-release ✅
- [x] With target and version: `/create-release master v0.1.0-test`
- [x] Version normalization (adds `v` prefix if missing)
- [x] Ticket extraction from commits (TEST-001, TEST-002)
- [x] PR creation with structured description
- [x] Release branch handling

#### /merge-release ✅
- [x] PR lookup by release branch
- [x] Status checks (mergeable, reviewDecision)
- [x] CI/CD checks validation
- [x] Merge commit creation

#### /release ✅
- [x] Release notes generation from commits
- [x] GitHub release creation with tag
- [x] Version and branch validation

#### new-command skill ✅
- [x] Skill structure validated
- [x] YAML frontmatter correct
- [x] Documentation complete
- [x] 6-phase workflow documented