const AllSources = (props) => {

  var sources = props.sources.map((source) => {
    return(
     <div key={source.id}>
       <Source source={source} handleDelete={props.handleDelete} handleUpdate={props.handleUpdate}/>
     </div>
    )
  })

  return(
    <div>
     {sources}
    </div>
  )
}
