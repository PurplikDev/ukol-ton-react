const items = [
      { title: 'First', id: 1 },
      { title: 'Second', id: 2 },
      { title: 'Third', id: 3 },
      { title: 'sdfsdfsdfdsfsdfsdf', id: 4 },
    ];

function ListGroup() {
      const listItems = items.map(item =>
            <li className="list-group-item" key={item.id}>
                  <ListElement title={item.title} item_id={item.id}> </ListElement>
            </li>
      )

      return <ul className="list-group">{listItems}</ul>;
}

function ListElement(item: any) {
      return <div className="list-element">
            <div className="list-element-id">{item.item_id}</div>
            <div className="list-element-title">{item.title}</div>
            <div className="list-element-misc">haiii</div>
      </div>
}

export default ListGroup;