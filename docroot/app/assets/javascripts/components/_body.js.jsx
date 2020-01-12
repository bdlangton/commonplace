class Body extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      sources: []
    };
    this.handleFormSubmit = this.handleFormSubmit.bind(this)
    this.addNewSource = this.addNewSource.bind(this)
    this.handleDelete = this.handleDelete.bind(this)
    this.deleteSource = this.deleteSource.bind(this)
    this.handleUpdate = this.handleUpdate.bind(this)
    this.updateSource = this.updateSource.bind(this)
  }

  handleFormSubmit(title, source_type) {
    let body = JSON.stringify({source: {title: title, source_type: source_type}})

    fetch('/api/v1/sources', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: body,
    })
    .then((source) => {
      this.addNewSource(source)
    })
  }

  addNewSource(source) {
    this.setState({
      sources: this.state.sources.concat(source)
    })
  }

  handleDelete(id) {
    fetch('/api/v1/sources/${id}',
    {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
        console.log('Item was deleted!')
      })
  }

  deleteSource(id) {
    newSources = this.state.sources.filter((source) => source.id !== id)
    this.setState({
      sources: newSources
    })
  }

  handleUpdate(source) {
    fetch('/api/v1/sources/${source.id}',
    {
      method: 'PUT',
      body: JSON.stringify({source: source}),
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
        this.updateSource(source)
      })
  }  updateSource(source) {
    let newSources = this.state.sources.filter((f) => f.id !== source.id)
    newSources.push(source)
    this.setState({
      sources: newSources
    })
  }

  componentDidMount() {
    fetch('/api/v1/sources.json')
      .then((response) => {return response.json()})
      .then((data) => {this.setState({ sources: data }) });
  }

  render() {
    return(
     <div>
       <NewSource handleFormSubmit={this.handleFormSubmit}/>
       <AllSources sources={this.state.sources} handleDelete={this.handleDelete} handleUpdate={this.handleUpdate}/>
     </div>
    )
  }
}
