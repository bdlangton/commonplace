const NewSource = (props) => {
  let formFields = {}

  return(
    <form onSubmit={ (e) => { e.preventDefault(); props.handleFormSubmit(formFields.title.value, formFields.source_type.value); e.target.reset();}
}>
     <input ref={input => formFields.title = input} placeholder='Enter the title of the source'/>
     <input ref={input => formFields.source_type = input} placeholder='Enter the source type' />
     <button>Submit</button>
    </form>
  )
}
