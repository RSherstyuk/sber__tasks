-- Считаем что user c двуммя ролями обладает активнотью только по одной, так как это один и тот же user
-- Используем LEFT JOIN для отображения юзеров с нулевыми активностями за последний месяц
SELECT 
    u.username,
    COALESCE(STRING_AGG(DISTINCT ur.role, ', '), 'нет роли') AS roles,
    COUNT(DISTINCT ua.id) AS activity_count
FROM 
    users u
LEFT JOIN 
    user_roles ur ON u.id = ur.user_id
LEFT JOIN 
    user_activity ua ON u.id = ua.user_id 
    AND ua.activity_date >= '2024-10-01'::date 
    AND ua.activity_date < '2024-11-01'::date
GROUP BY 
    u.id, 
    u.username
ORDER BY 
    activity_count DESC;
