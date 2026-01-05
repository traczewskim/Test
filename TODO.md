# TODO

- ~~update README.md~~
- ~~flag "/release" and "/new-command" as experimental. Both needs to be tested before using.~~

## Experimental Commands (Need Testing)

- `/release` - Create GitHub releases with automatic version detection
- `/new-command` - Interactive wizard for creating new commands/skills
- `/create-release` - Create release PR from release branch
- `/merge-release` - Merge approved release PR with safety checks

## Testing Checklist

### /create-release
- [ ] Interactive mode (no arguments)
- [ ] With version only: `/create-release v1.0.2`
- [ ] With target and version: `/create-release master v1.0.2`
- [ ] Version normalization (1.0.2 → v1.0.2)
- [ ] Ticket extraction from commits
- [ ] Release label added to PR
- [ ] Existing release branch handling
- [ ] New release branch creation

### /merge-release
- [ ] Interactive mode (list release PRs)
- [ ] With release branch: `/merge-release v1.0.2`
- [ ] Approval verification
- [ ] CI/CD checks validation
- [ ] Merge conflict detection
- [ ] Already merged PR handling
- [ ] Merge commit creation