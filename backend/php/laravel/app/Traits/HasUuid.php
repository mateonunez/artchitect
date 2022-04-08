<?php

namespace App\Traits;

trait HasUuid
{

    /**
     * Boot method
     *
     * @return void
     */
    protected static function bootHasUuid()
    {
        static::creating(function ($model) {
            if (!$model->getKey()) {
                $model->{$model->getKeyName()} = (string) \Illuminate\Support\Str::uuid();
            }
        });
    }

    /**
     * Set incrementing id as false
     *
     * @return bool
     */
    public function getIncrementing()
    {
        return false;
    }

    /**
     * Set primary key as string
     *
     * @return string
     */
    public function getKeyType()
    {
        return 'string';
    }
}
