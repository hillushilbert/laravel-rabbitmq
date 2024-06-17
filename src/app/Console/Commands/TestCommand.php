<?php

namespace App\Console\Commands;

use App\Jobs\TestQueue;
use Illuminate\Console\Command;

class TestCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:test-command';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        //
        $data = ['name' => 'PHP Tutoriais', 'phone' => '+5511987654321'];
        TestQueue::dispatch($data);
    }
}
