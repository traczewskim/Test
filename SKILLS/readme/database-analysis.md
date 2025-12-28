# Database Query Analysis Skill

Enables Claude to connect to MySQL/PostgreSQL databases, execute queries, and analyze data to provide insights.

## Overview

This skill handles database connections, query execution, and result interpretation to help understand data patterns, relationships, and anomalies.

## Prerequisites

- Database credentials (host, username, password, database name)
- Network access to the database server
- Python with required database libraries (`pymysql`, `psycopg2-binary`, or `mysql-connector-python`)

## Core Capabilities

1. Execute SELECT queries to explore table data
2. Analyze table schemas and relationships
3. Identify data patterns, distributions, and anomalies
4. Generate summary statistics and aggregations
5. Suggest optimization opportunities based on data structure

## Usage Pattern

### Initial Setup

When starting a database analysis session, provide:
- **Host**: Database server address
- **Username**: Database user
- **Password**: Database password
- **Database**: Target database name
- **Port** (optional): Default 3306 for MySQL, 5432 for PostgreSQL
- **Type**: `mysql` or `postgresql`

### Query Request Format

Specify your analysis needs:
- **Table**: The table to query
- **Fields** (optional): Specific columns to examine
- **Conditions** (optional): WHERE clause criteria
- **Analysis Type**: What you want to understand (distribution, patterns, relationships, etc.)

## Example Workflows

### Basic Table Exploration
```
Table: users
Fields: registration_date, status
Analysis: Show user registration trends over time
```

### Data Quality Check
```
Table: orders
Fields: total_amount, created_at, status
Analysis: Find anomalies in order amounts and identify incomplete orders
```

## Installation

Copy the skill directory to your Claude Code skills directory:

```bash
# Project-level (shared with team via git)
cp -r SKILLS/skills/database-analysis /path/to/your/project/.claude/skills/

# Personal (available in all projects)
mkdir -p ~/.claude/skills
cp -r SKILLS/skills/database-analysis ~/.claude/skills/
```

## Full Documentation

See [SKILLS/skills/database-analysis/SKILL.md](../skills/database-analysis/SKILL.md) for complete documentation.
