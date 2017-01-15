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
            class    => $class,
            action   => 'row',
            args     => {},
            expected => '<div class="row"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { md => 6 },
            expected => '<div class="col-md-6"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { xs => 6 },
            expected => '<div class="col-xs-6"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { sm => 6 },
            expected => '<div class="col-sm-6"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { xs => 6, md => 6, sm => 6 },
            expected => '<div class="col-md-6 col-sm-6 col-xs-6"></div>'
        }
    );

    my @first_row_cols = map {
        ;
        { action => 'col', md => 1, data => '.col-md-1' };
    } 1 .. 12;

    component_test(
        {
            class  => $class,
            action => 'row',
            args   => { children => \@first_row_cols },
            expected =>
'<div class="row"><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div></div>',
        }
    );

    my @children =
      map { { action => 'col', md => 1, data => '.col-md-1' } } 1 .. 12;

    my @one =
      map { { action => 'col', md => $_, data => ".col-md-$_" } } qw/8 4/;

    my @two = map { { action => 'col', md => 4, data => ".col-md-4" } } 1 .. 3;

    my @three =
      map { { action => 'col', md => 6, data => ".col-md-6" } } 1 .. 2;

    my @after_element =
      map { { action => 'row', children => $_ }, } ( \@one, \@two, \@three );

    component_test(
        {
            class  => $class,
            action => 'row',
            args =>
              { children => \@children, after_element => \@after_element },
            expected =>
'<div class="row"><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div><div class="col-md-1">.col-md-1</div></div><div class="row"><div class="col-md-8">.col-md-8</div><div class="col-md-4">.col-md-4</div></div><div class="row"><div class="col-md-4">.col-md-4</div><div class="col-md-4">.col-md-4</div><div class="col-md-4">.col-md-4</div></div><div class="row"><div class="col-md-6">.col-md-6</div><div class="col-md-6">.col-md-6</div></div>',
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'container',
            args     => {},
            expected => '<div class="container"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'container',
            args     => { container => 'fluid' },
            expected => '<div class="container-fluid"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'clearfix',
            args     => {},
            expected => '<div class="clearfix visible-xs-block"></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'col',
            args =>
              { md => 4, md_offset => 4, data => '.col-md-4 .col-md-offset-4' },
            expected =>
'<div class="col-md-4 col-md-offset-4">.col-md-4 .col-md-offset-4</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'col',
            args =>
              { sm => 4, sm_offset => 4, data => '.col-md-4 .col-md-offset-4' },
            expected =>
'<div class="col-sm-4 col-sm-offset-4">.col-md-4 .col-md-offset-4</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'col',
            args   => { xs => 6, xs_offset => 3, sm => 4, sm_offset => 0 },
            expected =>
'<div class="col-sm-4 col-sm-offset-0 col-xs-6 col-xs-offset-3"></div>',
        }
    );

    # NESTED
    component_test(
        {
            class  => $class,
            action => 'row',
            args   => {
                children => [
                    {
                        action   => 'col',
                        sm       => 9,
                        data     => 'Level 1: .col-sm-9',
                        children => [
                            {
                                action   => 'row',
                                children => [
                                    {
                                        action => 'col',
                                        xs     => 8,
                                        sm     => 6,
                                        data => 'Level 2: .col-xs-8 .col-sm-6',
                                    },
                                    {
                                        action => 'col',
                                        xs     => 4,
                                        sm     => 6,
                                        data => 'Level 2: .col-xs-4 .col-sm-6',
                                    }
                                ]
                            }

                        ]
                    }
                ]
            },
            expected =>
'<div class="row"><div class="col-sm-9">Level 1: .col-sm-9<div class="row"><div class="col-sm-6 col-xs-8">Level 2: .col-xs-8 .col-sm-6</div><div class="col-sm-6 col-xs-4">Level 2: .col-xs-4 .col-sm-6</div></div></div></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'col',
            args =>
              { md => 9, md_push => 3, data => '.col-md-9 .col-md-push-3' },
            expected =>
'<div class="col-md-9 col-md-push-3">.col-md-9 .col-md-push-3</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'col',
            args =>
              { md => 3, md_pull => 9, data => '.col-md-3 .col-md-pull-9' },
            expected =>
'<div class="col-md-3 col-md-pull-9">.col-md-3 .col-md-pull-9</div>',
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

sub dead_test {
    my $args = shift;

    my $action = $args->{action};
    eval { $args->{class}->$action( $args->{args} // {} ) };
    my $error = $@;
    return like( $error, $args->{expected}, "got expected $args->{expected}" );
}

done_testing();
