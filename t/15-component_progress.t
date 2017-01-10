use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60' },
            expected =>
'<div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="1" aria-valuenow="60" role="progressbar"><span class="sr-only">60%</span></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60', show => 1 },
            expected =>
'<div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="1" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'progress',
            args     => {},
            expected => '<div class="progress"></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress',
            args   => { bar => { aria_valuenow => '60' } },
            expected =>
'<div class="progress"><div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="1" aria-valuenow="60" role="progressbar"><span class="sr-only">60%</span></div></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress',
            args   => { bar => { aria_valuenow => '60', show => 1 } },
            expected =>
'<div class="progress"><div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="1" aria-valuenow="60" role="progressbar">60%</div></div>',
        }
    );

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    return is( $element->render, $args->{expected},
        "got expected $args->{expected}" );
}

done_testing();
