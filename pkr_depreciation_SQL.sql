# Full PKR depreciation timeline
# Q1. How has the rupee weakened since 2000?

SELECT 
    year,
    pkr_per_usd,
    yoy_depreciation_pct,
    inflation_cpi_pct,
    episode,
    key_events
FROM
    economic_indicators
ORDER BY year;

# Episode comparison which crisis was worst?
# Q2. which depreciation episode caused the most damage?
# Note: ranked by total % depreciation over full episode duration.
# Dashboard bar chart shows avg annual depreciation, which tells a different story.

SELECT 
    episode,
    start_year,
    end_year,
    pkr_start,
    pkr_end,
    total_depreciation_pct,
    ROUND(avg_depreciation, 2) AS avg_annual_depreciation_pct,
    ROUND(avg_cpi, 2) AS avg_inflation_pct,
    ROUND(avg_pass_through, 4) AS avg_pass_through_cofficient,
    ROUND(avg_forex_reserves, 2) as avg_forex_reserves_usd_bn,
    ROUND(avg_policy_rate, 2) AS avg_policy_rate_pct
FROM
    depreciation_episodes
ORDER BY total_depreciation_pct DESC; 

# Pass through ranking worst years for consumers
# Q3. In which years did depreciation hurt consumers most?

SELECT
    year,
    pkr_per_usd,
    yoy_depreciation_pct,
    inflation_cpi_pct,
    pass_through_coefficient,
    episode,
    RANK() OVER (ORDER BY pass_through_coefficient DESC) AS pass_through_rank
FROM economic_indicators
WHERE pass_through_coefficient IS NOT NULL
  AND yoy_depreciation_pct > 2
ORDER BY pass_through_coefficient DESC;

# Forex reserves vs PKR did reserves protect the rupee?
# Q4. Is there a relationship between low reserves and PKR weakness?

SELECT
    year,
    pkr_per_usd,
    yoy_depreciation_pct,
    forex_reserves_usd_bn,
    policy_rate_pct,
    imf_program_active,
    CASE
        WHEN forex_reserves_usd_bn < 10 THEN 'Critical (< $10B)'
        WHEN forex_reserves_usd_bn < 15 THEN 'Low ($10B-$15B)'
        ELSE 'Adequate (> $15B)'
    END AS reserves_status
FROM economic_indicators
ORDER BY year;

# IMF program impact did bailouts stabilize PKR?
# Q5. Did IMF programs actually slow depreciation?

SELECT
    imf_program_active,
    COUNT(*)                              AS years_count,
    ROUND(AVG(yoy_depreciation_pct), 2)  AS avg_depreciation_pct,
    ROUND(AVG(inflation_cpi_pct), 2)     AS avg_inflation_pct,
    ROUND(AVG(forex_reserves_usd_bn), 2) AS avg_forex_reserves,
    ROUND(AVG(policy_rate_pct), 2)       AS avg_policy_rate
FROM economic_indicators
WHERE yoy_depreciation_pct IS NOT NULL
GROUP BY imf_program_active;
# Note: reverse causality likely. Pakistan enters IMF programs during crises, so higher depreciation during IMF years reflects entry conditions, not program failure.

# Decade wise economic deterioration
# Q6. Business question: Has Pakistan's macro situation worsened each decade?

SELECT
    decade,
    ROUND(AVG(pkr_per_usd), 2)            AS avg_pkr_per_usd,
    ROUND(AVG(yoy_depreciation_pct), 2)   AS avg_annual_depreciation_pct,
    ROUND(AVG(inflation_cpi_pct), 2)      AS avg_inflation_pct,
    ROUND(AVG(forex_reserves_usd_bn), 2)  AS avg_forex_reserves,
    ROUND(AVG(gdp_growth_pct), 2)         AS avg_gdp_growth_pct,
    ROUND(AVG(public_debt_gdp_pct), 2)    AS avg_debt_gdp_pct,
    COUNT(*)                              AS years_in_decade
FROM economic_indicators
WHERE yoy_depreciation_pct IS NOT NULL
GROUP BY decade
ORDER BY decade;

# Remittances as a stabilizer did inflows cushion PKR?
# Q7. Do higher remittances correlate with slower depreciation?

SELECT
    year,
    pkr_per_usd,
    yoy_depreciation_pct,
    remittances_usd_bn,
    remittances_gdp_pct,
    current_account_usd_bn,
    CASE
        WHEN remittances_gdp_pct > 7 THEN 'High Remittances'
        WHEN remittances_gdp_pct > 4 THEN 'Moderate Remittances'
        ELSE 'Low Remittances'
    END AS remittance_level
FROM economic_indicators
ORDER BY year;
 









 


