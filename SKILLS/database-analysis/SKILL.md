# Database Query Analysis Skill

## Overview
This skill enables Claude to connect to MySQL/PostgreSQL databases, execute queries, and analyze data to provide insights. The skill handles database connections, query execution, and result interpretation to help understand data patterns, relationships, and anomalies.

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

### Schema Analysis
```
Table: transactions
Analysis: Describe table structure and suggest useful queries
```

## Implementation Approach

1. **Connect Safely**: Use parameterized queries to prevent SQL injection
2. **Limit Results**: Default to LIMIT 1000 for large datasets
3. **Sample First**: For large tables, analyze samples before full queries
4. **Explain Results**: Provide context and interpretation with query results
5. **Suggest Next Steps**: Recommend follow-up queries based on findings

## Security Considerations
- Never log or expose database credentials in output
- Use read-only connections when possible
- Validate all user inputs before query construction
- Limit query complexity to prevent performance issues
- Handle connection errors gracefully

## Sample Python Implementation Template

```python
import pymysql
import pandas as pd
from typing import Dict, List, Optional

def connect_database(config: Dict[str, str]):
    """Establish database connection"""
    if config['type'] == 'mysql':
        return pymysql.connect(
            host=config['host'],
            user=config['username'],
            password=config['password'],
            database=config['database'],
            port=config.get('port', 3306),
            cursorclass=pymysql.cursors.DictCursor
        )
    # Add PostgreSQL support similarly

def analyze_table(connection, table: str, fields: Optional[List[str]] = None):
    """Query and analyze table data"""
    with connection.cursor() as cursor:
        # Get table schema
        cursor.execute(f"DESCRIBE {table}")
        schema = cursor.fetchall()

        # Build and execute query
        field_list = ', '.join(fields) if fields else '*'
        query = f"SELECT {field_list} FROM {table} LIMIT 1000"
        cursor.execute(query)
        results = cursor.fetchall()

        return schema, results

def provide_insights(schema, data):
    """Analyze and interpret query results"""
    # Convert to DataFrame for analysis
    df = pd.DataFrame(data)

    insights = {
        'row_count': len(df),
        'columns': list(df.columns),
        'null_counts': df.isnull().sum().to_dict(),
        'data_types': df.dtypes.to_dict()
    }

    return insights
```

## Best Practices

### Query Construction
- Always use LIMIT clauses for exploratory queries
- Prefer COUNT(*) for size estimation before full queries
- Use EXPLAIN to understand query performance
- Index-aware query design for large tables

### Analysis Guidelines
- Start with schema understanding
- Check data quality (nulls, duplicates, outliers)
- Look for patterns in timestamps and categorical fields
- Identify relationships through foreign keys
- Suggest indexes based on query patterns

### Response Format
1. **Query Executed**: Show the SQL that was run
2. **Results Summary**: Row count, columns returned
3. **Key Findings**: Patterns, anomalies, insights
4. **Recommendations**: Next queries or actions
5. **Data Preview**: Sample rows (formatted as table)

## Error Handling
- Connection failures: Verify credentials and network access
- Permission errors: Confirm user has SELECT privileges
- Syntax errors: Validate table and column names
- Timeout issues: Reduce query scope or add indexes

## Advanced Features

### Multi-Table Analysis
Join related tables to understand relationships:
```sql
SELECT o.*, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.id
LIMIT 100
```

### Aggregation Queries
Generate statistical summaries:
```sql
SELECT
    DATE(created_at) as date,
    COUNT(*) as orders,
    AVG(total) as avg_order,
    SUM(total) as revenue
FROM orders
GROUP BY DATE(created_at)
ORDER BY date DESC
LIMIT 30
```

### Performance Monitoring
Identify slow queries and suggest optimizations based on execution plans.

## Limitations
- Read-only operations (no INSERT/UPDATE/DELETE)
- Query timeout at 30 seconds
- Result set limited to 10,000 rows
- No stored procedure execution
- No database modification operations

---

**Version**: 1.0
**Last Updated**: December 2025
**Maintained By**: Claude Database Analysis Skill
