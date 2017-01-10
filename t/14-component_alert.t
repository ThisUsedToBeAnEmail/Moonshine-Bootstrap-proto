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
            action => 'alert',
            args   => {
                data   => 'Primary',
                switch => 'primary',
            },
            expected => '<div class="alert alert-primary">Primary</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'alert',
            args   => {
                data   => 'Success',
                switch => 'success',
            },
            expected => '<div class="alert alert-success">Success</div>'
        }

    );

    component_test(
        {
            class  => $class,
            action => 'alert',
            args   => {
                data   => 'Warning',
                switch => 'warning',
            },
            expected => '<div class="alert alert-warning">Warning</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'alert',
            args   => {
                data   => 'Info',
                switch => 'info',
            },
            expected => '<div class="alert alert-info">Info</div>'
        }

    );

    component_test(
        {
            class  => $class,
            action => 'alert',
            args   => {
                data   => 'Danger',
                switch => 'danger',
            },
            expected => '<div class="alert alert-danger">Danger</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'alert',
            args   => {
                link   => { data => 'Danger', href => '#' },
                switch => 'danger',
            },
            expected =>
'<div class="alert alert-danger"><a class="alert-link" href="#">Danger</a></div>'
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
