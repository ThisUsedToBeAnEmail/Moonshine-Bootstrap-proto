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
            action => 'text_label',
            args   => {
                data => 'New',
            },
            expected => '<span class="label label-default">New</span>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'text_label',
            args   => {
                data   => 'Primary',
                switch => 'primary',
            },
            expected => '<span class="label label-primary">Primary</span>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'text_label',
            args   => {
                data   => 'Success',
                switch => 'success',
            },
            expected => '<span class="label label-success">Success</span>'
        }

    );

    component_test(
        {
            class  => $class,
            action => 'text_label',
            args   => {
                data   => 'Warning',
                switch => 'warning',
            },
            expected => '<span class="label label-warning">Warning</span>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'text_label',
            args   => {
                data   => 'Info',
                switch => 'info',
            },
            expected => '<span class="label label-info">Info</span>'
        }

    );

    component_test(
        {
            class  => $class,
            action => 'text_label',
            args   => {
                data   => 'Danger',
                switch => 'danger',
            },
            expected => '<span class="label label-danger">Danger</span>'
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
