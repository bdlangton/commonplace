class Source extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      editable: false
    }
    this.handleEdit = this.handleEdit.bind(this)
  }

  handleEdit() {
    if(this.state.editable){
      let title = this.title.value
      let source_type = this.source_type.value
      let id = this.props.source.id
      let source = {id: id, title: title, source_type: source_type}
      this.props.handleUpdate(source)
    }
    this.setState({
      editable: !this.state.editable
    })
  }

  render() {
    let title = this.state.editable ? <input type='text' ref={input => this.title = input} defaultValue={this.props.source.title}/>:<h3>{this.props.source.title}</h3>
    let source_type = this.state.editable ? <input type='text' ref={input => this.source_type = input} defaultValue={this.props.source.source_type}/>:<p>{this.props.source.source_type}</p>
    return(
      <div>
        {title}
        {source_type}
        <button onClick={() => this.handleEdit()}>{this.state.editable? 'Submit' : 'Edit'}</button>
        <button onClick={() => this.props.handleDelete(this.props.source.id)}>Delete</button>
      </div>
    )
  }
}
