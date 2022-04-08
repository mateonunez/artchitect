<?php

namespace App\Lib;

class ControllerUtils
{
    /**
     * Parse query parameters relationships
     *
     * @param array $query
     *
     * @return array
     */
    public static function getRequestRelationships(array $query): array
    {
        try {
            if (!isset($query['relationships'])) {
                return [];
            }

            $relationships = self::getExplodedParams($query['relationships']);

            return $relationships;
        } catch (\Exception $ex) {
            throw $ex;
        }
    }

    /**
     * Append filter to query
     *
     * @param string|null $filters
     * @param string $filter
     *
     * @return string
     */
    public static function appendFilter($filters, string $filter): string
    {
        try {
            if (empty($filters)) {
                return "[" . $filter . "]";
            }

            $filters = substr($filters, 0, -1);
            $filters .= "," . $filter . "]";

            return $filters;
        } catch (\Exception $ex) {
            throw $ex;
        }
    }

    /**
     * Parse query parameters filters
     *
     * @param array $query
     *
     * @return array
     */
    public static function getRequestFilters(array $query): array
    {
        try {
            if (!isset($query['filters'])) {
                return [];
            }

            $filters = self::getExplodedParams($query['filters']);
            $filtersArray = self::getFiltersArray($filters);

            return $filtersArray;
        } catch (\Exception $ex) {
            throw $ex;
        }
    }

    /**
     * Retrieve an array of relationships from a string. [relationship1,relationship2, ...]
     *
     * @param string $params
     *
     * @return array
     */
    private static function getExplodedParams(String $params): array
    {
        $params = str_replace('[', '', $params);
        $params = str_replace(']', '', $params);
        $params = str_replace(' ', '', $params);
        $params = explode(',', $params);

        return $params;
    }

    /**
     * Retrieve an array of filters from a string. [filter1=value1,filter2=value2, ...]
     *
     * @param array $filters
     *
     * @return array
     */
    private static function getFiltersArray(array $filters): array
    {
        $operators = self::getOperators();

        $filtersArray = [];
        foreach ($filters as $filter) {
            foreach ($operators as $k => $v) {
                $params = explode($k, $filter);

                if (count($params) > 1) {
                    if ($params[1] === 'null') {
                        $params[1] = null;
                    }

                    if ($params[1] === 'true') {
                        $params[1] = true;
                    }

                    if ($params[1] === 'false') {
                        $params[1] = false;
                    }

                    $column = $params[0];
                    $operator = $operators[$k];
                    $value = $params[1];

                    if ($operator === 'LIKE') {
                        $value = '%' . $value . '%';
                    }

                    $filtersArray[] = [$column, $operator, $value];
                }
            }
        }

        return $filtersArray;
    }

    /**
     * Filters operators dictionary
     *
     * @return array
     */
    private static function getOperators(): array
    {
        return [
            ':' => '=',
            '!' => '!=',
            '>' => '>',
            '<' => '<',
            '~' => 'LIKE',
            '|' => 'NOT LIKE'
        ];
    }
}
