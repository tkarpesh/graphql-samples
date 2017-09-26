ProjectsSchema = GraphQL::Schema.define do
  mutation(Types::MutationType)
  query(Types::QueryType)

  id_from_object ->(obj, type, ctx) {
    GraphQL::Schema::UniqueWithinType.encode(
      type.name, obj.id, separator: "-#{ctx[:current_user].graph_token}-")
  }

  object_from_id ->(id, ctx) {
    type_name, obj_id = GraphQL::Schema::UniqueWithinType.decode(
      id, separator: "-#{ctx[:current_user].graph_token}-")
    
    type_name.constantize.find(obj_id)
  }

  resolve_type ->(obj, ctx) {
    case obj
    when Project
      Types::ProjectType
    when User
      Types::UserType
    else
      raise "Unexpected object: #{obj}"
    end
  }
end
