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
            action => 'list_group_item',
            args   => {
                data => 'Hello World',
            },
            expected => '<li class="list-group-item">Hello World</li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group_item',
            args   => {
                data   => 'Hello World',
                active => 1,
            },
            expected => '<li class="list-group-item active">Hello World</li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group_item',
            args   => {
                data    => 'Hello World',
                disable => 1,
            },
            expected => '<li class="list-group-item disabled">Hello World</li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group_item',
            args   => {
                data   => 'Hello World',
                active => 1,
                badge  => { data => '41' },
            },
            expected =>
'<li class="list-group-item active">Hello World<span class="badge">41</span></li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group_item',
            args   => {
                data   => 'Hello World',
                active => 1,
                badge  => { data => '41' },
                switch => 'success',
            },
            expected =>
'<li class="list-group-item list-group-item-success active">Hello World<span class="badge">41</span></li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'list_group',
            args   => {
                items => [
                    {
                        data   => 'Hello World',
                        active => 1,
                    }
                ],
            },
            expected =>
'<ul class="list-group"><li class="list-group-item active">Hello World</li></ul>'
        }

    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item',
            args   => {
                data => 'Hello World',
                href => '#',
            },
            expected => '<a class="list-group-item" href="#">Hello World</a>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item',
            args   => {
                data   => 'Hello World',
                href   => '#',
                active => 1,
            },
            expected =>
              '<a class="list-group-item active" href="#">Hello World</a>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item',
            args   => {
                data    => 'Hello World',
                href    => '#',
                disable => 1,
            },
            expected =>
              '<a class="list-group-item disabled" href="#">Hello World</a>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item',
            args   => {
                data   => 'Hello World',
                active => 1,
                href   => '#',
                badge  => { data => '41' },
            },
            expected =>
'<a class="list-group-item active" href="#">Hello World<span class="badge">41</span></a>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group',
            args   => {
                items => [
                    {
                        data   => 'Hello World',
                        href   => '#',
                        active => 1,
                    }
                ],
            },
            expected =>
'<div class="list-group"><a class="list-group-item active" href="#">Hello World</a></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item',
            args   => {
                data   => 'Hello World',
                button => 1,
            },
            expected =>
'<button class="list-group-item" type="button">Hello World</button>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item',
            args   => {
                data   => 'Hello World',
                button => 1,
                switch => 'success',
            },
            expected =>
'<button class="list-group-item list-group-item-success" type="button">Hello World</button>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group',
            args   => {
                items => [
                    {
                        data   => 'Hello World',
                        button => 1,
                    }
                ],
            },
            expected =>
'<div class="list-group"><button class="list-group-item" type="button">Hello World</button></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item_text',
            args   => {
                data => 'Hello World',
            },
            expected => '<p class="list-group-item-text">Hello World</p>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group_item_heading',
            args   => {
                data => 'Hello World',
            },
            expected => '<h4 class="list-group-item-heading">Hello World</h4>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'linked_group',
            args   => {
                items => [
                    {
                        active => 1,
                        href   => '#',
                        items  => [
                            {
                                action => 'linked_group_item_heading',
                                data   => 'List group item heading',
                            },
                            {
                                action => 'linked_group_item_text',
                                data   => '...',
                            }
                        ],
                    }
                ],
            },
            expected =>
'<div class="list-group"><a class="list-group-item active" href="#"><h4 class="list-group-item-heading">List group item heading</h4><p class="list-group-item-text">...</p></a></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel_body',
            args   => {
                data => 'Basic panel example',
            },
            expected => '<div class="panel-body">Basic panel example</div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'panel',
            args   => {
                body => {
                    data => 'Basic panel example',
                }
            },
            expected =>
'<div class="panel panel-default"><div class="panel-body">Basic panel example</div></div>'
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
